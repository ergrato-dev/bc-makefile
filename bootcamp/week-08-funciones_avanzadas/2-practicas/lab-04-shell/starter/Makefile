.PHONY: all info version clean help
.DEFAULT_GOAL := help

BUILD := build

# TODO 1: Captura el hash corto de git (7 chars)
# Pista: git rev-parse --short HEAD 2>/dev/null || echo sin-git
GIT_HASH := UNKNOWN

# TODO 2: Captura la fecha y hora del build en formato ISO
# Pista: date +%Y-%m-%dT%H:%M:%S
BUILD_DATE := UNKNOWN

# TODO 3: Captura el nombre del sistema operativo
# Pista: uname -s
OS_NAME := UNKNOWN

# TODO 4: Captura el número de CPUs (portable: Linux y macOS)
# Pista: nproc 2>/dev/null || sysctl -n hw.ncpu 2>/dev/null || echo 1
NUM_CPUS := 0

# TODO 5: Captura la primera línea de la versión de Make
# Pista: $(MAKE) --version | head -1
MAKE_VERSION_STR := UNKNOWN

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
