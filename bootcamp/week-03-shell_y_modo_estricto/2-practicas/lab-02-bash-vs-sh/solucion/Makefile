# ============================================================
# Lab 02 — bash frente a /bin/sh, y .SHELLFLAGS (SOLUCIÓN)
# Semana 03: Shell en recetas y modo estricto
# ============================================================

# bash, buscado en el PATH. Make ignora la variable SHELL de tu entorno: si no
# la fijas aquí, usa /bin/sh (dash en Debian/Ubuntu), da igual que tu terminal
# sea bash o zsh.
SHELL       := bash
# -e: una línea con varios comandos para en el primero que falla.
# -u: una variable de shell sin definir es un error, no una cadena vacía.
# -o pipefail: la tubería falla si falla cualquier etapa (lab-03).
# -c: Make añade la receta detrás; sin -c, bash la tomaría como un archivo.
.SHELLFLAGS := -eu -o pipefail -c
# Borra el target si su receta falla (lab-04).
.DELETE_ON_ERROR:

.PHONY: which-shell mode dirs pipe check-config publish clean help
.DEFAULT_GOAL := help

BUILD_DIR := build
ENV       := dev

which-shell: ## Muestra qué shell ejecuta las recetas
	@echo "Las recetas las ejecuta: $$0"

mode: ## Muestra el modo según ENV (make mode ENV=prod)
	@if [[ "$(ENV)" == prod ]]; then echo "modo producción"; else echo "modo desarrollo"; fi

dirs: ## Crea build/logs y build/tmp en un solo mkdir
	mkdir -p $(BUILD_DIR)/{logs,tmp}
	ls $(BUILD_DIR)

pipe: ## Activa pipefail y ejecuta una tubería
	set -o pipefail; echo "pipefail activo"

check-config: ## Falla si no existe build/config.ini
	test -f $(BUILD_DIR)/config.ini; echo "config OK"

# Con -u, DEST_DIR sin definir es un error: mejor que publicar en /app.
publish: ## "Publica" en DEST_DIR (make publish DEST_DIR=/srv/www)
	echo "publicando en $$DEST_DIR/app"

clean: ## Borra build/
	$(if $(BUILD_DIR),,$(error BUILD_DIR vacía: rm -rf no se ejecuta))
	rm -rf -- '$(BUILD_DIR)'

help: ## Muestra los targets disponibles
	@echo "Targets disponibles:"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
		| awk 'BEGIN {FS = ":.*?## "}; {printf "  %-20s %s\n", $$1, $$2}'
