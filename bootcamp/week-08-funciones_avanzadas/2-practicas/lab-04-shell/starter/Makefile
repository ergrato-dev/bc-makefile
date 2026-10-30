.PHONY: all info version stamps version-mk clean help
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

# TODO 6: Define dos marcas de tiempo con nanosegundos (date +%s%N):
#   STAMP_LAZY con '=' y STAMP_NOW con ':='. Mismo comando, distinto operador.
STAMP_LAZY = 0
STAMP_NOW := 0

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

# TODO 7: Escribe build/version.mk con $(file), sin printf ni echo:
#   primera línea con $(file >$@,GIT_HASH := $(GIT_HASH)), las siguientes con $(file >>$@,...)
#   para BUILD_DATE y OS_NAME. Deja el @echo final.
$(BUILD)/version.mk: | $(BUILD)
	@echo "Generado: $@"

# TODO 8: Lee el archivo con $(file <$(BUILD)/version.mk) y muéstralo en una línea con $(strip ...)
version-mk: $(BUILD)/version.mk ## Escribir build/version.mk con $(file) y leerlo
	@echo "Leído: TODO"

clean: ## Limpiar build
	$(if $(BUILD),,$(error BUILD vacía: rm -rf no se ejecuta))
	@rm -rf -- '$(BUILD)'
	@echo "Limpiado."

help: ## Mostrar ayuda
	@echo "Targets disponibles:"
	@grep -hE '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
		| awk 'BEGIN {FS = ":.*?## "}; {printf "  %-20s %s\n", $$1, $$2}'
