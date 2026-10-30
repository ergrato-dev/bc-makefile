.PHONY: demo help
.DEFAULT_GOAL := help

ALL_FILES := src/main.c src/utils.c include/utils.h include/types.h \
             build/main.o build/utils.o docs/README.md docs/API.md

# TODO: Conserva solo archivos .c
C_SRCS :=

# TODO: Conserva solo archivos .h
HEADERS :=

# TODO: Conserva solo archivos .o
OBJECTS :=

# TODO: Elimina todo lo que esté en docs/ usando filter-out con patrón docs/%
NO_DOCS :=

# TODO: Conserva solo archivos en src/ e include/ usando dos patrones en un $(filter)
SRC_AND_INC :=

demo: ## Muestra el resultado de los filtros
	@echo "Todos:      $(ALL_FILES)"
	@echo ".c:         $(C_SRCS)"
	@echo ".h:         $(HEADERS)"
	@echo ".o:         $(OBJECTS)"
	@echo "Sin docs:   $(NO_DOCS)"
	@echo "src+inc:    $(SRC_AND_INC)"

help: ## Muestra esta ayuda
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
		| awk 'BEGIN {FS = ":.*?## "}; {printf "  %-20s %s\n", $$1, $$2}'
