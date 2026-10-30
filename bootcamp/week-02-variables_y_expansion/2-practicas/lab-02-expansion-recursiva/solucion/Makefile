# ============================================================
# Lab 02 — Expansión recursiva (SOLUCIÓN)
# ============================================================

.PHONY: lazy eager peligro corregido help

.DEFAULT_GOAL := help

# ── Caso 1: con = (lazy) ─────────────────────────────────────
# SALUDO_LAZY se define ANTES que DESTINATARIO_LAZY
# Con = funciona porque se evalúa en el momento de uso
SALUDO_LAZY      = Hola, $(DESTINATARIO_LAZY)!
DESTINATARIO_LAZY = Mundo

# ── Caso 2: con := (eager) ────────────────────────────────────
# SALUDO_EAGER se define ANTES que DESTINATARIO_EAGER
# Con := falla: captura string vacío porque DESTINATARIO_EAGER no existe aún
SALUDO_EAGER       := Hola, $(DESTINATARIO_EAGER)!
DESTINATARIO_EAGER := Mundo

# ── Reto extra: recursión infinita ───────────────────────────
PELIGROSO = $(PELIGROSO)-snapshot

# Versión corregida: con := el lado derecho se expande UNA vez, con el valor
# anterior de la variable, y el resultado se guarda. No queda referencia pendiente
VERSION_RELEASE := v1.0
VERSION_RELEASE := $(VERSION_RELEASE)-snapshot

lazy: ## = evalúa al usar la variable; DESTINATARIO puede definirse después
	@echo "SALUDO_LAZY: $(SALUDO_LAZY)"

eager: ## := evalúa al asignar; DESTINATARIO estaba vacío en ese momento
	@echo "SALUDO_EAGER: $(SALUDO_EAGER)"

peligro: ## demuestra el error de recursión infinita con =
	@echo "Intentando expandir PELIGROSO..."
	@echo "$(PELIGROSO)"

corregido: ## muestra VERSION_RELEASE sin recursión
	@echo "VERSION_RELEASE: $(VERSION_RELEASE)"

help: ## muestra esta ayuda
	@echo "Uso: make [lazy|eager|peligro|corregido]"
	@grep -hE '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
		| awk 'BEGIN {FS = ":.*?## "}; {printf "  %-20s %s\n", $$1, $$2}'
