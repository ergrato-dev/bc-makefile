SHELL       := bash
.SHELLFLAGS := -eu -o pipefail -c
.DELETE_ON_ERROR:

.PHONY: version bump-patch bump-minor bump-major tag changelog release-patch release-minor help
.DEFAULT_GOAL := help

VERSION_FILE := VERSION
DATE         := $(shell date '+%Y-%m-%d')
# VERSION viene de un archivo del repo: se lee sin shell.
VERSION      := $(strip $(or $(file < $(VERSION_FILE)),0.0.0))
VERSION_PARTS := $(subst ., ,$(VERSION))

# --------------------------------------------------------------------------
# TODO 0: Valida VERSION antes de usarla. Quitar todos los dígitos debe
#         dejar exactamente ".." y VERSION_PARTS debe tener 3 palabras; si
#         no, $(error ...). NO uses $(shell echo $(VERSION) | cut ...): un
#         PR que escriba `1.0.0';rm -rf ~;'` en VERSION ejecutaría código
#         en cuanto alguien corra `make help`.
# --------------------------------------------------------------------------
MAJOR        := $(word 1,$(VERSION_PARTS))
MINOR        := $(word 2,$(VERSION_PARTS))
PATCH        := $(word 3,$(VERSION_PARTS))

version: ## Mostrar versión actual
	@echo "Versión actual: $(VERSION)"

# --------------------------------------------------------------------------
# TODO 1: Implementa bump-patch.
#         Debe incrementar PATCH en 1, escribir la nueva versión a VERSION_FILE
#         e imprimir: "Nueva versión: X.Y.(Z+1)"
#         Tip: con VERSION ya validada, bash calcula: $$(( $(PATCH) + 1 ))
# --------------------------------------------------------------------------
bump-patch: ## Incrementar versión patch (X.Y.Z → X.Y.Z+1)
	# TODO: calcular nueva versión y escribir a VERSION_FILE

# --------------------------------------------------------------------------
# TODO 2: Implementa bump-minor.
#         Incrementar MINOR en 1 y resetear PATCH a 0.
# --------------------------------------------------------------------------
bump-minor: ## Incrementar versión minor (X.Y.Z → X.Y+1.0)
	# TODO: calcular nueva versión y escribir a VERSION_FILE

# --------------------------------------------------------------------------
# TODO 3: Implementa bump-major.
#         Incrementar MAJOR en 1 y resetear MINOR y PATCH a 0.
# --------------------------------------------------------------------------
bump-major: ## Incrementar versión major (X.Y.Z → X+1.0.0)
	# TODO: calcular nueva versión y escribir a VERSION_FILE

# --------------------------------------------------------------------------
# TODO 4: Implementa tag.
#         Debe crear un tag git "vX.Y.Z" con mensaje "Release vX.Y.Z".
#         Si no hay repo git, muestra error claro.
# --------------------------------------------------------------------------
tag: ## Crear tag git con la versión actual
	# TODO: git tag -a "v$(VERSION)" -m "Release v$(VERSION)"

# --------------------------------------------------------------------------
# TODO 5: Implementa changelog.
#         Debe agregar una entrada a CHANGELOG.md con:
#         - Fecha actual
#         - Versión
#         - Lista de commits desde el último tag (git log --oneline)
#         Escribe en un temporal de `mktemp` y luego `mv`: nunca a una ruta
#         fija como /tmp/cl_tmp (otro usuario puede crearla antes).
# --------------------------------------------------------------------------
changelog: ## Generar entrada en CHANGELOG.md
	# TODO: obtener commits desde último tag y escribir a CHANGELOG.md

# --------------------------------------------------------------------------
# TODO 6: Implementa release-patch que encadena: bump-patch → tag → changelog
#         Trampa: VERSION se calcula al PARSEAR. Si pones tag y changelog
#         como prerrequisitos, usarán la versión vieja. Tras el bump hay
#         que relanzar: @$(MAKE) --no-print-directory tag changelog
# --------------------------------------------------------------------------
release-patch: ## Release patch: bump + tag + changelog
	# TODO: encadenar bump-patch, tag, changelog

release-minor: ## Release minor: bump + tag + changelog
	# TODO: encadenar bump-minor, tag, changelog

help: ## Mostrar ayuda
	@grep -hE '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
		| awk 'BEGIN {FS = ":.*?## "}; {printf "  %-20s %s\n", $$1, $$2}'
