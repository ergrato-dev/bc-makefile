.PHONY: demo help
.DEFAULT_GOAL := help

SRCS     := src/main.c src/parser.c src/utils.c
INC_DIRS := include

# FIX 1: stem correcto captura el directorio src/
OBJS := $(patsubst src/%.c,build/%.o,$(SRCS))

# FIX 2: % antes de .c para que coincida con cualquier archivo .c
C_SRCS := $(filter %.c,$(SRCS))

# FIX 3: % para coincidir con cualquier palabra que contenga utils.c
NO_UTILS := $(filter-out %utils.c,$(SRCS))

# FIX 4: addprefix sobre INC_DIRS, no sobre las fuentes
INC_FLAGS := $(addprefix -I,$(INC_DIRS))

demo: ## Muestra las transformaciones corregidas
	@echo "OBJS:      $(OBJS)"
	@echo "C_SRCS:    $(C_SRCS)"
	@echo "NO_UTILS:  $(NO_UTILS)"
	@echo "INC_FLAGS: $(INC_FLAGS)"

help: ## Muestra esta ayuda
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
		| awk 'BEGIN {FS = ":.*?## "}; {printf "  %-20s %s\n", $$1, $$2}'
