SHELL       := bash
.SHELLFLAGS := -eu -o pipefail -c
.DELETE_ON_ERROR:

.PHONY: all info version clean help
.DEFAULT_GOAL := help

BUILD := build

GIT_HASH         := $(shell git rev-parse --short HEAD 2>/dev/null || echo sin-git)
BUILD_DATE       := $(shell date +%Y-%m-%dT%H:%M:%S)
OS_NAME          := $(shell uname -s)
NUM_CPUS         := $(shell nproc 2>/dev/null || sysctl -n hw.ncpu 2>/dev/null || echo 1)
MAKE_VERSION_STR := $(shell $(MAKE) --version | head -1)

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

clean: ## Limpiar build
	$(if $(BUILD),,$(error BUILD vacía: rm -rf no se ejecuta))
	@rm -rf -- '$(BUILD)'
	@echo "Limpiado."

help: ## Mostrar ayuda
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
		| awk 'BEGIN {FS = ":.*?## "}; {printf "  %-20s %s\n", $$1, $$2}'
