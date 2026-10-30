# ============================================================
# Proyecto Semana 04 — Build system C multi-archivo
# ============================================================
# Instrucciones:
#   1. Completa cada TODO usando variables automáticas ($@, $<, $^, $(@D))
#   2. NO escribas ningún nombre de archivo (.c, .o) en las recetas
#   3. Verifica con: make all && ./build/app
# ============================================================

# TODO: preámbulo estricto de la semana 03 (va antes que todo lo demás):
#   SHELL       := bash
#   .SHELLFLAGS := -eu -o pipefail -c
#   .DELETE_ON_ERROR:

.PHONY: all dist clean help

.DEFAULT_GOAL := help

# ── Compilador ────────────────────────────────────────────────
# TODO: define CC con := y valor "gcc" (no ?=: CC ya vale "cc" de serie, ver rúbrica pregunta 9)
# TODO: define CFLAGS con ?= y valor "-Wall -Wextra -std=c11"
# TODO: define LDFLAGS con := y valor vacío (para flags del linker)

# ── Rutas ─────────────────────────────────────────────────────
# TODO: define SRC_DIR con := y valor "src"
# TODO: define BUILD_DIR con := y valor "build"
# TODO: define INC_DIR con := y valor "include"
# TODO: define APP con := como $(BUILD_DIR)/app
# TODO: define DIST_DIR con := y valor "dist"

# ── Empaquetado ───────────────────────────────────────────────
# TODO: define VERSION con ?= y valor "1.0.0"
# TODO: define TARBALL con := como $(DIST_DIR)/app-$(VERSION).tar.gz

# ── Fuentes y objetos ─────────────────────────────────────────
# TODO: define SRCS con := usando $(wildcard $(SRC_DIR)/*.c)
# TODO: define OBJS derivando desde SRCS:
#       OBJS := $(SRCS:$(SRC_DIR)/%.c=$(BUILD_DIR)/%.o)
# TODO: define DEPS := $(OBJS:.o=.d)  (un .d de dependencias por objeto)

all: $(APP) ## compila el proyecto completo

# ── Regla de enlace ───────────────────────────────────────────
$(APP): $(OBJS)
	# TODO: enlaza con $(CC) $(LDFLAGS) y usa $^ para los objetos y $@ para la salida
	# TODO: imprime "[link] $@ listo."

# ── Regla genérica de compilación ────────────────────────────
# Esta regla compila CUALQUIER .c en src/ a su .o en build/
$(BUILD_DIR)/%.o: $(SRC_DIR)/%.c
	# TODO: crea el directorio con @mkdir -p $(@D)
	# TODO: compila con $(CC) $(CFLAGS) -MMD -MP -I$(INC_DIR) usando $< para la fuente y $@ para el objeto
	# TODO: imprime "[cc]   $< → $@"

# TODO: carga los .d con -include $(DEPS)  (el guion evita el error la primera vez)

# TODO (sección 6): target 'dist' (.PHONY) que dependa de $(TARBALL), y la
# regla del archivo $(TARBALL) que dependa de $(APP). Receta, sin escribir
# ninguna ruta:
#   - crea el directorio del tarball con mkdir -p y $(@D)
#   - tar -czf $@ -C $(<D) $(<F)     (entra en build/ y guarda solo "app")
#   - imprime "[dist] $@ listo."
dist: ## empaqueta el binario en dist/app-$(VERSION).tar.gz
	@echo "TODO: implementa dist"

# TODO: en 'clean', guarda + borrado seguro (semana 03), también para dist/. Receta:
#   $(if $(BUILD_DIR),,$(error BUILD_DIR vacía: rm -rf no se ejecuta))
#   $(if $(DIST_DIR),,$(error DIST_DIR vacía: rm -rf no se ejecuta))
#   @rm -rf -- '$(BUILD_DIR)' '$(DIST_DIR)'
clean: ## elimina todos los artefactos de build
	@echo "[clean] Listo."

help: ## muestra esta ayuda
	@echo "Uso: make [target] [CC=compilador] [CFLAGS=flags] [VERSION=x.y.z]"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
		| awk 'BEGIN {FS = ":.*?## "}; {printf "  %-20s %s\n", $$1, $$2}'
