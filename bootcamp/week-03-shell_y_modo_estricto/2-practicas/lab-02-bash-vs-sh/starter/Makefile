# ============================================================
# Lab 02 — bash frente a /bin/sh, y .SHELLFLAGS
# Semana 03: Shell en recetas y modo estricto
# ============================================================
# Este Makefile no fija SHELL: Make usa /bin/sh. En Debian/Ubuntu (y en casi
# todas las imágenes Docker y runners de CI) /bin/sh es dash, no bash.
# En macOS añade SHELL=/bin/dash a los comandos de los pasos 1 a 3.
# ============================================================

# TODO (paso 4): fija bash como shell de las recetas.

# TODO (paso 5): añade .SHELLFLAGS con -e y -c.
# TODO (paso 6): amplía .SHELLFLAGS a la forma completa del preámbulo estricto.

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

check-config: ## Falla si no existe build/config.ini... ¿o no?
	test -f $(BUILD_DIR)/config.ini; echo "config OK"

publish: ## "Publica" en DEST_DIR (make publish DEST_DIR=/srv/www)
	echo "publicando en $$DEST_DIR/app"

clean: ## Borra build/
	$(if $(BUILD_DIR),,$(error BUILD_DIR vacía: rm -rf no se ejecuta))
	rm -rf -- '$(BUILD_DIR)'

help: ## Muestra los targets disponibles
	@echo "Targets disponibles:"
	@grep -hE '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
		| awk 'BEGIN {FS = ":.*?## "}; {printf "  %-20s %s\n", $$1, $$2}'
