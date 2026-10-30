.PHONY: demo help
.DEFAULT_GOAL := help

ARCHIVOS := src/main.c src/utils/io.c include/utils.h build/obj/main.o

# TODO: Extrae la parte directorio de cada archivo (con / final)
DIRECTORIOS :=

# TODO: Extrae solo el nombre sin directorio
NOMBRES :=

# TODO: Extrae la ruta sin extensión
BASES :=

# TODO: Extrae solo la extensión
EXTENSIONES :=

# TODO: Genera flags -I para cada directorio único
# Tip: $(addprefix -I,$(sort $(dir $(ARCHIVOS))))
INCLUDE_FLAGS :=

# TODO: Agrega .bak como sufijo a cada nombre de archivo (sin directorio)
# Tip: primero $(notdir ...), luego $(addsuffix ...)
BACKUPS :=

demo: ## Muestra las manipulaciones de ruta
	@echo "Archivos:     $(ARCHIVOS)"
	@echo "Directorios:  $(DIRECTORIOS)"
	@echo "Nombres:      $(NOMBRES)"
	@echo "Bases:        $(BASES)"
	@echo "Extensiones:  $(EXTENSIONES)"
	@echo "-I flags:     $(INCLUDE_FLAGS)"
	@echo "Backups:      $(BACKUPS)"

help: ## Muestra esta ayuda
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
		| awk 'BEGIN {FS = ":.*?## "}; {printf "  %-20s %s\n", $$1, $$2}'
