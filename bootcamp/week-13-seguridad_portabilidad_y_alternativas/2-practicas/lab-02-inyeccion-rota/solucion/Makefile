# ============================================================
# Lab 02 — Inyección de comandos (SOLUCIÓN)
# ============================================================
# Tres defensas, de más a menos preferible:
#   1. Validar con lista blanca lo que tiene formato (VERSION).
#   2. Pasar por entorno el texto libre (BRANCH, NOTE): "$$VAR" es un dato.
#   3. Si el valor tiene que ir en el texto del comando: $(call q,...).

SHELL       := bash
.SHELLFLAGS := -eu -o pipefail -c
.DELETE_ON_ERROR:

.PHONY: help version notes notes-echo archive release clean
.DEFAULT_GOAL := help

# --- Utilidades ---------------------------------------------------------------
# $(call strip-chars,TEXTO,ALFABETO) -> TEXTO sin los caracteres de ALFABETO
strip-chars = $(if $2,$(call strip-chars,$(subst $(firstword $2),,$1),$(wordlist 2,$(words $2),$2)),$1)
# $(call safe-word,TEXTO,ALFABETO) -> "ok" si TEXTO es una palabra hecha solo de ALFABETO
safe-word = $(and $(filter 1,$(words $1)),$(if $(call strip-chars,$1,$2),,ok))
# $(call q,TEXTO) -> TEXTO entre comillas simples para bash, escapando las que traiga
q = '$(subst ','\'',$1)'

DIGITS     := 0 1 2 3 4 5 6 7 8 9
LETTERS    := a b c d e f g h i j k l m n o p q r s t u v w x y z \
              A B C D E F G H I J K L M N O P Q R S T U V W X Y Z
PATH_CHARS := $(DIGITS) $(LETTERS) - _ . /

# --- Variables ----------------------------------------------------------------
VERSION   ?= 0.1.0
BRANCH    ?= main
NOTE      ?= sin notas
BUILD_DIR ?= dist

# FIX A y C: VERSION tiene formato, así que se valida. $(value) lee el texto
# sin expandirlo: un $(shell ...) dentro no llega a ejecutarse.
ifneq ($(call safe-word,$(value VERSION),$(DIGITS) .),ok)
  $(error VERSION inválida: usa solo dígitos y puntos, por ejemplo 1.4.2)
endif

# FIX B y D: texto libre. Se toma literal (Make ya no expande nada dentro) y se
# exporta: las recetas lo leen como "$$BRANCH" y "$$NOTE", que el shell nunca
# interpreta como código.
override BRANCH := $(value BRANCH)
override NOTE   := $(value NOTE)
export BRANCH NOTE

# --- Targets ------------------------------------------------------------------
help: ## Muestra los targets disponibles
	@echo "Targets disponibles:"
	@grep -hE '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
		| awk 'BEGIN {FS = ":.*?## "}; {printf "  %-20s %s\n", $$1, $$2}'

version: ## Imprime la versión
	@echo 'Versión: $(VERSION)'

notes: ## Escribe dist/NOTES.txt
	mkdir -p '$(BUILD_DIR)'
	printf 'Rama %s: %s\n' "$$BRANCH" "$$NOTE" > '$(BUILD_DIR)/NOTES.txt'

# Defensa 3: el valor va dentro del comando, pero citado con q.
notes-echo: ## Imprime la nota usando $(call q,...)
	@echo Nota: $(call q,$(NOTE))

archive: notes ## Crea dist/app-VERSION.txt
	cp '$(BUILD_DIR)/NOTES.txt' '$(BUILD_DIR)/app-$(VERSION).txt'

release: version archive ## Versión + notas + archivo
	@echo "Release lista en $(BUILD_DIR)/"

# FIX E: nunca vacía, nunca absoluta, nunca con '..', nunca con caracteres raros.
clean: ## Borra dist/ (con guardas)
	$(if $(BUILD_DIR),,$(error BUILD_DIR vacía: rm -rf no se ejecuta))
	$(if $(filter /% ~%,$(BUILD_DIR))$(findstring ..,$(BUILD_DIR)),$(error BUILD_DIR debe ser relativa y sin '..': rm -rf no se ejecuta))
	$(if $(call safe-word,$(BUILD_DIR),$(PATH_CHARS)),,$(error BUILD_DIR con caracteres no permitidos: rm -rf no se ejecuta))
	rm -rf -- '$(BUILD_DIR)'
