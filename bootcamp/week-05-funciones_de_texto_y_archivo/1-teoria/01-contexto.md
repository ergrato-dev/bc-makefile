# Funciones de Texto y Archivo en Make

## ¿Por qué importa esto?

Un Makefile con fuentes hardcodeadas es deuda técnica desde el primer día: cada archivo nuevo exige editar el Makefile a mano, cada renombrado rompe la build. Las funciones de texto de Make eliminan ese problema — descubren los archivos en disco, transforman sus rutas y filtran subconjuntos, todo en tiempo de evaluación, antes de ejecutar una sola receta.

## Referencia rápida

| Función | Qué hace | Ejemplo → Resultado |
|---------|----------|---------------------|
| `$(wildcard pat)` | Lista archivos que coinciden en disco | `$(wildcard src/*.c)` → `src/a.c src/b.c` |
| `$(patsubst pat,rep,text)` | Sustituye con comodín `%` | `$(patsubst src/%.c,build/%.o,src/a.c)` → `build/a.o` |
| `$(subst from,to,text)` | Sustituye texto literal | `$(subst .c,.o,a.c b.c)` → `a.o b.o` |
| `$(filter pat,text)` | Conserva palabras que coinciden | `$(filter %.c,a.c b.h c.c)` → `a.c c.c` |
| `$(filter-out pat,text)` | Elimina palabras que coinciden | `$(filter-out %.h,a.c b.h)` → `a.c` |
| `$(dir names)` | Extrae directorio (con `/` final) | `$(dir src/main.c)` → `src/` |
| `$(notdir names)` | Extrae nombre sin directorio | `$(notdir src/main.c)` → `main.c` |
| `$(basename names)` | Elimina extensión | `$(basename src/main.c)` → `src/main` |
| `$(suffix names)` | Extrae extensión | `$(suffix src/main.c)` → `.c` |
| `$(addprefix pre,names)` | Agrega prefijo a cada palabra | `$(addprefix -I,src inc)` → `-Isrc -Iinc` |
| `$(addsuffix suf,names)` | Agrega sufijo a cada palabra | `$(addsuffix /,src inc)` → `src/ inc/` |
| `$(sort list)` | Ordena y deduplica | `$(sort b a a c)` → `a b c` |
| `$(words list)` | Cuenta palabras | `$(words a b c)` → `3` |

## Ejemplo mínimo funcional

Pega esto en un directorio con `src/main.c` y ejecuta `make demo`:

```makefile
.PHONY: demo
.DEFAULT_GOAL := demo

SRCS      := $(wildcard src/*.c)
OBJS      := $(patsubst src/%.c,build/%.o,$(SRCS))
C_ONLY    := $(filter %.c,$(SRCS))
BASENAMES := $(notdir $(SRCS))
INCS      := $(addprefix -I,include)

demo:
	@echo "Fuentes:   $(SRCS)"
	@echo "Objetos:   $(OBJS)"
	@echo "Solo .c:   $(C_ONLY)"
	@echo "Nombres:   $(BASENAMES)"
	@echo "Includes:  $(INCS)"
	@echo "Total:     $(words $(SRCS)) archivos"
```

## Combinación típica en build systems

El trío `wildcard + patsubst + pattern rule` es el núcleo de cualquier build system C moderno:

```makefile
SRCS := $(wildcard src/*.c)
OBJS := $(patsubst src/%.c,build/%.o,$(SRCS))

build/%.o: src/%.c
	@mkdir -p $(dir $@)
	$(CC) -c $< -o $@
```

`$(wildcard)` descubre, `$(patsubst)` transforma, el pattern rule compila. Agregar un archivo nuevo a `src/` es suficiente — el Makefile no necesita cambiar.

---

Listo. Ve al [lab-01](../2-practicas/lab-01-wildcard/README.md) y ponlo en práctica.
