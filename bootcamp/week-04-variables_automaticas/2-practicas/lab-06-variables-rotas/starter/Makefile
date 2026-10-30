# ============================================================
# Lab 06 — Variables automáticas rotas (5 bugs)
# Semana 04: Variables automáticas
# ============================================================
# Encuentra y corrige los 5 bugs marcados con "# BUG:".
# Escribe "# FIX:" debajo de cada bug con la corrección y el motivo.
# ============================================================

.PHONY: setup limpiar info-etiqueta enlazar construir help

.DEFAULT_GOAL := help

# ────────────────────────────────────────────────────────────
# BUG A: $@ usado fuera de una receta — siempre expande a ""
# ────────────────────────────────────────────────────────────
ETIQUETA := build-$@
# FIX: ...

info-etiqueta: ## muestra la etiqueta de build
	@echo "Etiqueta: $(ETIQUETA)"

# ────────────────────────────────────────────────────────────
# BUG B: linker usa $< en lugar de $^ → solo enlaza main.o
# ────────────────────────────────────────────────────────────
enlazar: main.o utils.o math.o ## simula enlazar tres objetos
	@echo "[ld] Enlazando: $<"
# FIX: ...

# ────────────────────────────────────────────────────────────
# BUG C: nombre del binario hardcodeado en vez de $@
# ────────────────────────────────────────────────────────────
construir: main.c utils.c ## simula compilar y enlazar en un solo paso
	@echo "[cc+ld] Fuentes: $^"
	@echo "[cc+ld] Binario: mi-app"
# FIX: ...

# ────────────────────────────────────────────────────────────
# BUG D: $* en regla explícita — siempre expande a ""
# ────────────────────────────────────────────────────────────
# Esta es una regla EXPLÍCITA, no de patrón. $* no tiene valor aquí.
alfa.html: alfa.md
	@echo "[convert] Stem: $*"
	@echo "[convert] Fuente: $<"
	@echo "[convert] Destino: $@"
	@touch $@
# FIX: ...

# ────────────────────────────────────────────────────────────
# BUG E: $(@D) sin mkdir -p → falla si build/ no existe
# ────────────────────────────────────────────────────────────
build/main.o: main.c
	@echo "[cc] Compilando $< → $@"
	@touch $@
# FIX: ...

setup: ## crea los archivos de prueba que usan los targets
	@touch main.c utils.c alfa.md
	@touch main.o utils.o math.o
	@echo "[setup] Listo: main.c utils.c alfa.md main.o utils.o math.o"

limpiar: ## borra los archivos de prueba y build/
	@rm -f main.c utils.c alfa.md alfa.html main.o utils.o math.o
	@rm -rf -- build
	@echo "[limpiar] Listo."

help: ## muestra esta ayuda
	@echo "Uso: make [target]"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
		| awk 'BEGIN {FS = ":.*?## "}; {printf "  %-20s %s\n", $$1, $$2}'
