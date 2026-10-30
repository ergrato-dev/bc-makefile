# shared-mk/ci.mk — Módulo de CI reutilizable
.PHONY: ci lint

# Cada módulo de lenguaje define su LINT_CMD.
LINT_CMD ?=

lint: deps ## Verificar estilo del código
	$(LINT_CMD)
	@echo "[$(APP_NAME)] Lint OK"

# Sin -j el orden de la lista da fallo rápido. Con -j, lint, test y build
# corren a la vez, y es seguro: comparten el stamp de deps (Make lo construye
# una sola vez) y ninguno escribe lo que otro lee.
ci: lint test build ## Ejecutar pipeline CI del servicio
