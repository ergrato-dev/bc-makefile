# Lab 06 — El patrón help estándar

⏱ Duración estimada: ~50 min

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

## Criterios de éxito

- [ ] `make help` lista todos los targets con descripción en dos columnas alineadas
- [ ] Agregar un nuevo target con `##` lo incluye automáticamente en `make help`
- [ ] El patrón usa `$(MAKEFILE_LIST)` (no el nombre literal del Makefile)
- [ ] `make help` es el target por defecto (`make` sin args lo ejecuta)

## Reto extra

Agrega colores al output de `help` usando códigos ANSI:
```makefile
BOLD  := \033[1m
RESET := \033[0m
```
Imprime el nombre del target en negrita y la descripción en color normal.
