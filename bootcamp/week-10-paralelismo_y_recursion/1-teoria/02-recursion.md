# Recursión segura y Make no recursivo

## ¿Por qué importa esto?

Casi todo monorepo acaba con un Makefile raíz que entra en cada subdirectorio. Mal escrito, ese Makefile se traga los fallos (el CI sale en verde con un paquete roto), ignora `-j`, no respeta `-n` y lanza el binario de Make equivocado. Bien escrito, cada subdirectorio es un nodo del grafo y todo lo que sabes de Make sigue funcionando.

## Referencia rápida

| Pieza | Qué hace |
|---|---|
| `$(MAKE) -C dir meta` | Sub-make en `dir`: mismo binario, mismos flags, mismo jobserver |
| `+` al inicio de una línea | La marca como recursiva aunque `$(MAKE)` no aparezca literal |
| `MAKEFLAGS` | Flags (`-k`, `-n`, `-s`, `-j` + jobserver) y variables de línea de comandos que heredan los hijos |
| `MAKELEVEL` | Profundidad: 0 en el raíz, 1 en un sub-make |
| `export VAR` | Pasa una variable del Makefile al entorno de los sub-makes |

## `$(MAKE)`, nunca `make`

Make trata de forma especial las líneas que contienen `$(MAKE)` literalmente (o que empiezan con `+`):

- Les da acceso al **jobserver**: con `make -j8`, todo el árbol de sub-makes comparte 8 fichas. En 4.3, un `make` literal recibe `-j8` pero no las fichas y avisa: `jobserver unavailable: using -j1. Add '+' to parent make rule.`
- Las ejecuta incluso con `-n`, `-t` o `-q`, para que el sub-make muestre su propio plan.
- `$(MAKE)` vale el binario con el que lanzaste el build: `gmake` en macOS, no la 3.81 del sistema.

Nunca escribas `-j` dentro de una receta: el hijo crea su propio jobserver (`-jN forced in submake`) y multiplica los trabajos.

## Subdirectorios como targets

Crea un ejemplo de dos módulos y pega el Makefile raíz:

```bash
mkdir -p demo/api demo/web && cd demo
printf 'build test:\n\t@echo "[$(notdir $(CURDIR))] $@"\n\t@test "$(FAIL)" != "$(notdir $(CURDIR))"\n' | tee api/Makefile > web/Makefile
```

```makefile
SHELL       := bash
.SHELLFLAGS := -eu -o pipefail -c

MODULES := api web
GOALS   := build test
TARGETS := $(foreach g,$(GOALS),$(addsuffix /$(g),$(MODULES)))

.PHONY: all test $(TARGETS)

all: $(addsuffix /build,$(MODULES))
test: $(addsuffix /test,$(MODULES))

# web consume lo que construye api
web/build: api/build

$(TARGETS):
	@$(MAKE) --no-print-directory -C $(@D) $(@F)
```

```bash
make -j2 all                          # api primero, después web
make test FAIL=api; echo "exit=$?"    # exit=2: el fallo se propaga
make -k test FAIL=api                 # web/test se ejecuta igualmente
```

Compáralo con `for d in $(MODULES); do $(MAKE) -C $$d test; done`: sin `-e`, el código de salida es el del último módulo; con `-e`, se para en el primero, pero sigue siendo una sola receta que `-j` no puede repartir ni `-k` continuar. Las dependencias entre módulos (`web/build: api/build`) solo se pueden expresar si cada módulo es un target.

## Qué llega a un sub-make

| Llega | No llega |
|---|---|
| Variables de la línea de comandos (`make all STAGE=prod`), dentro de `MAKEFLAGS`, y con prioridad sobre lo que asigne el hijo | Variables definidas en el Makefile padre sin `export` |
| Variables de entorno y las que exportas con `export VAR` | `-C`, `-f`, `-o` y `-W`: no se ponen en `MAKEFLAGS` |
| Flags como `-k`, `-n`, `-s`, `-O` y el jobserver de `-j` | |

Exporta por nombre (`export STAGE`). `export` a secas exporta todas las variables, incluidas las que nunca deberían salir de este Makefile.

## La alternativa: un solo grafo

*Recursive Make Considered Harmful* (Peter Miller, 1997) señala el límite de fondo: cada sub-make ve solo su trozo del grafo. Si `app/` enlaza con `../lib/libx.a`, `make -C app` no sabe reconstruir la librería.

El Make no recursivo incluye un fragmento por directorio en un único Make:

```makefile
MODULES := lib app            # el orden importa: app usa $(LIB)
include $(addsuffix /module.mk,$(MODULES))
```

Cada `module.mk` usa rutas relativas a la raíz (`lib/greet.c`) y nombres de variable propios (`LIB_OBJS`). A cambio, `-j`, `-n` y las dependencias de headers funcionan entre directorios sin ningún sub-make. Para un monorepo de paquetes independientes, la recursión bien hecha basta; cuando hay muchas dependencias cruzadas, compensa el grafo único.

Listo. Ve al [lab-04](../2-practicas/lab-04-recursion/README.md) para la recursión, al [lab-05](../2-practicas/lab-05-jobserver/README.md) para el jobserver y al [lab-06](../2-practicas/lab-06-no-recursivo/README.md) para el grafo único.
