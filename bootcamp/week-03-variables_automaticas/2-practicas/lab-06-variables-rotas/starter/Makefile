# ============================================================
# Lab 06 — Variables automáticas rotas (5 bugs)
# Semana 03: Variables automáticas
# ============================================================
# Encuentra y corrige los 5 bugs marcados con "# BUG:".
# Escribe "# FIX:" debajo de cada bug con la corrección y el motivo.
# ============================================================

.PHONY: info-etiqueta enlazar construir help

.DEFAULT_GOAL := help

# ────────────────────────────────────────────────────────────
# BUG A: $@ usado fuera de una receta — siempre expande a ""
# ────────────────────────────────────────────────────────────
ETIQUETA := build-$@
# FIX: ...

## info-etiqueta: muestra la etiqueta de build
info-etiqueta:
	@echo "Etiqueta: $(ETIQUETA)"

# ────────────────────────────────────────────────────────────
# BUG B: linker usa $< en lugar de $^ → solo enlaza main.o
# ────────────────────────────────────────────────────────────
## enlazar: simula enlazar tres objetos
enlazar: main.o utils.o math.o
	@echo "[ld] Enlazando: $<"
# FIX: ...

# ────────────────────────────────────────────────────────────
# BUG C: nombre del binario hardcodeado en vez de $@
# ────────────────────────────────────────────────────────────
## construir: simula compilar y enlazar en un solo paso
construir: main.c utils.c
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

## help: muestra esta ayuda
help:
	@echo "Uso: make [target]"
	@grep -E '^## ' $(MAKEFILE_LIST) \
		| awk 'BEGIN {FS = ": "}; {printf "  %-20s %s\n", $$1, $$2}' \
		| sed 's/## //'
