# ============================================================
# Proyecto Semana 03 — Reportes de accesos a prueba de fallos (SOLUCIÓN)
# ============================================================

# ── Preámbulo estricto ───────────────────────────────────────
# bash y no /bin/sh: dash no tiene pipefail ni [[ ]].
# -e: para al primer comando que falla. -u: variable de shell sin definir = error.
# -o pipefail: una tubería falla si falla cualquier etapa, no solo la última.
# -c: obligatorio al final; sin él bash trataría la receta como un archivo.
SHELL       := bash
.SHELLFLAGS := -eu -o pipefail -c
# Si una receta falla, Make borra el target que dejó a medio escribir.
.DELETE_ON_ERROR:

.PHONY: report package clean help
.DEFAULT_GOAL := help

# ── Entrada y salida ─────────────────────────────────────────
LOG       := data/access.csv
BUILD_DIR := build
AWK       := awk

STATUS    := $(BUILD_DIR)/status.txt
TOP_PATHS := $(BUILD_DIR)/top-paths.txt
ERRORS    := $(BUILD_DIR)/errors.csv
SUMMARY   := $(BUILD_DIR)/summary.txt
PACKAGE   := $(BUILD_DIR)/reportes.tar.gz

# sort y uniq ordenan según el locale; con C el resultado es el mismo en todas partes.
export LC_ALL := C

# Programa awk que corta la tubería si una línea no tiene las 4 columnas
# timestamp,method,path,status. Va al principio de cada tubería: sin pipefail,
# su exit 1 se perdería detrás de sort.
VALIDATE := NF != 4 { print FILENAME ":" NR ": línea corrupta (" NF " columnas)" > "/dev/stderr"; exit 1 }

# ── Reportes ─────────────────────────────────────────────────
report: $(SUMMARY) ## Genera los reportes en build/

$(STATUS): $(LOG)
	@mkdir -p $(BUILD_DIR)
	$(AWK) -F, '$(VALIDATE) { print $$4 }' $(LOG) | sort | uniq -c | sort -rn > $@

# awk 'NR <= 3' en vez de head -n 3: head cierra la tubería antes de tiempo,
# la etapa anterior muere con SIGPIPE (141) y pipefail lo cuenta como fallo.
$(TOP_PATHS): $(LOG)
	@mkdir -p $(BUILD_DIR)
	$(AWK) -F, '$(VALIDATE) { print $$3 }' $(LOG) | sort | uniq -c | sort -rn | $(AWK) 'NR <= 3' > $@

# grep sale con 1 si no encuentra nada: eso no es un error aquí, pero 2 (archivo
# ilegible, regex mala) sí lo es. "|| test $$? -eq 1" tolera solo el 1.
$(ERRORS): $(LOG)
	@mkdir -p $(BUILD_DIR)
	grep -E ',5[0-9]{2}$$' $(LOG) > $@ || test $$? -eq 1

# Todo el bloque { ...; } es una sola línea lógica: un solo shell, una sola redirección.
$(SUMMARY): $(LOG) $(STATUS) $(TOP_PATHS) $(ERRORS)
	{ \
	  echo "Reporte de accesos: $(LOG)"; \
	  echo "Total de peticiones: $$($(AWK) 'END { print NR }' $(LOG))"; \
	  echo "Errores 5xx: $$($(AWK) 'END { print NR }' $(ERRORS))"; \
	  echo "Rutas más visitadas:"; \
	  cat $(TOP_PATHS); \
	} > $@
	@echo "Reporte listo en $@"

# ── Paquete ──────────────────────────────────────────────────
package: $(PACKAGE) ## Empaqueta los reportes en build/reportes.tar.gz

# cd y tar en la misma línea: cada línea de receta es un shell nuevo.
$(PACKAGE): $(SUMMARY)
	cd $(BUILD_DIR) && tar -czf reportes.tar.gz summary.txt status.txt top-paths.txt errors.csv

# ── Limpieza ─────────────────────────────────────────────────
# Las guardas se expanden antes de ejecutar nada, también con make -n.
clean: ## Borra build/ (con guardas)
	$(if $(BUILD_DIR),,$(error BUILD_DIR vacía: rm -rf no se ejecuta))
	$(if $(filter $(CURDIR)/%,$(abspath $(BUILD_DIR))),,$(error BUILD_DIR='$(BUILD_DIR)' está fuera del proyecto: rm -rf no se ejecuta))
	rm -rf -- '$(BUILD_DIR)'

help: ## Muestra los targets disponibles
	@echo "Targets disponibles:"
	@grep -hE '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
		| awk 'BEGIN {FS = ":.*?## "}; {printf "  %-20s %s\n", $$1, $$2}'
