# ============================================================
# Monorepo — build paralelo y recursión segura
# Semana 10: Paralelismo y recursión
# ============================================================

# TODO 1: preámbulo estricto (semana 03): SHELL, .SHELLFLAGS y
#         .DELETE_ON_ERROR, en este orden y antes de cualquier regla.

# TODO 2: salida agrupada con -j sin que nadie tenga que pasar -O.
#         Define OUTPUT_SYNC ?= target ANTES de añadirlo a MAKEFLAGS
#         con --output-sync (Make 4.4 lee MAKEFLAGS en cuanto cambia).

# --- Paquetes ------------------------------------------------
PKG_DIR  := packages
PACKAGES := core util docs app

.PHONY: all clean rebuild legacy-all help
.DEFAULT_GOAL := help

# --------------------------------------------------------------------------
# Build heredado: así se construía el monorepo hasta hoy. Funciona en serie,
# pero el código de salida es el del último paquete, -j no paraleliza nada
# (es una sola receta) y 'make' literal no hereda flags ni jobserver.
# Pruébalo antes de tocar nada:  make legacy-all FAIL=docs; echo $?
# TODO 7: bórralo cuando 'all' lo reemplace.
# --------------------------------------------------------------------------
legacy-all: ## Build heredado con bucle for (bórralo al terminar)
	for p in $(PACKAGES); do make --no-print-directory -C $(PKG_DIR)/$$p build; done

# TODO 3: PKG_TARGETS con un target phony por paquete y meta:
#         packages/core/build packages/core/clean packages/util/build ...
#         Tip: $(foreach g,build clean,$(addsuffix /$(g),$(addprefix $(PKG_DIR)/,$(PACKAGES))))
#         Añádelos a .PHONY.

# TODO 4: una sola regla para todos los PKG_TARGETS que entre en $(@D) y
#         ejecute $(@F). Usa $(MAKE), nunca make, y --no-print-directory.

# TODO 5: all y clean sin receta: solo prerrequisitos (packages/<p>/build,
#         packages/<p>/clean). Después, declara que packages/app/build
#         depende de packages/core/build y packages/util/build.
all: ## Construye todos los paquetes
	@echo "TODO: implementa all"

clean: ## Borra el dist/ de cada paquete
	@echo "TODO: implementa clean"

# TODO 6: rebuild = clean y luego all, correcto con -j8.
#         'rebuild: clean all' NO sirve: con -j ambos corren a la vez.
rebuild: ## Borra y reconstruye todo (seguro con -j)
	@echo "TODO: implementa rebuild"

# --- Utilidades ----------------------------------------------
help: ## Muestra los targets disponibles
	@echo "Targets disponibles:"
	@grep -hE '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
		| awk 'BEGIN {FS = ":.*?## "}; {printf "  %-20s %s\n", $$1, $$2}'
