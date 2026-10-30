# ============================================================
# Lab 02 — Carreras en paralelo (SOLUCIÓN)
# Semana 10: Paralelismo y recursión
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
# FIX A: la receta lee $(CONFIG), así que es prerrequisito. En serie
#        funcionaba solo porque all la listaba antes que las páginas.
# FIX B: un temporal por target ($@.tmp). Con un único out/tmp.txt,
#        tres páginas en paralelo escribían y movían el mismo archivo.
$(OUT_DIR)/%.html: $(CONFIG) | $(OUT_DIR)
	@echo "[$*] generando"
	@grep '^titulo=' $< | cut -d= -f2 > $@.tmp
	@echo "<h1>$*</h1>" >> $@.tmp
	@sleep 1
	@mv $@.tmp $@

# El sitio es la concatenación de todas las páginas.
# FIX C: depende de las páginas que concatena, no de la configuración.
$(SITE): $(PAGE_FILES)
	@echo "[site] ensamblando"
	@cat $^ > $@

$(OUT_DIR):
	@mkdir -p $@

# FIX D: con -j, 'rebuild: clean all' ejecuta clean y all a la vez.
# Make 4.3: dos sub-makes en secuencia. Make 4.4+: rebuild: clean .WAIT all
rebuild: ## Borra y reconstruye el sitio
	@$(MAKE) --no-print-directory clean
	@$(MAKE) --no-print-directory all

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
