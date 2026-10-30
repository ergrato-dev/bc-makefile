# ============================================================
# Proyecto Semana 03 — Reportes de accesos a prueba de fallos
# ============================================================
# Instrucciones:
#   1. Completa los TODO en orden (el README del proyecto tiene un paso por TODO).
#   2. Comprueba cada paso con el comando que indica el README.
#   3. Al final: ./scripts/verificar-semana.sh 03 desde la raíz del repo.
# ============================================================

# TODO 1: preámbulo estricto, antes de cualquier otra línea:
#   SHELL       := bash
#   .SHELLFLAGS := -eu -o pipefail -c
#   .DELETE_ON_ERROR:

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
# timestamp,method,path,status. Úsalo al principio de cada tubería así:
#   $(AWK) -F, '$(VALIDATE) { print $$4 }' $(LOG) | ...
VALIDATE := NF != 4 { print FILENAME ":" NR ": línea corrupta (" NF " columnas)" > "/dev/stderr"; exit 1 }

# ── Reportes ─────────────────────────────────────────────────
report: $(SUMMARY) ## Genera los reportes en build/

# Esta regla ya funciona con datos limpios, pero no es a prueba de fallos:
# no valida las columnas. TODO 2: añade $(VALIDATE) a la primera etapa.
$(STATUS): $(LOG)
	@mkdir -p $(BUILD_DIR)
	$(AWK) -F, '{ print $$4 }' $(LOG) | sort | uniq -c | sort -rn > $@

# TODO 3: las 3 rutas (columna 3) más visitadas, con el mismo formato que
# status.txt ("     14 /api/users"). Valida las columnas igual que en TODO 2.
$(TOP_PATHS): $(LOG)
	@echo "TODO 3: genera $@"

# TODO 4: copia a $@ las líneas del log cuyo código es 5xx.
# Un log sin errores 5xx tiene que generar un errors.csv vacío, no romper el build.
$(ERRORS): $(LOG)
	@echo "TODO 4: genera $@"

# TODO 5: escribe $@ con este formato exacto (los números salen del log):
#   Reporte de accesos: data/access.csv
#   Total de peticiones: 40
#   Errores 5xx: 4
#   Rutas más visitadas:
#        14 /api/users
#        ...
$(SUMMARY): $(LOG) $(STATUS) $(TOP_PATHS) $(ERRORS)
	@echo "TODO 5: genera $@"

# ── Paquete ──────────────────────────────────────────────────
package: $(PACKAGE) ## Empaqueta los reportes en build/reportes.tar.gz

# TODO 6: reportes.tar.gz dentro de build/ con summary.txt, status.txt,
# top-paths.txt y errors.csv en la raíz del archivo (sin el prefijo build/).
$(PACKAGE): $(SUMMARY)
	@echo "TODO 6: genera $@"

# ── Limpieza ─────────────────────────────────────────────────
# TODO 7: borra $(BUILD_DIR) con dos guardas antes del rm:
#   - BUILD_DIR vacía     → "BUILD_DIR vacía: rm -rf no se ejecuta"
#   - BUILD_DIR fuera del proyecto (/, .., /home...) → "... está fuera del proyecto ..."
clean: ## Borra build/ (con guardas)
	@echo "TODO 7: implementa clean"

help: ## Muestra los targets disponibles
	@echo "Targets disponibles:"
	@grep -hE '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
		| awk 'BEGIN {FS = ":.*?## "}; {printf "  %-20s %s\n", $$1, $$2}'
