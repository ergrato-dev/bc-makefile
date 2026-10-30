# ============================================================
# Proyecto Semana 01 — Makefile para sitio estático (SOLUCIÓN)
# ============================================================

.PHONY: build sitemap serve clean check deploy help

# -- Variables ------------------------------------------------
SRC_DIR  := src
DIST_DIR := dist
PORT     := 8080

.DEFAULT_GOAL := help

# -- Targets --------------------------------------------------

build: $(DIST_DIR)/sitemap.txt ## copia src/ a dist/ y genera el sitemap
	@mkdir -p $(DIST_DIR)
	@cp -r $(SRC_DIR)/. $(DIST_DIR)/
	@echo "Build OK: $(DIST_DIR)/ listo"

sitemap: $(DIST_DIR)/sitemap.txt ## genera dist/sitemap.txt solo si cambió algún HTML

# Target de archivo real: Make compara su fecha con la de los HTML
$(DIST_DIR)/sitemap.txt: $(SRC_DIR)/index.html $(SRC_DIR)/about.html
	@mkdir -p $(DIST_DIR)
	@echo "Generando $(DIST_DIR)/sitemap.txt"
	@ls $(SRC_DIR)/*.html | sed 's|^$(SRC_DIR)||' > $(DIST_DIR)/sitemap.txt

serve: build ## inicia servidor local en dist/ (Ctrl+C para detener)
	@echo "Servidor en http://localhost:$(PORT)"
	@python3 -m http.server $(PORT) --directory $(DIST_DIR)

clean: ## elimina dist/
	@rm -rf $(DIST_DIR)
	@echo "Limpio."

check: ## verifica que los HTML existen y no están vacíos
	@echo "Verificando $(DIST_DIR)/..."
	@test -s $(DIST_DIR)/index.html \
		&& echo "  ✓ $(DIST_DIR)/index.html existe y tiene contenido" \
		|| (echo "Error: $(DIST_DIR)/index.html no encontrado. Ejecuta 'make build' primero." && exit 1)
	@test -s $(DIST_DIR)/about.html \
		&& echo "  ✓ $(DIST_DIR)/about.html existe y tiene contenido" \
		|| (echo "Error: $(DIST_DIR)/about.html no encontrado. Ejecuta 'make build' primero." && exit 1)
	@echo "Check OK."

deploy: check ## simula el envío de archivos al servidor
	@echo "Archivos a desplegar:"
	@find $(DIST_DIR) -type f | sort | sed 's/^/  /'
	@echo "Deploy simulado OK."

help: ## muestra esta ayuda
	@grep -hE '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
		| awk 'BEGIN {FS = ":.*?## "}; {printf "  %-20s %s\n", $$1, $$2}'
