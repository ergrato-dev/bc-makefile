# TODO: preámbulo estricto de la semana 03 (va antes que todo lo demás):
#   SHELL       := bash
#   .SHELLFLAGS := -eu -o pipefail -c
#   .DELETE_ON_ERROR:

.PHONY: all build clean manifest report objs help
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

# TODO: Nombres de módulo sin directorio ni barra: auth config logger
# Ojo: $(notdir modules/auth/) devuelve vacío. Quita antes la / final con patsubst.
MODULES :=

# TODO: Agrega flags -I para cada directorio de módulo a CFLAGS
CFLAGS := -Wall -Wextra -std=c11

TARGET := $(BUILD)/sistema

# Módulo pedido en 'make objs MODULE=...'
MODULE ?=
# TODO: normaliza MODULE con $(strip) para tolerar 'MODULE= logger '
MOD := $(MODULE)

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
	# TODO: Muestra MODULES en una línea que empiece por 'Módulos:'
	# TODO: Muestra nombre del target sin directorio ni extensión
	# TODO: Muestra total de objetos
	@echo "(implementa los TODOs de report)"

# TODO: 'objs' imprime solo los objetos de $(MOD), filtrando OBJS.
# Si $(MOD) no está en MODULES, debe fallar con $(error) diciendo que no existe
# y listando los módulos disponibles.
objs: ## Lista los objetos de un módulo (MODULE=auth)
	@echo "objs no implementado"
	@exit 1

# TODO: en 'clean', guarda + borrado seguro (semana 03). Receta:
#   $(if $(BUILD),,$(error BUILD vacía: rm -rf no se ejecuta))
#   rm -rf -- '$(BUILD)'
clean: ## Elimina archivos generados
	@echo "clean no implementado"

help: ## Muestra esta ayuda
	@echo "Targets disponibles:"
	@grep -hE '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
		| awk 'BEGIN {FS = ":.*?## "}; {printf "  %-20s %s\n", $$1, $$2}'
