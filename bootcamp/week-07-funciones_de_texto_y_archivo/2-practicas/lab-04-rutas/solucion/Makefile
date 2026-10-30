.PHONY: demo help
.DEFAULT_GOAL := help

ARCHIVOS := src/main.c src/utils/io.c include/utils.h build/obj/main.o

DIRECTORIOS   := $(dir $(ARCHIVOS))
NOMBRES       := $(notdir $(ARCHIVOS))
BASES         := $(basename $(ARCHIVOS))
EXTENSIONES   := $(suffix $(ARCHIVOS))
INCLUDE_FLAGS := $(addprefix -I,$(sort $(dir $(ARCHIVOS))))
BACKUPS       := $(addsuffix .bak,$(notdir $(ARCHIVOS)))
STEMS         := $(notdir $(basename $(ARCHIVOS)))

demo: ## Muestra las manipulaciones de ruta
	@echo "Archivos:     $(ARCHIVOS)"
	@echo "Directorios:  $(DIRECTORIOS)"
	@echo "Nombres:      $(NOMBRES)"
	@echo "Bases:        $(BASES)"
	@echo "Extensiones:  $(EXTENSIONES)"
	@echo "-I flags:     $(INCLUDE_FLAGS)"
	@echo "Backups:      $(BACKUPS)"
	@echo "Stems:        $(STEMS)"

help: ## Muestra esta ayuda
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
		| awk 'BEGIN {FS = ":.*?## "}; {printf "  %-20s %s\n", $$1, $$2}'
