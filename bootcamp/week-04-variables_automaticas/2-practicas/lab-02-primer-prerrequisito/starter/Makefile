# ============================================================
# Lab 02 — Variable automática $<
# Semana 04: Variables automáticas
# ============================================================
# Los prerrequisitos no necesitan existir para este lab:
# Make evalúa $< y $^ con los nombres de la lista, no los archivos.
# ============================================================

.PHONY: compilar-main compilar-utils enlazar help

.DEFAULT_GOAL := help

# ── Targets de compilación (simulados con echo) ───────────────

## compilar-main: simula compilar main.c con sus headers como dependencias
compilar-main: src/main.c include/utils.h include/math.h
	# TODO: imprime "[cc] Compilando (solo fuente): $<"
	# Observa: $< es src/main.c, aunque hay tres prerrequisitos
	# TODO: imprime "[cc] Todos los prereqs:        $^"
	# Observa: $^ incluye los tres: fuente + headers

## compilar-utils: simula compilar utils.c
compilar-utils: src/utils.c include/utils.h
	# TODO: imprime "[cc] Compilando (solo fuente): $<"
	# TODO: imprime "[cc] Todos los prereqs:        $^"

## enlazar: simula enlazar objetos — aquí $< es incorrecto
enlazar: main.o utils.o math.o
	# TODO: imprime "[ld] Primer objeto (incorrecto para linker): $<"
	# Nota: $< = main.o solamente. Un linker necesita TODOS los objetos.
	# TODO: imprime "[ld] TODOS los objetos (correcto):           $^"
	# Reflexiona: ¿qué error daría gcc si usara $< aquí en producción?
	# TODO: agrega un comentario con la respuesta

## help: muestra esta ayuda
help:
	@echo "Uso: make [target]"
	@grep -E '^## ' $(MAKEFILE_LIST) \
		| awk 'BEGIN {FS = ": "}; {printf "  %-20s %s\n", $$1, $$2}' \
		| sed 's/## //'
