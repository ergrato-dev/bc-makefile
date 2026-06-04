# ============================================================
# Proyecto Semana 01 — Makefile para sitio estático (SOLUCIÓN)
# ============================================================

.PHONY: build serve clean check deploy help

# -- Variables ------------------------------------------------
SRC_DIR  := src
DIST_DIR := dist
PORT     := 8080

.DEFAULT_GOAL := help

# -- Targets --------------------------------------------------

## build: copia src/ a dist/
build:
	@cp -r $(SRC_DIR)/ $(DIST_DIR)/
	@echo "Build OK: $(DIST_DIR)/ listo"

## serve: inicia servidor local en dist/ (Ctrl+C para detener)
serve: build
	@echo "Servidor en http://localhost:$(PORT)"
	@python3 -m http.server $(PORT) --directory $(DIST_DIR)

## clean: elimina dist/
clean:
	@rm -rf $(DIST_DIR)
	@echo "Limpio."

## check: verifica que los HTML existen y no están vacíos
check:
	@echo "Verificando $(DIST_DIR)/..."
	@test -s $(DIST_DIR)/index.html \
		&& echo "  ✓ $(DIST_DIR)/index.html existe y tiene contenido" \
		|| (echo "Error: $(DIST_DIR)/index.html no encontrado. Ejecuta 'make build' primero." && exit 1)
	@test -s $(DIST_DIR)/about.html \
		&& echo "  ✓ $(DIST_DIR)/about.html existe y tiene contenido" \
		|| (echo "Error: $(DIST_DIR)/about.html no encontrado. Ejecuta 'make build' primero." && exit 1)
	@echo "Check OK."

## deploy: simula el envío de archivos al servidor
deploy: check
	@echo "Archivos a desplegar:"
	@find $(DIST_DIR) -type f | sort | sed 's/^/  /'
	@echo "Deploy simulado OK."

## help: muestra esta ayuda
help:
	@grep -E '^## ' $(MAKEFILE_LIST) \
		| awk 'BEGIN {FS = ": "}; {printf "  %-20s %s\n", $$1, $$2}' \
		| sed 's/## //'
