# Funciones Avanzadas de Make

## ¿Por qué importa esto?

Las funciones de la semana anterior transforman listas de archivos. Estas cuatro hacen algo diferente: te permiten *programar* Make. Con `$(foreach)` eliminas loops manuales. Con `$(call)` defines funciones reutilizables. Con `$(eval)` generas reglas en tiempo de carga. Con `$(shell)` consultas el sistema operativo. Combinadas, producen un Makefile que se adapta solo a la estructura del proyecto.

## Referencia rápida

| Función | Sintaxis | Qué hace | Resultado típico |
|---------|----------|----------|-----------------|
| `$(foreach var,list,text)` | `$(foreach m,a b c,$(m).o)` | Expande `text` para cada item de `list` | `a.o b.o c.o` |
| `$(call name,arg1,...)` | `$(call mi_fn,valor)` | Invoca función definida con `define`; `$1` es arg1 | Expansión de la plantilla |
| `$(eval text)` | `$(eval VAR := foo)` | Parsea `text` como sintaxis Makefile real | Efecto: nueva regla o variable |
| `$(shell cmd)` | `$(shell date +%Y)` | Ejecuta en shell, captura stdout | `2026` |

## El truco del `$$` en `$(eval)`

Dentro de un bloque `define` usado con `$(eval $(call ...))`, las variables automáticas deben escribirse con `$$`:

```makefile
define COMPILE_RULE
$(BUILD)/$(1).o: src/$(1).c
	$(CC) -c $$< -o $$@
endef

$(eval $(call COMPILE_RULE,main))
```

Cadena de expansión: `$(call)` convierte `$1→main` y `$$<→$<`. Luego `$(eval)` parsea `$<` y `$@` como variables automáticas normales.

## Ejemplo mínimo funcional

Pega esto en un directorio vacío y ejecuta `make demo`:

```makefile
.PHONY: demo
.DEFAULT_GOAL := demo

CC      := gcc
MODULES := auth logger config

define MOD_RULE
.PHONY: info-$(1)
info-$(1):
	@echo "$(1): src/$(1).c → build/$(1).o"
endef

OBJS       := $(foreach mod,$(MODULES),build/$(mod).o)
BUILD_DATE := $(shell date +%Y-%m-%d)
GIT_HASH   := $(shell git rev-parse --short HEAD 2>/dev/null || echo sin-git)

$(foreach mod,$(MODULES),$(eval $(call MOD_RULE,$(mod))))

demo:
	@echo "=== Build System ==="
	@echo "Fecha:    $(BUILD_DATE)"
	@echo "Git:      $(GIT_HASH)"
	@echo "Objetos:  $(OBJS)"
	@echo "Targets generados: info-auth info-logger info-config"
```

## Notas importantes

- `$(shell ...)` se ejecuta en tiempo de evaluación del Makefile, no al correr la receta. Si el Makefile se re-evalúa, el shell se vuelve a llamar.
- `$(eval ...)` solo crea reglas y variables — no puede hacer bifurcaciones como un lenguaje de programación.
- Cuando el comando de `$(shell)` puede fallar (ej. no hay repo git), agrega un fallback: `$(shell git ... 2>/dev/null || echo sin-git)`.

---

Listo. Ve al [lab-01](../2-practicas/lab-01-foreach/README.md) y ponlo en práctica.
