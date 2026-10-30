.PHONY: all-bugs setup clean help

.DEFAULT_GOAL := help

setup:
	@echo "datos de prueba" > bug-1.raw
	@echo "datos de prueba" > bug-2.raw
	@echo "datos de prueba" > bug-3.raw
	@echo "datos de prueba" > bug-5.raw
	@echo "[setup] archivos .raw creados"

## all-bugs: ejecuta todos los bugs corregidos
all-bugs: setup bug-1 bug-2 bug-3 bug-4 bug-5
	@echo "[ok] todos los bugs corregidos"

# FIX 1: espacios → TABs en la receta
%.out-1: %.raw
	@cp $< $@
	@echo "[ok] $@ generado"

bug-1: bug-1.out-1

# FIX 2: target y prerrequisito en el orden correcto
%.out-2: %.raw
	@cp $< $@
	@echo "[ok] $@ generado"

bug-2: bug-2.out-2

# FIX 3: $@ en lugar de $$@
%.out-3: %.raw
	@echo "[ok] $@ generado"

bug-3: bug-3.out-3

# FIX 4: mkdir -p $(@D) antes de copiar
out/%.out-4: %.raw
	@mkdir -p $(@D)
	@cp $< $@
	@echo "[ok] $@ generado"

bug-4: bug-4.raw out/bug-4.out-4

# FIX 5: prerrequisito con % para que el patrón pueda coincidir
%.out-5: %.raw
	@cp $< $@
	@echo "[ok] $@ generado"

bug-5: bug-5.out-5

## clean: elimina archivos generados
clean:
	@rm -f *.raw *.out-1 *.out-2 *.out-3 *.out-5
	@rm -rf out
	@echo "[clean] listo"

## help: muestra esta ayuda
help:
	@echo "Uso: make [target]"
	@echo ""
	@echo "  make setup      crea los .raw de prueba"
	@echo "  make bug-N      prueba el bug N (1-5)"
	@echo "  make all-bugs   ejecuta todos tras las correcciones"
	@echo "  make clean      elimina archivos generados"
