# Funciones de Texto y Archivo en Make

## ¿Por qué importa esto?

Un Makefile con fuentes hardcodeadas es deuda técnica desde el primer día: cada archivo nuevo exige editar el Makefile a mano, cada renombrado rompe la build. Las funciones de texto de Make eliminan ese problema: descubren los archivos en disco, transforman sus rutas y filtran subconjuntos, todo al leer el Makefile, antes de ejecutar una sola receta.

Todas trabajan sobre **listas de palabras separadas por espacios**. Make no conoce "archivos" ni "rutas": solo texto. Por eso un nombre con espacios rompe cualquier Makefile, y por eso un espacio de más en un argumento produce bugs silenciosos (lo verás en [02-trampas-y-utilidades.md](02-trampas-y-utilidades.md)).

## Referencia rápida

| Función | Qué hace | Ejemplo → Resultado |
|---------|----------|---------------------|
| `$(wildcard pat)` | Lista archivos que existen en disco | `$(wildcard src/*.c)` → `src/a.c src/b.c` |
| `$(patsubst pat,rep,text)` | Sustituye palabra a palabra con comodín `%` | `$(patsubst src/%.c,build/%.o,src/a.c)` → `build/a.o` |
| `$(subst from,to,text)` | Sustituye texto literal, esté donde esté | `$(subst -,_,a-b c-d)` → `a_b c_d` |
| `$(filter pat...,text)` | Conserva palabras que casan con algún patrón | `$(filter %.c,a.c b.h c.c)` → `a.c c.c` |
| `$(filter-out pat...,text)` | Elimina palabras que casan | `$(filter-out %.h,a.c b.h)` → `a.c` |
| `$(dir names)` | Directorio, con `/` final | `$(dir src/main.c)` → `src/` |
| `$(notdir names)` | Nombre sin directorio | `$(notdir src/main.c)` → `main.c` |
| `$(basename names)` | Quita la extensión | `$(basename src/main.c)` → `src/main` |
| `$(suffix names)` | Solo la extensión | `$(suffix src/main.c)` → `.c` |
| `$(addprefix pre,names)` | Prefijo a cada palabra | `$(addprefix -I,src inc)` → `-Isrc -Iinc` |
| `$(addsuffix suf,names)` | Sufijo a cada palabra | `$(addsuffix /,src inc)` → `src/ inc/` |
| `$(sort list)` | Ordena y elimina duplicados | `$(sort b a a c)` → `a b c` |
| `$(strip text)` | Quita espacios sobrantes | `$(strip  a   b )` → `a b` |
| `$(words list)` | Cuenta palabras | `$(words a b c)` → `3` |
| `$(word n,list)` | Palabra número `n` (desde 1) | `$(word 2,a b c)` → `b` |

## Ejemplo mínimo funcional

En un directorio vacío, crea dos fuentes y pega el Makefile:

```bash
mkdir -p src && touch src/main.c src/util.c
```

```makefile
SHELL       := bash
.SHELLFLAGS := -eu -o pipefail -c
.DELETE_ON_ERROR:

.PHONY: demo
.DEFAULT_GOAL := demo

SRCS  := $(wildcard src/*.c)
OBJS  := $(patsubst src/%.c,build/%.o,$(SRCS))
NAMES := $(notdir $(SRCS))
INCS  := $(addprefix -I,include src)

demo:
	@echo "Fuentes:   $(SRCS)"
	@echo "Objetos:   $(OBJS)"
	@echo "Nombres:   $(NAMES)"
	@echo "Includes:  $(INCS)"
	@echo "Total:     $(words $(SRCS)) archivos, el primero es $(word 1,$(SRCS))"
```

```
$ make
Fuentes:   src/main.c src/util.c
Objetos:   build/main.o build/util.o
Nombres:   main.c util.c
Includes:  -Iinclude -Isrc
Total:     2 archivos, el primero es src/main.c
```

`$(wildcard)` devuelve los archivos **ordenados** desde Make 4.3 (entre 3.82 y 4.2 no lo estaban). Si tu Makefile depende del orden y debe funcionar en versiones antiguas, usa `$(sort $(wildcard ...))`.

## Combinación típica en build systems

El trío `wildcard + patsubst + regla de patrón` es el núcleo de cualquier build C que no se edita al añadir archivos. Con un `src/main.c` que tenga `main()`:

```bash
mkdir -p src && printf 'int main(void) { return 0; }\n' > src/main.c && rm -f src/util.c
```

```makefile
SHELL       := bash
.SHELLFLAGS := -eu -o pipefail -c
.DELETE_ON_ERROR:

.PHONY: all clean
.DEFAULT_GOAL := all

CC    := gcc
BUILD := build
SRCS  := $(wildcard src/*.c)
OBJS  := $(patsubst src/%.c,$(BUILD)/%.o,$(SRCS))

all: $(BUILD)/app

$(BUILD)/app: $(OBJS)
	$(CC) $^ -o $@

$(BUILD)/%.o: src/%.c
	@mkdir -p $(@D)
	$(CC) -c $< -o $@

clean:
	$(if $(BUILD),,$(error BUILD vacía: rm -rf no se ejecuta))
	rm -rf -- '$(BUILD)'
```

`$(wildcard)` descubre, `$(patsubst)` transforma, la regla de patrón compila. Añadir un `.c` a `src/` basta: el Makefile no cambia.

## Cuándo se evalúa

Con `:=`, `$(wildcard)` mira el disco **una vez, al leer esa línea**. Un archivo que una receta genera durante el build no aparece en esa lista: los archivos generados se listan explícitamente, no se descubren. Y `$(wildcard)` no es recursivo: `src/*.c` no baja a `src/net/`; para eso añades `src/*/*.c`.

---

Listo. Ve al [lab-01](../2-practicas/lab-01-wildcard/README.md) y ponlo en práctica; antes del lab-02 lee [02-trampas-y-utilidades.md](02-trampas-y-utilidades.md).
