# ============================================================
# Lab 03 — .PHONY: targets que no crean archivos (SOLUCIÓN)
# ============================================================

.PHONY: all build clean help

.DEFAULT_GOAL := help

all: build ## construye todo
	@echo "Todo listo."

build: ## crea output/app.txt
	@echo "Construyendo..."
	@mkdir -p output
	@echo "contenido de la app" > output/app.txt
	@echo "Build completo: output/app.txt creado"

clean: ## elimina directorio output
	@echo "Limpiando output/..."
	@rm -rf output
	@echo "Limpio."

help: ## muestra esta ayuda
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
		| awk 'BEGIN {FS = ":.*?## "}; {printf "  %-20s %s\n", $$1, $$2}'
