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

demo: ## Muestra las transformaciones (con bugs — corrígelos)
	@echo "OBJS:      $(OBJS)"
	@echo "C_SRCS:    $(C_SRCS)"
	@echo "NO_UTILS:  $(NO_UTILS)"
	@echo "INC_FLAGS: $(INC_FLAGS)"

help: ## Muestra esta ayuda
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
		| awk 'BEGIN {FS = ":.*?## "}; {printf "  %-20s %s\n", $$1, $$2}'
