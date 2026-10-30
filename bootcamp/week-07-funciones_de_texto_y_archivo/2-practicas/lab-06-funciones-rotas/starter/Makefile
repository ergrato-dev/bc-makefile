# ============================================================
# Lab 06 — funciones rotas (6 bugs)
# Semana 07: Funciones de texto y archivo
# ============================================================

.PHONY: demo help
.DEFAULT_GOAL := help

SRCS     := src/main.c src/parser.c src/utils.c
INC_DIRS := include

# BUG 1: patsubst - el stem no captura el directorio, genera rutas incorrectas
# Esperado: build/main.o build/parser.o build/utils.o
OBJS := $(patsubst %.c,%.o,$(SRCS))

# BUG 2: filter sin comodín % - patrón literal que nunca coincide
# Esperado: src/main.c src/parser.c src/utils.c
C_SRCS := $(filter .c,$(SRCS))

# BUG 3: filter-out con literal - no coincide con rutas completas
# Esperado: src/main.c src/parser.c
NO_UTILS := $(filter-out utils,$(SRCS))

# BUG 4: addprefix aplicado a las fuentes en vez de a INC_DIRS
# Esperado: -Iinclude
INC_FLAGS := $(addprefix -I,$(SRCS))

# BUG 5: espacio tras la coma en subst - parte cada nombre en dos palabras
# Esperado: src/main.d src/parser.d src/utils.d (3 palabras)
DEPS := $(subst .c, .d,$(SRCS))

# BUG 6: el comentario al final de la línea deja espacios en el valor
# Esperado: out/app
OUT_DIR := out    # directorio de salida
BIN     := $(OUT_DIR)/app

demo: ## Muestra las transformaciones (con bugs — corrígelos)
	@echo "OBJS:      $(OBJS)"
	@echo "C_SRCS:    $(C_SRCS)"
	@echo "NO_UTILS:  $(NO_UTILS)"
	@echo "INC_FLAGS: $(INC_FLAGS)"
	@echo "DEPS:      $(DEPS) ($(words $(DEPS)) palabras)"
	@echo "BIN:       [$(BIN)]"

help: ## Muestra esta ayuda
	@echo "Targets disponibles:"
	@grep -hE '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
		| awk 'BEGIN {FS = ":.*?## "}; {printf "  %-20s %s\n", $$1, $$2}'
