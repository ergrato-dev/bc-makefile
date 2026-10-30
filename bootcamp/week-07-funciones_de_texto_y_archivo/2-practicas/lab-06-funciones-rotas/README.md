# Lab 06 — funciones-rotas

**Duración estimada:** 50 minutos

## Objetivo

Identificar y corregir cuatro errores comunes en el uso de funciones de texto de Make.

## Contexto

Este lab simula el escenario más frecuente en la práctica: heredar un Makefile con bugs sutiles en las funciones de texto. Los errores no detienen Make con un mensaje claro — simplemente producen variables vacías o con valores incorrectos que fallan silenciosamente más adelante.

El `starter/Makefile` tiene exactamente 4 bugs. Ejecuta `make demo` en el starter y compara su salida con la salida esperada de abajo para identificarlos.

## Instrucciones

1. Entra al directorio starter:
   ```bash
   cd lab-06-funciones-rotas/starter
   ```

2. Ejecuta `make demo` y observa la salida incorrecta:
   ```bash
   make demo
   ```

3. Analiza cada variable línea por línea. Para cada una, pregunta:
   - ¿El resultado está vacío cuando no debería?
   - ¿El resultado tiene la forma correcta?
   - ¿El patrón de la función coincide realmente con la estructura de las palabras?

4. Localiza los 4 bugs en el Makefile. Cada bug está marcado con un comentario `# BUG N:`.

5. Corrige los 4 bugs en tu copia del starter (o en una copia aparte).

6. Verifica que `make demo` produce exactamente la salida esperada.

## Los 4 bugs a encontrar

| # | Variable afectada | Síntoma | Pista |
|---|------------------|---------|-------|
| 1 | `OBJS` | Tiene extensión `.c` en vez de `.o`, o rutas wrongas | El stem del `patsubst` no captura el directorio |
| 2 | `C_SRCS` | Vacío | `filter` necesita `%` antes de `.c` |
| 3 | `NO_UTILS` | Igual a la lista original (no filtra nada) | `filter-out` necesita `%` para coincidir con parte de la ruta |
| 4 | `INC_FLAGS` | Contiene las fuentes en vez de los directorios de include | `addprefix` se aplicó a la variable equivocada |

## Criterios de éxito

La salida corregida debe ser exactamente:

```
$ make demo
OBJS:      build/main.o build/parser.o build/utils.o
C_SRCS:    src/main.c src/parser.c src/utils.c
NO_UTILS:  src/main.c src/parser.c
INC_FLAGS: -Iinclude
```

## Reto extra

Agrega un quinto bug intencional: usa `$(addsuffix)` cuando en realidad necesitas `$(addprefix)`. Escribe el bug, documenta el síntoma y corrígelo.
