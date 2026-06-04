.PHONY: version bump-patch bump-minor bump-major tag changelog release-patch release-minor help
.DEFAULT_GOAL := help

VERSION_FILE := VERSION
VERSION      := $(shell cat $(VERSION_FILE) 2>/dev/null || echo "0.0.0")
MAJOR        := $(shell echo $(VERSION) | cut -d. -f1)
MINOR        := $(shell echo $(VERSION) | cut -d. -f2)
PATCH        := $(shell echo $(VERSION) | cut -d. -f3)
DATE         := $(shell date '+%Y-%m-%d')

version: ## Mostrar versión actual
	@echo "Versión actual: $(VERSION)"

bump-patch: ## Incrementar versión patch (X.Y.Z → X.Y.Z+1)
	$(eval NEW_PATCH := $(shell expr $(PATCH) + 1))
	$(eval NEW_VERSION := $(MAJOR).$(MINOR).$(NEW_PATCH))
	@echo $(NEW_VERSION) > $(VERSION_FILE)
	@echo "Nueva versión: $(NEW_VERSION)"

bump-minor: ## Incrementar versión minor (X.Y.Z → X.Y+1.0)
	$(eval NEW_MINOR := $(shell expr $(MINOR) + 1))
	$(eval NEW_VERSION := $(MAJOR).$(NEW_MINOR).0)
	@echo $(NEW_VERSION) > $(VERSION_FILE)
	@echo "Nueva versión: $(NEW_VERSION)"

bump-major: ## Incrementar versión major (X.Y.Z → X+1.0.0)
	$(eval NEW_MAJOR := $(shell expr $(MAJOR) + 1))
	$(eval NEW_VERSION := $(NEW_MAJOR).0.0)
	@echo $(NEW_VERSION) > $(VERSION_FILE)
	@echo "Nueva versión: $(NEW_VERSION)"

tag: ## Crear tag git con la versión actual
	@if ! git rev-parse --git-dir > /dev/null 2>&1; then \
		echo "ERROR: no es un repositorio git. Ejecuta: git init"; exit 1; \
	fi
	@git tag -a "v$(VERSION)" -m "Release v$(VERSION)"
	@echo "Tag creado: v$(VERSION)"

changelog: ## Generar entrada en CHANGELOG.md
	$(eval LAST_TAG := $(shell git describe --tags --abbrev=0 HEAD~1 2>/dev/null || echo ""))
	@{ \
		echo "## v$(VERSION) — $(DATE)"; \
		echo ""; \
		if [ -n "$(LAST_TAG)" ]; then \
			git log --oneline $(LAST_TAG)..HEAD | sed 's/^/- /'; \
		else \
			git log --oneline | head -10 | sed 's/^/- /'; \
		fi; \
		echo ""; \
	} | cat - CHANGELOG.md 2>/dev/null > /tmp/cl_tmp && mv /tmp/cl_tmp CHANGELOG.md || \
	{ \
		echo "## v$(VERSION) — $(DATE)" > CHANGELOG.md; \
		echo "" >> CHANGELOG.md; \
	}
	@echo "CHANGELOG.md actualizado."

release-patch: bump-patch tag changelog ## Release patch: bump + tag + changelog
	@echo "✓ Release patch completado."

release-minor: bump-minor tag changelog ## Release minor: bump + tag + changelog
	@echo "✓ Release minor completado."

help: ## Mostrar ayuda
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
		| awk 'BEGIN {FS = ":.*?## "}; {printf "  %-20s %s\n", $$1, $$2}'
