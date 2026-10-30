# ============================================================
# Lab 06 — Solución: Variables automáticas rotas
# Semana 04: Variables automáticas
# ============================================================

SHELL       := bash
.SHELLFLAGS := -eu -o pipefail -c
.DELETE_ON_ERROR:

.PHONY: setup limpiar info-etiqueta enlazar construir help

.DEFAULT_GOAL := help

# ────────────────────────────────────────────────────────────
# FIX A: $@ solo tiene valor dentro de una receta.
# En asignaciones globales siempre expande a "".
# Solución: mover la construcción de ETIQUETA dentro de la receta,
# o usar el nombre del target directamente vía $@ en la receta.
# ────────────────────────────────────────────────────────────

info-etiqueta: ## muestra la etiqueta de build
	@echo "Etiqueta: build-$@"

# ────────────────────────────────────────────────────────────
# FIX B: el linker necesita TODOS los objetos ($^), no solo el primero ($<).
# Con $<, gcc solo enlaza main.o → "undefined reference" para símbolos
# definidos en utils.o y math.o.
# ────────────────────────────────────────────────────────────
enlazar: main.o utils.o math.o ## simula enlazar tres objetos
	@echo "[ld] Enlazando: $^"

# ────────────────────────────────────────────────────────────
# FIX C: usar $@ en lugar del nombre hardcodeado.
# Si el target se renombra (ej: construir-debug), $@ actualiza
# automáticamente; el nombre literal "mi-app" no.
# ────────────────────────────────────────────────────────────
construir: main.c utils.c ## simula compilar y enlazar en un solo paso
	@echo "[cc+ld] Fuentes: $^"
	@echo "[cc+ld] Binario: $@"

# ────────────────────────────────────────────────────────────
# FIX D: $* solo funciona en reglas de patrón.
# Convertir a regla de patrón: %.html: %.md
# Ahora $* = "alfa" cuando se construye alfa.html.
# ────────────────────────────────────────────────────────────
%.html: %.md
	@echo "[convert] Stem:    $*"
	@echo "[convert] Fuente:  $<"
	@echo "[convert] Destino: $@"
	@touch $@

# ────────────────────────────────────────────────────────────
# FIX E: agregar @mkdir -p $(@D) antes de usar el archivo de salida.
# $(@D) = "build"; mkdir -p no falla si el directorio ya existe.
# ────────────────────────────────────────────────────────────
build/main.o: main.c
	@mkdir -p $(@D)
	@echo "[cc] Compilando $< → $@"
	@touch $@

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
