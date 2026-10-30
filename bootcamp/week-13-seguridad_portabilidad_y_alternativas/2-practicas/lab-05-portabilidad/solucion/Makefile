# ============================================================
# Lab 05 — Portabilidad (SOLUCIÓN)
# ============================================================

# --- Guarda de versión ----------------------------------------------------------
# Primera línea efectiva y con sintaxis de Make 3.81, para que el make de macOS
# pueda leerla y explicar qué pasa. Sin ella, 3.81 ignora .SHELLFLAGS en
# silencio (pierde pipefail) y $(file <) devuelve vacío.
# $(sort) compara texto: vale mientras no exista una 4.10.
MIN_MAKE_VERSION := 4.3
ifneq ($(MIN_MAKE_VERSION),$(firstword $(sort $(MAKE_VERSION) $(MIN_MAKE_VERSION))))
  $(error Se requiere GNU Make >= $(MIN_MAKE_VERSION); tienes $(MAKE_VERSION). En macOS: brew install make y usa gmake)
endif

# bash no está en /bin en todos los sistemas (FreeBSD: /usr/local/bin); por
# nombre, Make lo busca en el PATH.
SHELL       := bash
.SHELLFLAGS := -eu -o pipefail -c
.DELETE_ON_ERROR:

.PHONY: help package stamp-docs info posix portability-check clean
.DEFAULT_GOAL := help

# --- Detección de features --------------------------------------------------------
# Mejor preguntar por la feature que por el número de versión.
ifneq ($(filter output-sync,$(.FEATURES)),)
  MAKEFLAGS += --output-sync=target
endif

DIST     := dist
ARTIFACT := $(DIST)/app.tar.gz
VERSION  := $(strip $(file < VERSION))
# sha256sum (GNU) o shasum -a 256 (macOS/BSD). '=' perezoso: solo si se usa.
SHA256SUM = $(if $(shell command -v sha256sum 2>/dev/null),sha256sum,shasum -a 256)

help: ## Muestra los targets disponibles
	@echo "Targets disponibles:"
	@grep -hE '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
		| awk 'BEGIN {FS = ":.*?## "}; {printf "  %-20s %s\n", $$1, $$2}'

$(DIST):
	mkdir -p '$@'

package: $(ARTIFACT) ## Empaqueta VERSION y docs/ en dist/app.tar.gz

$(ARTIFACT): VERSION $(wildcard docs/*.md) | $(DIST)
	tar -czf '$@' VERSION docs

# FIX sed -i: en BSD el argumento de -i es el sufijo de backup. Archivo
# temporal + mv funciona en los dos.
stamp-docs: ## Escribe la versión actual en docs/intro.md
	sed 's/^Versión: .*/Versión: $(VERSION)/' docs/intro.md > docs/intro.md.tmp
	mv docs/intro.md.tmp docs/intro.md

# FIX echo -e -> printf. FIX stat -c -> wc -c. FIX sha256sum -> $(SHA256SUM).
# FIX date --iso-8601 -> formato explícito con +.
info: package ## Muestra tamaño, checksum y fecha del artefacto
	@printf 'Artefacto:\t%s\n' '$(ARTIFACT)'
	@echo "Tamaño: $$(wc -c < '$(ARTIFACT)' | tr -d ' ') bytes"
	@echo "SHA-256: $$($(SHA256SUM) '$(ARTIFACT)' | cut -d' ' -f1)"
	@echo "Fecha: $$(date -u +%Y-%m-%dT%H:%M:%SZ)"

posix: ## Construye docs/*.html con Makefile.posix
	$(MAKE) -f Makefile.posix

# Extensiones GNU que POSIX.1-2024 no tiene (\# escapa el # dentro de una
# variable; sin él, Make lo tomaría como comentario). ::=, ?=, +=, !=, $^, .PHONY
# e -include sí son POSIX desde 2024.
GNUISMS := -e '^[[:space:]]*(ifeq|ifneq|ifdef|ifndef|else|endif|define|endef|override|export|unexport|vpath)([[:space:]]|$$)' \
           -e '[$$]\((shell|wildcard|patsubst|subst|foreach|call|if|or|and|filter|filter-out|sort|dir|notdir|basename|addprefix|addsuffix|eval|file|info|warning|error)[[:space:]]' \
           -e '^[^\#[:space:]=]*%[^=]*:' \
           -e '(^|[^:])[:]='

portability-check: ## Busca extensiones GNU en Makefile.posix
	@if grep -nE $(GNUISMS) Makefile.posix; then \
		echo "Makefile.posix usa extensiones GNU (líneas de arriba)" >&2; exit 1; fi
	@echo "Makefile.posix: sin extensiones GNU conocidas"

clean: ## Borra dist/ y los HTML generados
	$(if $(DIST),,$(error DIST vacía: rm -rf no se ejecuta))
	rm -rf -- '$(DIST)'
	$(MAKE) -f Makefile.posix clean
