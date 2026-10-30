SHELL       := bash
.SHELLFLAGS := -eu -o pipefail -c
.DELETE_ON_ERROR:

.PHONY: version bump-patch bump-minor bump-major tag changelog release-patch release-minor help
.DEFAULT_GOAL := help

VERSION_FILE := VERSION
# VERSION viene de un archivo del repo: se lee sin shell y se valida antes
# de usarla. $(shell echo $(VERSION) | cut ...) ejecutaría lo que un PR
# malicioso escriba en VERSION, incluso con `make help`.
VERSION      := $(strip $(or $(file < $(VERSION_FILE)),0.0.0))
VERSION_PARTS := $(subst ., ,$(VERSION))
# Quitar los dígitos debe dejar exactamente "..": solo dígitos y dos puntos.
VERSION_REST := $(subst 0,,$(subst 1,,$(subst 2,,$(subst 3,,$(subst 4,,$(subst 5,,$(subst 6,,$(subst 7,,$(subst 8,,$(subst 9,,$(VERSION)))))))))))
ifneq ($(VERSION_REST) $(words $(VERSION_PARTS)),.. 3)
  $(error VERSION inválida en $(VERSION_FILE). Formato esperado: MAYOR.MENOR.PARCHE)
endif
MAJOR        := $(word 1,$(VERSION_PARTS))
MINOR        := $(word 2,$(VERSION_PARTS))
PATCH        := $(word 3,$(VERSION_PARTS))
DATE         := $(shell date '+%Y-%m-%d')

version: ## Mostrar versión actual
	@echo "Versión actual: $(VERSION)"

bump-patch: ## Incrementar versión patch (X.Y.Z → X.Y.Z+1)
	@echo "$(MAJOR).$(MINOR).$$(( $(PATCH) + 1 ))" > $(VERSION_FILE)
	@echo "Nueva versión: $$(cat $(VERSION_FILE))"

bump-minor: ## Incrementar versión minor (X.Y.Z → X.Y+1.0)
	@echo "$(MAJOR).$$(( $(MINOR) + 1 )).0" > $(VERSION_FILE)
	@echo "Nueva versión: $$(cat $(VERSION_FILE))"

bump-major: ## Incrementar versión major (X.Y.Z → X+1.0.0)
	@echo "$$(( $(MAJOR) + 1 )).0.0" > $(VERSION_FILE)
	@echo "Nueva versión: $$(cat $(VERSION_FILE))"

tag: ## Crear tag git con la versión actual
	@if ! git rev-parse --git-dir > /dev/null 2>&1; then \
		echo "ERROR: no es un repositorio git. Ejecuta: git init"; exit 1; \
	fi
	@git tag -a "v$(VERSION)" -m "Release v$(VERSION)"
	@echo "Tag creado: v$(VERSION)"

changelog: ## Generar entrada en CHANGELOG.md
	@last_tag=$$(git describe --tags --abbrev=0 HEAD~1 2>/dev/null || true); \
	tmp=$$(mktemp); \
	{ \
		echo "## v$(VERSION) — $(DATE)"; \
		echo ""; \
		if [ -n "$$last_tag" ]; then \
			git log --oneline "$$last_tag..HEAD" | sed 's/^/- /'; \
		else \
			git log --oneline | head -10 | sed 's/^/- /'; \
		fi; \
		echo ""; \
		cat CHANGELOG.md 2>/dev/null || true; \
	} > "$$tmp"; \
	mv "$$tmp" CHANGELOG.md
	@echo "CHANGELOG.md actualizado."

# VERSION se calcula al parsear el Makefile. Después del bump hay que
# relanzar Make para que tag y changelog vean la versión nueva; como
# prerrequisitos usarían la vieja.
release-patch: bump-patch ## Release patch: bump + tag + changelog
	@$(MAKE) --no-print-directory tag changelog
	@echo "✓ Release patch completado."

release-minor: bump-minor ## Release minor: bump + tag + changelog
	@$(MAKE) --no-print-directory tag changelog
	@echo "✓ Release minor completado."

help: ## Mostrar ayuda
	@grep -hE '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
		| awk 'BEGIN {FS = ":.*?## "}; {printf "  %-20s %s\n", $$1, $$2}'
