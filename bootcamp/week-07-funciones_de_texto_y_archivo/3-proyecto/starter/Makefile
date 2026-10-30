.PHONY: all build clean manifest report help
.DEFAULT_GOAL := help

CC    := gcc
BUILD := build

# --- Variables de fuentes (completa con funciones de texto) ---

# TODO: Descubre fuentes del core con $(wildcard src/*.c)
CORE_SRCS :=

# TODO: Descubre fuentes de módulos con $(wildcard modules/*/*.c)
MODULE_SRCS :=

# TODO: Combina ambas listas
ALL_SRCS :=

# TODO: Genera rutas de objetos conservando estructura de directorios
# src/main.c       → build/src/main.o
# modules/auth/auth.c → build/modules/auth/auth.o
OBJS :=

# TODO: Obtén directorios únicos de los módulos para los flags -I
# Tip: $(sort $(dir $(MODULE_SRCS)))
MODULE_DIRS :=

# TODO: Agrega flags -I para cada directorio de módulo a CFLAGS
CFLAGS := -Wall -Wextra -std=c11

TARGET := $(BUILD)/sistema

# --- Targets ---

all: build ## Compila el sistema completo

build: $(TARGET) ## Enlaza el programa final

# TODO: Define la regla de enlazado con $(OBJS) como prerequisito
$(TARGET):
	@echo "Completa los TODOs en las variables antes de compilar"
	@exit 1

# TODO: Define la regla de compilación genérica
# Tip: usa $(@D) para crear el directorio padre del objeto
$(BUILD)/%.o: %.c
	# TODO: implementar

manifest: ## Genera build/manifest.txt con lista de fuentes
	@mkdir -p $(BUILD)
	# TODO: escribe ALL_SRCS en build/manifest.txt (una fuente por línea)
	@echo "Manifest no implementado"

report: ## Muestra estadísticas del proyecto usando funciones de texto
	@echo "=== Reporte del Proyecto ==="
	# TODO: Muestra conteo de fuentes core (notdir para listar nombres)
	# TODO: Muestra conteo de fuentes de módulos
	# TODO: Muestra MODULE_DIRS
	# TODO: Muestra nombre del target sin directorio ni extensión
	# TODO: Muestra total de objetos
	@echo "(implementa los TODOs de report)"

clean: ## Elimina archivos generados
	rm -rf $(BUILD)

help: ## Muestra esta ayuda
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
		| awk 'BEGIN {FS = ":.*?## "}; {printf "  %-20s %s\n", $$1, $$2}'
