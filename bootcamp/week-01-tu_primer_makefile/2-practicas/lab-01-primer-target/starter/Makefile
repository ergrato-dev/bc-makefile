# ============================================================
# Lab 01 — Tu primer target
# Semana 01: Tu primer Makefile
# ============================================================
# Instrucciones:
#   1. Lee cada TODO y completa la implementación
#   2. Ejecuta `make help` para ver los targets disponibles
#   3. Verifica con `make saludar` y luego `make info`
# ============================================================

.PHONY: saludar info check-make donde help

.DEFAULT_GOAL := help

# TODO (paso 3): agrega un @echo que imprima exactamente: Hola desde Make!
## saludar: imprime un saludo en pantalla
saludar:
	@echo "TODO: implementa saludar"

# TODO (paso 4): imprime tres líneas con este formato:
#   Fecha:       <resultado de $(shell date)>
#   Usuario:     <resultado de $(shell whoami)>
#   Directorio:  <resultado de $(shell pwd)>
## info: muestra información del sistema
info:
	@echo "TODO: implementa info"

# TODO (paso 6): imprime "Usando GNU Make $(MAKE_VERSION)" y después comprueba
# la versión con esta línea (cópiala tal cual, con TAB delante):
#   @printf '%s\n' 4.3 $(MAKE_VERSION) | sort -V -C || (echo "Error: necesitas GNU Make >= 4.3" && exit 1)
# Si pasa, imprime "Versión OK."
## check-make: falla si GNU Make es anterior a 4.3
check-make:
	@echo "TODO: implementa check-make"

# TODO (paso 7): escribe tres líneas de receta, cada una con @:
#   cd /tmp
#   pwd
#   cd /tmp && pwd
# y explica por qué la primera pwd NO imprime /tmp.
## donde: demuestra que cada línea de receta usa su propia shell
donde:
	@echo "TODO: implementa donde"

## help: muestra esta ayuda
help:
	@echo "Targets disponibles:"
	@grep -E '^## ' $(MAKEFILE_LIST) \
		| awk 'BEGIN {FS = ": "}; {printf "  %-20s %s\n", $$1, $$2}' \
		| sed 's/## //'
