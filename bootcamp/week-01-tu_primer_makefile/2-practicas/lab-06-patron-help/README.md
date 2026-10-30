# Lab 06 — El patrón help estándar

⏱ Duración estimada: ~60 min

## Objetivo

Implementar el patrón `help` con documentación inline usando `grep` y `awk`, para que cualquier Makefile sea autodocumentado.

## Contexto

Un Makefile sin `help` es una caja negra. El patrón estándar usa comentarios `##` en la misma línea del target para generar ayuda automática. Así el Makefile se documenta a sí mismo: cambian los targets, cambia la ayuda.

```makefile
## build: compila el proyecto       ← este comentario aparece en `make help`
build:
	...
```

El truco: `grep -E '^## '` extrae esas líneas, `awk` las formatea.

## Instrucciones

1. Abre `starter/Makefile`. Tiene 5 targets sin documentación `##`.

2. Agrega comentarios `## target: descripción` a cada target (ver TODO).

3. Implementa el target `help` completo usando el patrón grep+awk:
   ```makefile
   help:
   	@grep -E '^## ' $(MAKEFILE_LIST) \
   		| awk 'BEGIN {FS = ": "}; {printf "  %-20s %s\n", $$1, $$2}' \
   		| sed 's/## //'
   ```

4. Verifica:
   ```bash
   make help
   ```
   Debes ver los 5 targets listados con su descripción, alineados en columnas.

5. Agrega un target nuevo (`status`) con su comentario `##`. Ejecuta `make help` — el nuevo target aparece automáticamente sin tocar la receta de `help`.

6. Prueba `make help` con una descripción larga (más de 40 caracteres). ¿Se rompe el alineado? Ajusta el `%-20s` a `%-30s` si necesitas más espacio.

7. **Por qué `$(MAKEFILE_LIST)` y no `Makefile`.** Copia el Makefile y añade un
   target que solo exista en la copia:
   ```bash
   cp Makefile otro.mk
   printf '\n## deploy: despliega (solo en otro.mk)\ndeploy:\n\t@echo deploy\n' >> otro.mk
   make -f otro.mk help
   ```
   La última línea debe ser `deploy            despliega (solo en otro.mk)`:
   `$(MAKEFILE_LIST)` contiene el archivo que Make leyó de verdad. Ahora, solo
   en `otro.mk`, cambia `$(MAKEFILE_LIST)` por `Makefile` en la receta de
   `help` y repite `make -f otro.mk help`: `deploy` desaparece, porque `grep`
   está leyendo el archivo equivocado. Borra la copia con `rm otro.mk`.

8. Comprueba que la ayuda es lo que sale por defecto:
   ```bash
   make
   ```
   Debe imprimir la misma tabla que `make help`, gracias a
   `.DEFAULT_GOAL := help`.

## Criterios de éxito

- [ ] `make help` lista todos los targets con descripción en dos columnas alineadas
- [ ] Agregar un nuevo target con `##` lo incluye automáticamente en `make help`
- [ ] El patrón usa `$(MAKEFILE_LIST)` (no el nombre literal del Makefile)
- [ ] `make -f otro.mk help` muestra `deploy`; con `Makefile` literal, no
- [ ] `make help` es el target por defecto (`make` sin args lo ejecuta)

## Reto extra

Hay una segunda convención muy extendida, la que usa este bootcamp
desde la semana 07: la descripción va **en la misma línea** que el target.

```makefile
build: ## construye el proyecto en output/
	@echo "Construyendo..."

help: ## muestra esta ayuda
	@echo "Targets disponibles:"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
		| awk 'BEGIN {FS = ":.*?## "}; {printf "  %-20s %s\n", $$1, $$2}'
```

Reescribe tu Makefile con esta convención en un archivo `inline.mk` y
compruébalo con `make -f inline.mk help`. ¿Qué ventaja tiene que la descripción
viva en la línea del target? ¿Qué pasa con un target como `build: test lint ## ...`?
