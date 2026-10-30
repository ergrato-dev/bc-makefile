# ============================================================
# Lab 03 — Expansión inmediata: capturar valores de shell (SOLUCIÓN)
# ============================================================

.PHONY: comparar git-info asignar-shell help

.DEFAULT_GOAL := help

# ── Timestamps ───────────────────────────────────────────────
TIMESTAMP_LAZY   = $(shell date +%T)
TIMESTAMP_EAGER := $(shell date +%T)

# ── Información de git ────────────────────────────────────────
GIT_HASH := $(shell git rev-parse --short HEAD 2>/dev/null || echo "no-git")
VERSION  := 0.1.0-$(GIT_HASH)

# ── Asignación con la shell (!=) ──────────────────────────────
# != ejecuta el comando una vez, al leer la línea, pero guarda el resultado
# en una variable recursiva: un $ en la salida se expandirá al usarla
KERNEL       != uname -s
PRECIO_BANG  != echo 'cuesta $$5'
PRECIO_SHELL := $(shell echo 'cuesta $$5')

## comparar: imprime cada timestamp dos veces para ver si cambia
comparar:
	@echo "--- Con = (lazy, el shell se invoca en cada uso) ---"
	@echo "  Primera lectura:  $(TIMESTAMP_LAZY)"
	@echo "  Segunda lectura:  $(TIMESTAMP_LAZY)"
	@echo "--- Con := (eager, capturado una vez al cargar el Makefile) ---"
	@echo "  Primera lectura:  $(TIMESTAMP_EAGER)"
	@echo "  Segunda lectura:  $(TIMESTAMP_EAGER)"

## git-info: imprime hash de git y versión del proyecto
git-info:
	@echo "Git hash: $(GIT_HASH)"
	@echo "Versión:  $(VERSION)"

## asignar-shell: compara != con := $(shell ...)
asignar-shell:
	@echo 'KERNEL:       $(KERNEL) [$(flavor KERNEL)]'
	@echo 'PRECIO_BANG:  $(PRECIO_BANG) [$(flavor PRECIO_BANG)]'
	@echo 'PRECIO_SHELL: $(PRECIO_SHELL) [$(flavor PRECIO_SHELL)]'

## help: muestra esta ayuda
help:
	@echo "Uso: make [comparar|git-info|asignar-shell]"
	@grep -E '^## ' $(MAKEFILE_LIST) \
		| awk 'BEGIN {FS = ": "}; {printf "  %-20s %s\n", $$1, $$2}' \
		| sed 's/## //'
