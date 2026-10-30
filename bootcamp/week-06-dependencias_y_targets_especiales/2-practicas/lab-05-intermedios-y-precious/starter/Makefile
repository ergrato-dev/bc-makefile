# ============================================================
# Lab 05 — Intermedios, .SECONDARY y .PRECIOUS
# Semana 06: Dependencias automáticas y targets especiales
# ============================================================
# Este lab no usa -MMD a propósito: un .d que menciona build/es.c lo
# convertiría en "no intermedio" y no verías el comportamiento que estudias.

SHELL       := bash
.SHELLFLAGS := -eu -o pipefail -c
.DELETE_ON_ERROR:

.PHONY: all run informe clean help
.DEFAULT_GOAL := help

CC     := gcc
CFLAGS := -Wall -Wextra -std=c11

BUILD_DIR := build
APP       := $(BUILD_DIR)/app
TOOL      := tools/txt2c.sh
LANGS     := es en
# Los objetos sí se nombran; los .c generados, no
OBJS      := $(BUILD_DIR)/main.o $(LANGS:%=$(BUILD_DIR)/%.o)
GEN_SRCS  := $(LANGS:%=$(BUILD_DIR)/%.c)

all: $(APP) ## Compila build/app

run: $(APP) ## Ejecuta build/app
	@./$(APP)

$(APP): $(OBJS)
	@echo "[link] $@"
	@$(CC) $^ -o $@

$(BUILD_DIR)/main.o: src/main.c | $(BUILD_DIR)
	@echo "[cc]   $<"
	@$(CC) $(CFLAGS) -c $< -o $@

# Cadena de dos reglas de patrón: msgs/es.txt → build/es.c → build/es.o
$(BUILD_DIR)/%.c: msgs/%.txt $(TOOL) | $(BUILD_DIR)
	@bash $(TOOL) $< $@

$(BUILD_DIR)/%.o: $(BUILD_DIR)/%.c
	@echo "[cc]   $<"
	@$(CC) $(CFLAGS) -c $< -o $@

# TODO (paso 3): conserva los .c generados con .SECONDARY: $(GEN_SRCS)
# TODO (paso 4): prueba en su lugar .PRECIOUS: $(BUILD_DIR)/%.c y provoca un fallo
# TODO (paso 5): alternativa sin target especial: nombra los .c en una regla

# ── Informe: concatena todos los mensajes y cuenta palabras ──
informe: $(BUILD_DIR)/informe.txt ## Genera build/informe.txt
	@cat $<

$(BUILD_DIR)/informe.txt: $(BUILD_DIR)/todos.txt
	@echo "[wc]   $<"
	@wc -w < $< | xargs printf 'palabras: %s\n' > $@

$(BUILD_DIR)/todos.txt: $(LANGS:%=msgs/%.txt) | $(BUILD_DIR)
	@echo "[cat]  $^"
	@cat $^ > $@
# TODO (paso 6): todos.txt es un temporal. Márcalo con .INTERMEDIATE

$(BUILD_DIR):
	@mkdir -p $@

clean: ## Elimina build/
	$(if $(BUILD_DIR),,$(error BUILD_DIR vacía: rm -rf no se ejecuta))
	rm -rf -- '$(BUILD_DIR)'

help: ## Muestra los targets disponibles
	@echo "Targets disponibles:"
	@grep -hE '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
		| awk 'BEGIN {FS = ":.*?## "}; {printf "  %-20s %s\n", $$1, $$2}'
