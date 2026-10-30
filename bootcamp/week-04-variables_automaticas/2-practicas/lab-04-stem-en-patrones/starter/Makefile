# ============================================================
# Lab 04 — Variable automática $*
# Semana 04: Variables automáticas
# ============================================================
# SECUENCIA RECOMENDADA:
#   1. make setup           → crea archivos .entrada de prueba
#   2. make alfa.resultado  → verifica el stem en un caso individual
#   3. make all             → construye todos los .resultado
#   4. touch beta.entrada   → simula modificación
#   5. make all             → solo beta.resultado se reconstruye
#   6. make limpiar         → elimina .resultado generados
# ============================================================

.PHONY: all setup limpiar help

.DEFAULT_GOAL := help

# ── Archivos de entrada y salida ──────────────────────────────
ENTRADAS := alfa.entrada beta.entrada gamma.entrada
SALIDAS  := $(ENTRADAS:.entrada=.resultado)

all: $(SALIDAS) ## procesa todos los archivos .entrada → .resultado

# ── Regla de patrón ───────────────────────────────────────────
# El % en %.resultado coincide con: alfa, beta, gamma
# $* = el stem (la parte que coincidió con %)
%.resultado: %.entrada
	# TODO: imprime "[proceso] Stem:    $*"
	# TODO: imprime "[proceso] Entrada: $<"
	# TODO: imprime "[proceso] Salida:  $@"
	# TODO: copia la entrada a la salida: @cp $< $@
	# TODO (paso 7): crea logs/ con mkdir -p y escribe en logs/$(*F).log
	#       la línea "<stem> procesado desde <entrada>" usando $* y $<

# ── Targets de utilidad ───────────────────────────────────────

setup: ## crea archivos .entrada de prueba
	@echo "datos de alfa"  > alfa.entrada
	@echo "datos de beta"  > beta.entrada
	@echo "datos de gamma" > gamma.entrada
	@mkdir -p sub
	@echo "datos de delta" > sub/delta.entrada
	@echo "[setup] Archivos creados: $(ENTRADAS)"

limpiar: ## elimina los archivos generados
	# TODO: elimina todos los archivos .resultado y .entrada
	# TODO (paso 7): elimina también los directorios logs y sub (rm -rf -- logs sub)
	@echo "[limpiar] Listo."

help: ## muestra esta ayuda
	@echo "Uso: make [target | <nombre>.resultado]"
	@grep -hE '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
		| awk 'BEGIN {FS = ":.*?## "}; {printf "  %-20s %s\n", $$1, $$2}'
