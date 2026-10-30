# ============================================================
# Lab 02 — Expansión recursiva
# Semana 02: Variables y Expansión en Make
# ============================================================
# Objetivo: observar que = evalúa en el momento de uso, no de definición
# Compara los outputs de `make lazy` y `make eager`
# ============================================================

.PHONY: lazy eager peligro corregido help

.DEFAULT_GOAL := help

# ── Caso 1: con = (lazy) ─────────────────────────────────────
# TODO: define SALUDO_LAZY con = (NO :=) referenciando $(DESTINATARIO_LAZY)
# SALUDO_LAZY = ...

# TODO: define DESTINATARIO_LAZY con = y valor "Mundo"
#       (está definido DESPUÉS que SALUDO_LAZY — con = eso está bien)
# DESTINATARIO_LAZY = ...

# ── Caso 2: con := (eager) ────────────────────────────────────
# TODO: define SALUDO_EAGER con := referenciando $(DESTINATARIO_EAGER)
#       ATENCIÓN: DESTINATARIO_EAGER se define MÁS ADELANTE en este archivo
# SALUDO_EAGER := ...

# TODO: define DESTINATARIO_EAGER con := y valor "Mundo"
# DESTINATARIO_EAGER := ...

# ── Recursión infinita (pasos 8-10; ¡no ejecutes sin leer el README!) ──
# Esta variable hace referencia a sí misma con =
# GNU Make detecta la recursión y falla con un error claro
PELIGROSO = $(PELIGROSO)-snapshot

# TODO (paso 10): define VERSION_RELEASE en dos líneas, las dos con :=
#   primera:  valor "v1.0"
#   segunda:  VERSION_RELEASE := <valor anterior de VERSION_RELEASE>-snapshot

lazy: ## = evalúa al usar la variable, DESTINATARIO puede definirse después
	# TODO: @echo "SALUDO_LAZY: $(SALUDO_LAZY)"

eager: ## := evalúa al asignar; DESTINATARIO estaba vacío en ese momento
	# TODO: @echo "SALUDO_EAGER: $(SALUDO_EAGER)"

peligro: ## demuestra el error de recursión infinita con =
	@echo "Intentando expandir PELIGROSO..."
	@echo "$(PELIGROSO)"

corregido: ## muestra VERSION_RELEASE sin recursión
	@echo "VERSION_RELEASE: $(VERSION_RELEASE)"

help: ## muestra esta ayuda
	@echo "Uso: make [lazy|eager|peligro|corregido]"
	@grep -hE '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
		| awk 'BEGIN {FS = ":.*?## "}; {printf "  %-20s %s\n", $$1, $$2}'
