# ============================================================
# Lab 02 — Carreras en paralelo (Makefile ROTO a propósito)
# Semana 10: Paralelismo y recursión
#
# En serie funciona. Con -j falla, y no siempre igual.
# Hay cuatro bugs; ninguno está marcado. Deja un comentario
# "# FIX:" encima de cada línea que corrijas.
# ============================================================

SHELL       := bash
.SHELLFLAGS := -eu -o pipefail -c
.DELETE_ON_ERROR:

.PHONY: all clean rebuild check help
.DEFAULT_GOAL := help

# --- Configuración -------------------------------------------
OUT_DIR    := out
PAGES      := inicio blog contacto
PAGE_FILES := $(PAGES:%=$(OUT_DIR)/%.html)
CONFIG     := $(OUT_DIR)/config.txt
SITE       := $(OUT_DIR)/site.html

# --- Build ---------------------------------------------------
all: $(CONFIG) $(PAGE_FILES) $(SITE) ## Construye el sitio

# Leer y validar la configuración tarda un segundo.
$(CONFIG): | $(OUT_DIR)
	@echo "[config] generando"
	@sleep 1
	@echo "titulo=Mi sitio" > $@

# Cada página lleva el título de la configuración y su propio <h1>.
$(OUT_DIR)/%.html: | $(OUT_DIR)
	@echo "[$*] generando"
	@grep '^titulo=' $(CONFIG) | cut -d= -f2 > $(OUT_DIR)/tmp.txt
	@echo "<h1>$*</h1>" >> $(OUT_DIR)/tmp.txt
	@sleep 1
	@mv $(OUT_DIR)/tmp.txt $@

# El sitio es la concatenación de todas las páginas.
$(SITE): $(CONFIG)
	@echo "[site] ensamblando"
	@cat $(PAGE_FILES) > $@

$(OUT_DIR):
	@mkdir -p $@

rebuild: clean all ## Borra y reconstruye el sitio

# --- Verificación --------------------------------------------
check: ## Verifica que el sitio generado es correcto
	@test -f $(SITE) || { echo "check: falta $(SITE)"; exit 1; }
	@for p in $(PAGES); do \
		grep -qx "<h1>$$p</h1>" $(OUT_DIR)/$$p.html || { echo "check: $$p.html tiene contenido ajeno"; exit 1; }; \
		test "$$(wc -l < $(OUT_DIR)/$$p.html)" -eq 2 || { echo "check: $$p.html tiene contenido ajeno"; exit 1; }; \
	done
	@test "$$(grep -c '^<h1>' $(SITE))" -eq $(words $(PAGES)) || { echo "check: $(SITE) no tiene $(words $(PAGES)) páginas"; exit 1; }
	@echo "check: OK"

# --- Utilidades ----------------------------------------------
clean: ## Borra out/
	$(if $(OUT_DIR),,$(error OUT_DIR vacía: rm -rf no se ejecuta))
	@rm -rf -- '$(OUT_DIR)'

help: ## Muestra los targets disponibles
	@echo "Targets disponibles:"
	@grep -hE '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
		| awk 'BEGIN {FS = ":.*?## "}; {printf "  %-20s %s\n", $$1, $$2}'
