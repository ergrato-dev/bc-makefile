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
#       (build, serve, clean, check, deploy, help)

.DEFAULT_GOAL := help

# -- Targets --------------------------------------------------

## build: copia src/ a dist/
build:
	# TODO: copia $(SRC_DIR)/ a $(DIST_DIR)/ usando cp -r
	# Pista: cp -r $(SRC_DIR)/ $(DIST_DIR)/
	# Después del copy, imprime "Build OK: $(DIST_DIR)/ listo"

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
