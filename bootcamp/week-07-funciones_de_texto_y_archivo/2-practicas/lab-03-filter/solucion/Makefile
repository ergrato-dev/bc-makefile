SHELL       := bash
.SHELLFLAGS := -eu -o pipefail -c
.DELETE_ON_ERROR:

.PHONY: demo help
.DEFAULT_GOAL := help

ALL_FILES := src/main.c src/utils.c include/utils.h include/types.h \
             build/main.o build/utils.o docs/README.md docs/API.md

C_SRCS      := $(filter %.c,$(ALL_FILES))
HEADERS     := $(filter %.h,$(ALL_FILES))
OBJECTS     := $(filter %.o,$(ALL_FILES))
NO_DOCS     := $(filter-out docs/%,$(ALL_FILES))
SRC_AND_INC := $(filter src/% include/%,$(ALL_FILES))

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
