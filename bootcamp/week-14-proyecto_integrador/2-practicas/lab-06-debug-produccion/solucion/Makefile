# Build system de mi-servicio (SOLUCIÓN). Cada corrección lleva su FIX.

SHELL       := bash
.SHELLFLAGS := -eu -o pipefail -c
.DELETE_ON_ERROR:

# FIX 2: `release` estaba en .PHONY sin regla. Un target phony sin regla no
# es un error: `make release` imprimía "Nothing to be done" y salía con 0, así
# que el job de release de CI pasaba en verde sin publicar nada. Sin la
# entrada, `make release` falla con "No rule to make target".
.PHONY: all build lint test docs ci deploy clean help
.DEFAULT_GOAL := help

APP_NAME  := mi-servicio
BUILD_DIR := build
VERSION   := 1.0.0
IMAGE     := $(APP_NAME):$(VERSION)
# FIX 1: := en lugar de =. Con = cada expansión vuelve a llamar a date: build
# escribía una marca de tiempo y deploy, un segundo después, comparaba con otra.
TIMESTAMP := $(shell date +%Y%m%d-%H%M%S)

all: build docs ## Construir servicio y documentación

lint: ## Verificar estilo del código
	@echo "==> Lint OK"

build: lint ## Compilar el servicio
	@echo "==> Compilando $(APP_NAME) $(VERSION) ..."
	@mkdir -p $(BUILD_DIR)
	@echo "$(VERSION)" > $(BUILD_DIR)/version.txt
	@echo "$(TIMESTAMP)" > $(BUILD_DIR)/timestamp.txt
	@sleep 1
	@echo "✓ Build OK"

# FIX 4: test lee el artefacto de build, así que depende de build. Sin la
# dependencia, `make -j2 ci` lanzaba test a la vez que lint y fallaba con
# "No such file or directory" en un árbol limpio.
test: build ## Ejecutar tests contra el artefacto
	@v=$$(cat $(BUILD_DIR)/version.txt); echo "==> Tests con build $$v"

# FIX 3: $(MAKE) y no `make`. Solo $(MAKE) hereda el jobserver: con `make`
# a secas, `make -j2 all` avisaba "jobserver unavailable: using -j1" y el
# sub-make perdía las flags del padre (-n, -k, -j).
docs: ## Generar la documentación (sub-make en docs/)
	@$(MAKE) --no-print-directory -C docs

ci: lint test build ## Pipeline CI

# FIX 5: la receta tenía espacios, no TAB. Una línea con espacios no es
# receta: Make intenta leerla como regla o asignación y para con
# "missing separator" sin ejecutar nada, ni siquiera `make help`.
deploy: build ## Desplegar el artefacto recién construido
	@echo "==> Desplegando $(IMAGE) del build $(TIMESTAMP)"
	@test "$$(cat $(BUILD_DIR)/timestamp.txt)" = "$(TIMESTAMP)" || { echo "✗ El artefacto no es el de este build"; exit 1; }
	@echo "✓ Deploy OK"

clean: ## Eliminar artefactos
	$(if $(BUILD_DIR),,$(error BUILD_DIR vacía: rm -rf no se ejecuta))
	rm -rf -- '$(BUILD_DIR)'

help: ## Mostrar ayuda
	@grep -hE '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
		| awk 'BEGIN {FS = ":.*?## "}; {printf "  %-20s %s\n", $$1, $$2}'
