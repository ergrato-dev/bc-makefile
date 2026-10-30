# ============================================================
# Lab 05 — Portabilidad (STARTER)
# Semana 13: Seguridad, portabilidad y alternativas
# ============================================================
# Funciona en Linux con GNU Make 4.3. En el Mac de tu compañera (make 3.81,
# sed/stat/date de BSD) falla de cinco formas distintas, y una en silencio.

# TODO (paso 1): guarda de versión mínima, ANTES de cualquier otra línea.

SHELL       := bash
.SHELLFLAGS := -eu -o pipefail -c
.DELETE_ON_ERROR:

.PHONY: help package stamp-docs info posix portability-check clean
.DEFAULT_GOAL := help

# TODO (paso 2): activa --output-sync solo si esta Make lo soporta (.FEATURES).

DIST     := dist
ARTIFACT := $(DIST)/app.tar.gz
# $(file <) lee sin lanzar un shell... desde GNU Make 4.2.
VERSION  := $(strip $(file < VERSION))

help: ## Muestra los targets disponibles
	@echo "Targets disponibles:"
	@grep -hE '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
		| awk 'BEGIN {FS = ":.*?## "}; {printf "  %-20s %s\n", $$1, $$2}'

$(DIST):
	mkdir -p '$@'

package: $(ARTIFACT) ## Empaqueta VERSION y docs/ en dist/app.tar.gz

$(ARTIFACT): VERSION $(wildcard docs/*.md) | $(DIST)
	tar -czf '$@' VERSION docs

# TODO (paso 3): cinco comandos que no existen, o se comportan distinto, en macOS/BSD.
stamp-docs: ## Escribe la versión actual en docs/intro.md
	sed -i 's/^Versión: .*/Versión: $(VERSION)/' docs/intro.md

info: package ## Muestra tamaño, checksum y fecha del artefacto
	@echo -e "Artefacto:\t$(ARTIFACT)"
	@echo "Tamaño: $$(stat -c %s '$(ARTIFACT)') bytes"
	@echo "SHA-256: $$(sha256sum '$(ARTIFACT)' | cut -d' ' -f1)"
	@echo "Fecha: $$(date --iso-8601=seconds)"

# TODO (pasos 4 y 5): Makefile.posix tiene que funcionar con cualquier make POSIX.
posix: ## Construye docs/*.html con Makefile.posix
	$(MAKE) -f Makefile.posix

portability-check: ## Busca extensiones GNU en Makefile.posix
	@echo "TODO: implementa portability-check"
	@exit 1

clean: ## Borra dist/ y los HTML generados
	$(if $(DIST),,$(error DIST vacía: rm -rf no se ejecuta))
	rm -rf -- '$(DIST)'
	$(MAKE) -f Makefile.posix clean
