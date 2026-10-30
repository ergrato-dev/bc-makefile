# ============================================================
# Proyecto Semana 01 — Makefile para sitio estático
# ============================================================
# Instrucciones:
#   1. Lee README.md del proyecto antes de empezar
#   2. Implementa cada target siguiendo los TODO
#   3. Verifica con los comandos de la sección "Verificación"
# ============================================================

# -- Variables ------------------------------------------------
SRC_DIR  := src
DIST_DIR := dist
PORT     := 8080

# -- Declaraciones --------------------------------------------
# TODO: declara .PHONY con todos los targets que no producen archivos
#       (build, sitemap, serve, clean, check, deploy, help)

.DEFAULT_GOAL := help

# -- Targets --------------------------------------------------

# TODO: cuando tengas la regla de dist/sitemap.txt, haz que build dependa de ella:
#       build: $(DIST_DIR)/sitemap.txt
## build: copia src/ a dist/ y genera el sitemap
build:
	# TODO: crea $(DIST_DIR)/ con mkdir -p y copia el CONTENIDO de $(SRC_DIR)/ dentro
	# Pista: cp -r $(SRC_DIR)/. $(DIST_DIR)/  (el /. evita que la segunda vez cree $(DIST_DIR)/src/)
	# Después del copy, imprime "Build OK: $(DIST_DIR)/ listo"

## sitemap: genera dist/sitemap.txt solo si cambió algún HTML
sitemap:
	# TODO: haz que sitemap dependa de $(DIST_DIR)/sitemap.txt y deja la receta vacía

# TODO: escribe la regla del ARCHIVO $(DIST_DIR)/sitemap.txt (no es .PHONY):
#   - dependencias: $(SRC_DIR)/index.html $(SRC_DIR)/about.html
#   - receta: crea $(DIST_DIR) con mkdir -p, imprime "Generando $(DIST_DIR)/sitemap.txt"
#     y escribe una línea por página:
#       ls $(SRC_DIR)/*.html | sed 's|^$(SRC_DIR)||' > $(DIST_DIR)/sitemap.txt
#   - resultado esperado en el archivo:  /about.html  y  /index.html

## serve: inicia servidor local en dist/ (puerto 8080)
serve: build
	# TODO: imprime "Servidor en http://localhost:$(PORT)"
	# TODO: ejecuta python3 -m http.server $(PORT) --directory $(DIST_DIR)

## clean: elimina dist/
clean:
	# TODO: elimina $(DIST_DIR) con rm -rf
	# Imprime "Limpio."

## check: verifica que los HTML existen y no están vacíos
check:
	# TODO: verifica que $(DIST_DIR)/index.html existe y tiene contenido
	#       usa: test -s $(DIST_DIR)/index.html
	#       si no existe: imprime el error y falla con exit 1
	# TODO: repite para $(DIST_DIR)/about.html
	# Si todo OK: imprime "Check OK."

## deploy: simula el envío de archivos al servidor
deploy: check
	# TODO: imprime "Archivos a desplegar:"
	# TODO: lista los archivos en $(DIST_DIR) con find
	# TODO: imprime "Deploy simulado OK."

## help: muestra esta ayuda
help:
	# TODO: implementa el patrón grep+awk para listar targets con ##
