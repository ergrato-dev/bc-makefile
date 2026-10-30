.PHONY: all build clean manifest report help
.DEFAULT_GOAL := help

CC    := gcc
BUILD := build

CORE_SRCS   := $(wildcard src/*.c)
MODULE_SRCS := $(wildcard modules/*/*.c)
ALL_SRCS    := $(CORE_SRCS) $(MODULE_SRCS)
OBJS        := $(patsubst %.c,$(BUILD)/%.o,$(ALL_SRCS))
MODULE_DIRS := $(sort $(dir $(MODULE_SRCS)))
CFLAGS      := -Wall -Wextra -std=c11 $(addprefix -I,$(MODULE_DIRS))
TARGET      := $(BUILD)/sistema

all: build ## Compila el sistema completo

build: $(TARGET) ## Enlaza el programa final

$(TARGET): $(OBJS)
	@mkdir -p $(dir $@)
	$(CC) $(CFLAGS) $^ -o $@
	@echo "Sistema compilado: $@"

$(BUILD)/%.o: %.c
	@mkdir -p $(@D)
	$(CC) $(CFLAGS) -c $< -o $@

manifest: ## Genera build/manifest.txt con lista de fuentes
	@mkdir -p $(BUILD)
	@echo "# Fuentes del proyecto" > $(BUILD)/manifest.txt
	@echo "$(ALL_SRCS)" | tr ' ' '\n' >> $(BUILD)/manifest.txt
	@echo "Manifest generado: $(BUILD)/manifest.txt ($(words $(ALL_SRCS)) fuentes)"

report: ## Muestra estadísticas del proyecto usando funciones de texto
	@echo "=== Reporte del Proyecto ==="
	@echo "Fuentes core:    $(words $(CORE_SRCS)) archivos ($(notdir $(CORE_SRCS)))"
	@echo "Fuentes módulos: $(words $(MODULE_SRCS)) archivos"
	@echo "Directorios:     $(MODULE_DIRS)"
	@echo "Target:          $(notdir $(basename $(TARGET)))"
	@echo "Total objetos:   $(words $(OBJS))"

clean: ## Elimina archivos generados
	rm -rf $(BUILD)

help: ## Muestra esta ayuda
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
		| awk 'BEGIN {FS = ":.*?## "}; {printf "  %-20s %s\n", $$1, $$2}'
