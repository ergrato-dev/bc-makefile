# ============================================================
# Proyecto Semana 13 — Makefile de "notify" auditado y endurecido (SOLUCIÓN)
# ============================================================
# Uso en CI:
#   make package VERSION=1.4.2 BRANCH="$RAMA"
#   DEPLOY_TOKEN=... make deploy      # el token por entorno, no en argv de make

# --- Guarda de versión (H1) -------------------------------------------------
# Va primero y solo usa sintaxis de Make 3.81: en el make de macOS tiene que
# poder parsearse para decir qué falta. $(sort) compara texto: vale mientras
# no exista una 4.10.
MIN_MAKE_VERSION := 4.3
ifneq ($(MIN_MAKE_VERSION),$(firstword $(sort $(MAKE_VERSION) $(MIN_MAKE_VERSION))))
  $(error Se requiere GNU Make >= $(MIN_MAKE_VERSION); tienes $(MAKE_VERSION). En macOS: brew install make y usa gmake)
endif

# --- Modo estricto (H2) -----------------------------------------------------
SHELL       := bash
.SHELLFLAGS := -eu -o pipefail -c
.DELETE_ON_ERROR:

.PHONY: help install-tools lint package deploy clean check
.DEFAULT_GOAL := help

# --- Validación sin shell ---------------------------------------------------
# $(call strip-chars,TEXTO,ALFABETO) -> TEXTO sin ninguno de los caracteres de ALFABETO
strip-chars = $(if $2,$(call strip-chars,$(subst $(firstword $2),,$1),$(wordlist 2,$(words $2),$2)),$1)
# $(call safe-word,TEXTO,ALFABETO) -> "ok" si TEXTO es una sola palabra hecha solo de ALFABETO
safe-word = $(and $(filter 1,$(words $1)),$(if $(call strip-chars,$1,$2),,ok))

DIGITS     := 0 1 2 3 4 5 6 7 8 9
LETTERS    := a b c d e f g h i j k l m n o p q r s t u v w x y z \
              A B C D E F G H I J K L M N O P Q R S T U V W X Y Z
PATH_CHARS := $(DIGITS) $(LETTERS) - _ . /

# --- Configuración ----------------------------------------------------------
APP        := notify
VERSION    ?= 0.1.0
BUILD_DIR  := build
TOOLS_DIR  := $(BUILD_DIR)/tools
REMOTE_DIR := $(BUILD_DIR)/remote
SRCS       := $(wildcard src/*.sh)
TARBALL    := $(BUILD_DIR)/$(APP)-$(VERSION).tar.gz
BUILDINFO  := $(BUILD_DIR)/BUILDINFO
AUTH_FILE  := $(BUILD_DIR)/curl-auth.conf
FMT_TOOL   := $(TOOLS_DIR)/fmt-tool

# VERSION (H7): viene de un tag. Se valida en Make con $(value): ni Make
# expande un $(...) que traiga, ni llega a un shell sin validar.
ifneq ($(call safe-word,$(value VERSION),$(DIGITS) .),ok)
  $(error VERSION inválida: usa solo dígitos y puntos, por ejemplo 1.4.2)
endif

# BRANCH (H8): git admite ' ; ` y $ en nombres de rama, así que no se valida:
# se trata como dato. Si viene de fuera se toma literal (Make no expande nada
# dentro) y llega a las recetas por entorno, como "$$BRANCH".
# El $(shell git ...) es de solo lectura (H3: ningún $(shell) con efectos al parsear).
ifeq ($(origin BRANCH),undefined)
  BRANCH := $(shell git rev-parse --abbrev-ref HEAD 2>/dev/null)
else
  override BRANCH := $(value BRANCH)
endif
export BRANCH

# --- .env validado antes de incluirlo (H4) ----------------------------------
# include parsea el archivo como Makefile: un $(shell ...) se ejecutaría y un
# SHELL=... cambiaría el intérprete de todas las recetas. Solo se aceptan las
# claves conocidas, con valores sin espacios, comillas, $ ni ;. Si hay líneas
# malas se dicen sus números, nunca su contenido (puede llevar un secreto).
ENV_FILE ?= .env
ifneq ($(call safe-word,$(ENV_FILE),$(PATH_CHARS)),ok)
  $(error ENV_FILE con caracteres no permitidos)
endif
ifneq ($(wildcard $(ENV_FILE)),)
  ENV_BAD := $(shell grep -nvE '^(#.*|(DEPLOY_URL|DEPLOY_TOKEN)=[A-Za-z0-9_./:@+-]*)?$$' '$(ENV_FILE)' | cut -d: -f1)
  ifneq ($(ENV_BAD),)
    $(error $(ENV_FILE): líneas no permitidas: $(ENV_BAD). Formato: CLAVE=valor, solo DEPLOY_URL y DEPLOY_TOKEN)
  endif
  include $(ENV_FILE)
endif

# --- Secretos (H5, H9, H10) ------------------------------------------------
# Nada de `export` a secas. El token no llega a ninguna receta salvo a la que
# escribe el archivo de credenciales (export específico de ese target).
DEPLOY_URL   ?= file://$(CURDIR)/$(REMOTE_DIR)/
DEPLOY_TOKEN ?=
# (H13: toda variable que se usa está definida, aunque sea vacía; sin CI_JOB_ID ni DEPLOY_ENV sueltas)
unexport DEPLOY_TOKEN

# --- Herramientas (H6) ------------------------------------------------------
# En un proyecto real sería una URL https; aquí, un "mirror" local sin red.
TOOL_URL    ?= file://$(CURDIR)/vendor/install-fmt-tool.sh
TOOL_SHA256 := 69f39a6ee3c9c600e4d40f5539c2ecb9d2349249e1b998070d91608e02d2b611
# sha256sum (GNU) o shasum -a 256 (macOS/BSD). '=' perezoso: el $(shell)
# solo corre si una receta lo usa, nunca en make help.
SHA256SUM    = $(if $(shell command -v sha256sum 2>/dev/null),sha256sum,shasum -a 256)

# --- Targets ----------------------------------------------------------------

help: ## Muestra los targets disponibles
	@echo "Targets disponibles:"
	@grep -hE '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
		| awk 'BEGIN {FS = ":.*?## "}; {printf "  %-20s %s\n", $$1, $$2}'

$(BUILD_DIR) $(TOOLS_DIR) $(REMOTE_DIR):
	mkdir -p '$@'

install-tools: $(FMT_TOOL) ## Instala fmt-tool verificando su SHA-256 (sin curl | sh)

# Descargar, verificar, y solo entonces ejecutar. La URL llega por entorno.
$(FMT_TOOL): export TOOL_URL := $(TOOL_URL)
$(FMT_TOOL): | $(TOOLS_DIR)
	curl -fsSL -o '$@.installer' "$$TOOL_URL"
	echo '$(TOOL_SHA256)  $@.installer' | $(SHA256SUM) -c - >/dev/null \
		|| { rm -f -- '$@.installer'; echo "SHA-256 incorrecto: el instalador no se ejecuta" >&2; exit 1; }
	PREFIX='$(TOOLS_DIR)' sh '$@.installer'
	rm -f -- '$@.installer'

lint: $(FMT_TOOL) ## Comprueba la sintaxis de src/ con fmt-tool
	'$(FMT_TOOL)' $(SRCS)

# Target de archivo (H12): make -q puede decir si está al día.
# Tamaño con wc -c, que existe en GNU y BSD; stat -c es solo GNU (H14).
package: $(TARBALL) ## Empaqueta src/ en build/notify-VERSION.tar.gz

$(TARBALL): $(SRCS) | $(BUILD_DIR)
	printf 'version=%s\nbranch=%s\n' '$(VERSION)' "$${BRANCH:-desconocida}" > '$(BUILDINFO)'
	tar -czf '$@' src -C '$(BUILD_DIR)' BUILDINFO
	@echo "Paquete: $@ ($$(wc -c < '$@' | tr -d ' ') bytes)"

# Única receta que ve el token. umask 077: el archivo nace con permisos 600.
# El valor se lee del entorno ("$$DEPLOY_TOKEN"): no aparece en make -n, ni
# en el argv de bash que muestra ps, ni en el log del CI.
$(AUTH_FILE): export DEPLOY_TOKEN := $(DEPLOY_TOKEN)
$(AUTH_FILE): | $(BUILD_DIR)
	$(if $(DEPLOY_TOKEN),,$(error DEPLOY_TOKEN vacía: defínela en el entorno o en $(ENV_FILE)))
	umask 077; printf 'header = "Authorization: Bearer %s"\n' "$$DEPLOY_TOKEN" > '$@'

# El archivo de credenciales se borra pase lo que pase con curl.
deploy: export DEPLOY_URL := $(DEPLOY_URL)
deploy: $(TARBALL) $(AUTH_FILE) | $(REMOTE_DIR) ## Sube el paquete a DEPLOY_URL
	st=0; curl -fsS -K '$(AUTH_FILE)' -T '$(TARBALL)' "$$DEPLOY_URL" || st=$$?; rm -f -- '$(AUTH_FILE)'; exit "$$st"
	@echo "Desplegado $(APP) $(VERSION) en $$DEPLOY_URL"

# H11: nunca vacía, nunca absoluta, nunca con '..', nunca con caracteres raros.
clean: ## Borra build/ (con guardas)
	$(if $(BUILD_DIR),,$(error BUILD_DIR vacía: rm -rf no se ejecuta))
	$(if $(filter /% ~%,$(BUILD_DIR))$(findstring ..,$(BUILD_DIR)),$(error BUILD_DIR debe ser relativa y sin '..': rm -rf no se ejecuta))
	$(if $(call safe-word,$(BUILD_DIR),$(PATH_CHARS)),,$(error BUILD_DIR con caracteres no permitidos: rm -rf no se ejecuta))
	rm -rf -- '$(BUILD_DIR)'

# --- Autoprueba (H15) -------------------------------------------------------
# Cada paso usa una carpeta de pruebas propia y solo payloads inofensivos.
SELFTEST := $(BUILD_DIR)/selftest
SUBMAKE  := $(MAKE) --no-print-directory

check: ## Autoprueba del Makefile: avisos, inyección, guardas, dry-run y -q
	$(if $(BUILD_DIR),,$(error BUILD_DIR vacía: rm -rf no se ejecuta))
	@rm -rf -- '$(SELFTEST)' && mkdir -p '$(SELFTEST)'
	@echo "1/6 sin variables indefinidas"
	@out=$$($(SUBMAKE) --warn-undefined-variables -n -B package deploy clean DEPLOY_TOKEN=x 2>&1) \
		&& ! grep 'undefined variable' <<<"$$out"
	@echo "2/6 una VERSION hostil se rechaza"
	@! $(SUBMAKE) -n package 'VERSION=1.0.0`touch $(SELFTEST)/pwned`' >/dev/null 2>&1
	@echo "3/6 una BRANCH hostil se guarda como texto"
	@$(SUBMAKE) -s -B package 'BRANCH=x`touch $(SELFTEST)/pwned`' >/dev/null
	@$(SUBMAKE) -s -B package 'BRANCH=x$$(shell touch $(SELFTEST)/pwned)' >/dev/null
	@test ! -e '$(SELFTEST)/pwned'
	@echo "4/6 make -n no muestra el token"
	@$(SUBMAKE) -n -B package deploy DEPLOY_TOKEN=canario-123 >'$(SELFTEST)/dry-run.txt'
	@! grep -q canario-123 '$(SELFTEST)/dry-run.txt'
	@echo "5/6 clean se niega con rutas peligrosas"
	@! $(SUBMAKE) -n clean BUILD_DIR= >/dev/null 2>&1
	@! $(SUBMAKE) -n clean BUILD_DIR=/ >/dev/null 2>&1
	@! $(SUBMAKE) -n clean BUILD_DIR=build/.. >/dev/null 2>&1
	@echo "6/6 el paquete queda al día (make -q)"
	@$(SUBMAKE) -s package >/dev/null && $(SUBMAKE) -q '$(TARBALL)'
	@rm -rf -- '$(SELFTEST)'
	@echo "check: OK"
