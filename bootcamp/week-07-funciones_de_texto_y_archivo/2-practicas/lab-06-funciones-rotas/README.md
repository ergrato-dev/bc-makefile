# Lab 06 — funciones-rotas

⏱ Duración estimada: ~60 min

## Objetivo

Identificar y corregir seis errores comunes en el uso de funciones de texto de Make.

## Contexto

Este lab simula el escenario más frecuente en la práctica: heredar un Makefile con bugs sutiles en las funciones de texto. Los errores no detienen Make con un mensaje claro — simplemente producen variables vacías o con valores incorrectos que fallan silenciosamente más adelante.

El `starter/Makefile` tiene exactamente 6 bugs. Ejecuta `make demo` en el starter y compara su salida con la salida esperada de abajo para identificarlos.

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

4. Localiza los 6 bugs en el Makefile. Cada bug está marcado con un comentario `# BUG N:`.

5. Corrige los 6 bugs en tu copia del starter (o en una copia aparte).

6. Verifica que `make demo` produce exactamente la salida esperada.

7. **Bug 5 con lupa.** Antes de corregirlo, ejecuta y compara:
   ```bash
   make -s demo | grep DEPS
   ```
   ```
   DEPS:      src/main .d src/parser .d src/utils .d (6 palabras)
   ```
   `$(words)` delata el problema aunque a simple vista parezca un espacio inofensivo. Corrígelo con `$(patsubst %.c,%.d,$(SRCS))`: además de quitar el espacio, `patsubst` solo toca el `.c` final (recuerda `src/srcmap.c` del lab-02).

8. **Bug 6 con lupa.** Los corchetes de `[$(BIN)]` hacen visibles los espacios. Hay dos arreglos válidos: mover el comentario a su propia línea, o limpiar el valor con `$(strip)`. Aplica el primero en `OUT_DIR` y comprueba con:
   ```bash
   make -s demo OUT_DIR='  out  ' | grep BIN
   ```
   que un valor con espacios que llega desde fuera (línea de comandos, entorno) **sigue** rompiendo `BIN`. Cuando el valor no lo controlas tú, `$(strip)` es la única defensa: cambia `BIN` a `$(strip $(OUT_DIR))/app` y repite el comando hasta ver `BIN:       [out/app]`.

## Los 6 bugs a encontrar

| # | Variable afectada | Síntoma | Pista |
|---|------------------|---------|-------|
| 1 | `OBJS` | Tiene extensión `.c` en vez de `.o`, o rutas incorrectas | El stem del `patsubst` no captura el directorio |
| 2 | `C_SRCS` | Vacío | `filter` necesita `%` antes de `.c` |
| 3 | `NO_UTILS` | Igual a la lista original (no filtra nada) | `filter-out` necesita `%` para coincidir con parte de la ruta |
| 4 | `INC_FLAGS` | Contiene las fuentes en vez de los directorios de include | `addprefix` se aplicó a la variable equivocada |
| 5 | `DEPS` | `src/main .d ...`: 6 palabras para 3 fuentes | El espacio tras la coma forma parte del reemplazo de `subst` |
| 6 | `BIN` | `[out    /app]` | Make conserva los espacios entre el valor y un `#` al final de la línea |

## Criterios de éxito

La salida corregida debe ser exactamente:

```
$ make demo
OBJS:      build/main.o build/parser.o build/utils.o
C_SRCS:    src/main.c src/parser.c src/utils.c
NO_UTILS:  src/main.c src/parser.c
INC_FLAGS: -Iinclude
DEPS:      src/main.d src/parser.d src/utils.d (3 palabras)
BIN:       [out/app]
```

- [ ] `make -s demo OUT_DIR='  out  '` también imprime `BIN:       [out/app]`

## Reto extra

Agrega un séptimo bug intencional: usa `$(addsuffix)` cuando en realidad necesitas `$(addprefix)`. Escribe el bug, documenta el síntoma y corrígelo.
