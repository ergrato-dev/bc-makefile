# Lab 03 — Salida legible con `-O`

⏱ Duración estimada: ~60 min

## Objetivo

Agrupar la salida de un build paralelo con `--output-sync` y elegir el modo adecuado para desarrollo local y para CI.

## Contexto

- Con `-j`, varias recetas escriben a la vez en la misma terminal. Las líneas se mezclan y, cuando algo falla, no sabes qué línea es de quién.
- `-O` (o `--output-sync`) hace que Make guarde la salida de cada trabajo en un archivo temporal y la imprima de golpe. Los modos: `none` (por defecto), `line` (agrupa cada línea de receta), `target` (agrupa el target entero; es lo que hace `-O` sin argumento) y `recurse` (agrupa un sub-make entero).
- El precio: no ves nada de un target hasta que termina, y las herramientas detectan que su stdout ya no es una terminal (y, por ejemplo, apagan los colores).

## Instrucciones

1. Copia el starter y ejecuta las suites en paralelo, sin sincronizar:
   ```bash
   cp -r starter/ mi-lab-03 && cd mi-lab-03
   make -j4 test
   ```
   Las líneas `[api] caso 1`, `[db] caso 1`, `[ui] caso 1` salen mezcladas.

2. Provoca un fallo y trata de leerlo:
   ```bash
   make -j4 test FAIL=db; echo "exit=$?"
   ```
   `[db] FALLÓ en el caso 3` aparece entre líneas de otras suites. Con tres suites aún se lee; con cuarenta, no.

3. Prueba `-Oline`:
   ```bash
   make -j4 -Oline test
   ```
   Los tres `caso` de cada suite salen juntos porque los imprime **una sola línea de receta** (el bucle `for`). Pero `preparando` y `OK` son otras líneas: siguen mezcladas con las demás suites.

4. Prueba `-Otarget` (equivale a `-O` a secas):
   ```bash
   make -j4 -Otarget test FAIL=db
   ```
   Cada suite sale en un bloque de `preparando` a `OK`, y el fallo de `db` aparece dentro de su bloque, justo antes del `make: *** [Makefile:NN: test-db] Error 1`.

5. Implementa el **TODO 1**: que el Makefile active la sincronización por defecto.
   ```makefile
   OUTPUT_SYNC ?= target
   MAKEFLAGS   += --output-sync=$(OUTPUT_SYNC)
   ```
   Ahora `make -j4 test` sale agrupado sin escribir `-O`, y `make -j4 test OUTPUT_SYNC=none` vuelve a la salida cruda. El orden importa: Make 4.4 interpreta `MAKEFLAGS` en el momento de la asignación. Si `OUTPUT_SYNC` se define después, 4.4 avisa con `the '-O' option requires a non-empty string argument` y la salida sale sin agrupar (4.3 no se queja, así que el bug se esconde hasta que alguien actualiza Make).

6. Compara `target` y `recurse` con la suite e2e, que es un sub-make con dos objetivos (`pago` tarda un segundo):
   ```bash
   make -j4 test OUTPUT_SYNC=target
   make -j4 test OUTPUT_SYNC=recurse
   ```
   Con `target`, el bloque de `e2e/login` sale pronto y el de `e2e/pago` al final, con las otras suites en medio: el sub-make agrupa cada uno de **sus** targets. Con `recurse`, todo el sub-make sale en un solo bloque, cuando termina.

7. Implementa el **TODO 2** y compara:
   ```bash
   make test-api
   make -j4 test-api test-db
   make -j4 test-api test-db OUTPUT_SYNC=none
   ```
   Debes ver `(stdout: terminal)`, `(stdout: archivo)` y `(stdout: terminal)`. Ese `archivo` es el motivo por el que `grep --color=auto`, `pytest` o `cargo` dejan de colorear bajo `-O`.

## Criterios de éxito

- [ ] `make -j4 test` sale agrupado por suite sin pasar `-O`
- [ ] `make -j4 test OUTPUT_SYNC=none` sale entrelazado
- [ ] `make -j4 test FAIL=db` sale distinto de 0 y `[db] FALLÓ` está dentro del bloque de `db`
- [ ] `make -j4 test OUTPUT_SYNC=recurse` imprime `e2e/login` y `e2e/pago` en el mismo bloque
- [ ] `make -j4 test-api test-db` imprime `(stdout: archivo)` y `make test-api` imprime `(stdout: terminal)`

## Reto extra

Haz que `OUTPUT_SYNC` valga `target` en CI y `none` en local sin que nadie lo pase a mano: la mayoría de sistemas de CI definen la variable de entorno `CI=true`. Usa un condicional de la semana 09 y explica en un comentario por qué en local puede interesarte ver la salida en vivo aunque se mezcle.
