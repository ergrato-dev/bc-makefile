# ============================================================
# Lab 02 — Inyección de comandos (STARTER, ROTO A PROPÓSITO)
# Semana 13: Seguridad, portabilidad y alternativas
# ============================================================
# El CI lo llama así:
#   make release VERSION=$TAG BRANCH=$RAMA NOTE="$TITULO_DEL_PR"
# Las tres variables las controla quien crea el tag, la rama o el PR.
# Hay cinco bugs (A-E). NO pruebes nunca un payload que no sea un `touch`.

SHELL       := bash
.SHELLFLAGS := -eu -o pipefail -c
.DELETE_ON_ERROR:

.PHONY: help version notes archive release clean
.DEFAULT_GOAL := help

VERSION   ?= 0.1.0
BRANCH    ?= main
NOTE      ?= sin notas
BUILD_DIR ?= dist

# TODO (paso 4): valida VERSION aquí, en Make y sin shell.
# TODO (paso 5): BRANCH y NOTE son texto libre: tómalas literales y expórtalas.

help: ## Muestra los targets disponibles
	@echo "Targets disponibles:"
	@grep -hE '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
		| awk 'BEGIN {FS = ":.*?## "}; {printf "  %-20s %s\n", $$1, $$2}'

# BUG A: comillas simples alrededor de un valor que puede traer comillas simples
version: ## Imprime la versión
	@echo 'Versión: $(VERSION)'

# BUG B: comillas dobles: ` y $( ) siguen activos dentro
# BUG D: NOTE pasa por Make antes que por el shell
notes: ## Escribe dist/NOTES.txt
	mkdir -p $(BUILD_DIR)
	echo "Rama $(BRANCH): $(NOTE)" > $(BUILD_DIR)/NOTES.txt

# BUG C: sin comillas: ; | & y espacios parten el comando
archive: notes ## Crea dist/app-VERSION.txt
	cp $(BUILD_DIR)/NOTES.txt $(BUILD_DIR)/app-$(VERSION).txt

release: version archive ## Versión + notas + archivo
	@echo "Release lista en $(BUILD_DIR)/"

# BUG E: ¿qué borra con BUILD_DIR= ? ¿y con BUILD_DIR=/home ? (prueba SOLO con -n)
clean: ## Borra dist/
	rm -rf $(BUILD_DIR)/
