# ============================================================
# Lab 04 — .DELETE_ON_ERROR y qué hace Make cuando una receta falla (SOLUCIÓN)
# Semana 03: Shell en recetas y modo estricto
# ============================================================

SHELL       := bash
.SHELLFLAGS := -eu -o pipefail -c
# Si la receta de un target-archivo falla, Make borra ese archivo. Sin esto,
# el archivo a medias queda con fecha nueva y la siguiente ejecución lo da por
# bueno ("Nothing to be done"). No afecta a targets .PHONY: no son archivos.
.DELETE_ON_ERROR:

.PHONY: report catalog stock slow clean help
.DEFAULT_GOAL := help

DATA      := data/productos.csv
BUILD_DIR := build
AWK       := awk

CATALOG   := $(BUILD_DIR)/catalog.txt
STOCK     := $(BUILD_DIR)/stock.txt
SLOW      := $(BUILD_DIR)/slow.txt

report: catalog stock ## Genera catálogo y stock

catalog: $(CATALOG) ## Catálogo con nombre y precio

stock: $(STOCK) ## Total de unidades en stock

# awk escribe línea a línea en $@: si encuentra un precio no numérico, sale
# con 1 y deja en el archivo todo lo que escribió hasta ese momento.
# Nunca - delante de un comando que produce el target: el error se ignora,
# .DELETE_ON_ERROR no actúa y el archivo roto sobrevive.
$(CATALOG): $(DATA)
	mkdir -p $(BUILD_DIR)
	$(AWK) -F, '$$3 !~ /^[0-9]+$$/ { print "precio inválido en la línea " NR > "/dev/stderr"; exit 1 } { printf "%-12s %4d EUR\n", $$2, $$3 }' $(DATA) > $@

$(STOCK): $(DATA)
	mkdir -p $(BUILD_DIR)
	$(AWK) -F, '{ total += $$4 } END { print "unidades en stock: " total }' $(DATA) > $@

# Ctrl-C borra el target a medias incluso sin .DELETE_ON_ERROR: la
# interrupción es la única situación en la que Make lo hace por defecto.
slow: $(SLOW) ## Target lento para probar Ctrl-C

$(SLOW):
	mkdir -p $(BUILD_DIR)
	echo "inicio" > $@
	sleep 10
	echo "fin" >> $@

clean: ## Borra build/
	$(if $(BUILD_DIR),,$(error BUILD_DIR vacía: rm -rf no se ejecuta))
	rm -rf -- '$(BUILD_DIR)'

help: ## Muestra los targets disponibles
	@echo "Targets disponibles:"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
		| awk 'BEGIN {FS = ":.*?## "}; {printf "  %-20s %s\n", $$1, $$2}'
