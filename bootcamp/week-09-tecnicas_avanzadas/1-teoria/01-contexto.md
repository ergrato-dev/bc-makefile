# Técnicas Avanzadas de Make

## ¿Por qué importa esto?

Un Makefile que solo funciona en un entorno, para un equipo o para un proyecto no escala. Los Makefiles profesionales se adaptan al contexto con condicionales, se organizan en módulos reutilizables con `include`, y coordinan repositorios complejos con recursión. Cuando algo falla, sabes cómo depurarlo. Esta semana cierra la brecha entre "saber Make" y "diseñar infraestructura de build con Make".

## Condicionales

```makefile
ENV ?= development

ifeq ($(ENV), production)
  FLAGS := -O2 --minify
else
  FLAGS := -g --source-maps
endif

# ifdef comprueba si la variable está definida (no si es vacía)
ifdef CI
  PARALLEL := -j4
endif
```

| Directiva | Evalúa | Cuándo usarlo |
|-----------|--------|---------------|
| `ifeq (a, b)` | ¿a == b? | Comparar valor de variable |
| `ifneq (a, b)` | ¿a != b? | Excluir un valor específico |
| `ifdef VAR` | ¿VAR definida? | Detectar presencia de variable |
| `ifndef VAR` | ¿VAR no definida? | Aplicar default solo si falta |

Los condicionales se evalúan al parsear, antes de ejecutar cualquier receta. No pueden depender de la salida de comandos en la receta.

## Include y módulos

```makefile
# mk/colors.mk — módulo de utilidades visuales
RED   := \033[0;31m
GREEN := \033[0;32m
RESET := \033[0m
log-ok  = @printf "$(GREEN)✓ %s$(RESET)\n" "$1"
log-err = @printf "$(RED)✗ %s$(RESET)\n" "$1"
```

```makefile
# Makefile principal
include mk/colors.mk
include mk/build.mk
-include mk/local.mk   # opcional: no falla si no existe

build: compile
	$(call log-ok, Build completado)
```

## Recursión

```makefile
MODULES := api worker frontend

all: $(MODULES)

$(MODULES):
	$(MAKE) -C $@ build

clean:
	@for mod in $(MODULES); do $(MAKE) -C $$mod clean; done

.PHONY: all clean $(MODULES)
```

`$(MAKE) -C directorio` ejecuta el Makefile del subdirectorio. Las variables del padre no pasan automáticamente — usa `export` o pásalas en la línea de comando: `$(MAKE) -C api ENV=$(ENV)`.

## Depuración

```makefile
debug-vars: ## Mostrar variables de diagnóstico
	$(info APP   = $(APP))
	$(info FLAGS = $(FLAGS))
	$(info PATH  = $(PATH))
	@echo "Depuración completada"
```

| Técnica | Comando / Función | Qué muestra |
|---------|-------------------|-------------|
| Dry-run | `make -n` | Comandos sin ejecutarlos |
| Traza completa | `make --debug=v` | Decisiones de dependencias |
| Traza básica | `make --debug=b` | Qué targets se reconstruyen |
| Info en parsing | `$(info texto)` | Imprime al parsear (sin @) |
| Advertencia | `$(warning texto)` | Como `$(info)` pero a stderr |
| Error fatal | `$(error texto)` | Detiene Make inmediatamente |
| Ver base de datos | `make -p` | Todas las variables y reglas |

## Ejemplo mínimo funcional

```makefile
.PHONY: all build info debug-vars help
.DEFAULT_GOAL := help

ENV     ?= development
VERSION := $(shell git describe --tags --always 2>/dev/null || echo 0.0.0)

ifeq ($(ENV), production)
  BUILD_FLAGS := --release
else
  BUILD_FLAGS := --debug
endif

ifdef CI
  $(info Ejecutando en CI — modo paralelo activado)
  MAKEFLAGS += -j4
endif

all: build ## Construir proyecto

build: ## Compilar con flags del entorno
	@echo "Compilando $(VERSION) con $(BUILD_FLAGS)"

info: ## Mostrar configuración actual
	$(info ENV         = $(ENV))
	$(info BUILD_FLAGS = $(BUILD_FLAGS))
	$(info VERSION     = $(VERSION))
	@echo "Configuración mostrada."

debug-vars: ## Diagnóstico de variables
	$(info MAKEFLAGS = $(MAKEFLAGS))
	$(warning Esta es una advertencia de depuración)
	@echo "Debug completado."

help: ## Mostrar ayuda
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
		| awk 'BEGIN {FS = ":.*?## "}; {printf "  %-20s %s\n", $$1, $$2}'
```

---

Listo. Ve al [lab-01](../2-practicas/lab-01-condicionales/README.md) y ponlo en práctica.
