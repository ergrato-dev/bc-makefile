SHELL       := bash
.SHELLFLAGS := -eu -o pipefail -c
.DELETE_ON_ERROR:

.PHONY: all info version stamps version-mk clean help
.DEFAULT_GOAL := help

BUILD := build

GIT_HASH         := $(shell git rev-parse --short HEAD 2>/dev/null || echo sin-git)
BUILD_DATE       := $(shell date +%Y-%m-%dT%H:%M:%S)
OS_NAME          := $(shell uname -s)
NUM_CPUS         := $(shell nproc 2>/dev/null || sysctl -n hw.ncpu 2>/dev/null || echo 1)
MAKE_VERSION_STR := $(shell $(MAKE) --version | head -1)

# = se reevalúa en cada referencia; := una sola vez, al leer el Makefile
STAMP_LAZY = $(shell date +%s%N)
STAMP_NOW := $(shell date +%s%N)

info: ## Mostrar toda la información del entorno
	@echo "=== Build Info ==="
	@echo "Git Hash:     $(GIT_HASH)"
	@echo "Build Date:   $(BUILD_DATE)"
	@echo "OS:           $(OS_NAME)"
	@echo "CPUs:         $(NUM_CPUS)"
	@echo "Make:         $(MAKE_VERSION_STR)"

version: ## Generar build/version.txt con los metadatos
	@mkdir -p $(BUILD)
	@printf "version: git-%s\ndate: %s\nos: %s\ncpus: %s\n" \
		"$(GIT_HASH)" "$(BUILD_DATE)" "$(OS_NAME)" "$(NUM_CPUS)" \
		> $(BUILD)/version.txt
	@echo "Generado: $(BUILD)/version.txt"
	@cat $(BUILD)/version.txt

stamps: ## Comparar = y := con $(shell date)
	@echo "Con =  : $(STAMP_LAZY) $(STAMP_LAZY)"
	@echo "Con := : $(STAMP_NOW) $(STAMP_NOW)"

$(BUILD):
	@mkdir -p $@

# $(file) escribe sin shell. Make expande la receta entera antes de ejecutarla,
# por eso build/ es un prerrequisito order-only y no un mkdir en la receta.
$(BUILD)/version.mk: | $(BUILD)
	$(file >$@,GIT_HASH := $(GIT_HASH))
	$(file >>$@,BUILD_DATE := $(BUILD_DATE))
	$(file >>$@,OS_NAME := $(OS_NAME))
	@echo "Generado: $@"

version-mk: $(BUILD)/version.mk ## Escribir build/version.mk con $(file) y leerlo
	@echo "Leído: $(strip $(file <$(BUILD)/version.mk))"

clean: ## Limpiar build
	$(if $(BUILD),,$(error BUILD vacía: rm -rf no se ejecuta))
	@rm -rf -- '$(BUILD)'
	@echo "Limpiado."

help: ## Mostrar ayuda
	@echo "Targets disponibles:"
	@grep -hE '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
		| awk 'BEGIN {FS = ":.*?## "}; {printf "  %-20s %s\n", $$1, $$2}'
