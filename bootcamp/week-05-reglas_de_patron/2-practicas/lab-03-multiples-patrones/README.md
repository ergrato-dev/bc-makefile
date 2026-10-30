# Lab 03 — Múltiples reglas de patrón para distintas extensiones

⏱ Duración estimada: ~60 min

## Objetivo

Combinar varias reglas de patrón en un Makefile y predecir cuál elige Make según la extensión pedida, los prerrequisitos que existen y el orden del archivo.

## Contexto

Un Makefile puede tener tantas reglas de patrón como necesite. Para cada target, Make considera solo las que casan con su nombre **y** cuyo prerrequisito existe o se puede construir. Si dos casan con el mismo stem, gana la primera del archivo.

Si ninguna regla tiene el prerrequisito a mano, Make puede **encadenar** patrones (`.raw → .processed → .summary`). El archivo del medio es *intermedio*: si el Makefile no lo menciona, Make lo borra al terminar.

## Instrucciones

1. Entra en `starter/` y crea los datos de prueba:
   ```bash
   make setup && ls *.raw
   ```
   ```
   [setup] alpha.raw creado
   [setup] beta.raw creado
   [setup] gamma.raw creado
   alpha.raw  beta.raw  gamma.raw
   ```

2. Ejecuta `make process` antes de escribir nada y lee el error:
   ```
   make: *** No rule to make target 'alpha.processed', needed by 'process'.  Stop.
   ```

3. Escribe la regla de patrón para `.processed`:
   ```makefile
   %.processed: %.raw
   	@cp $< $@
   	@echo "[raw→processed] $@"
   ```

4. Escribe la regla de patrón para `.backup` (`@cp $< $@` y `@echo "[backup] $@"`).

5. Verifica las dos reglas y que la segunda pasada no rehace nada:
   ```bash
   make process && make backup && make process
   ```
   ```
   [raw→processed] alpha.processed
   [raw→processed] beta.processed
   [raw→processed] gamma.processed
   [backup] alpha.backup
   [backup] beta.backup
   [backup] gamma.backup
   make: Nothing to be done for 'process'.
   ```

6. Una regla de patrón sirve para un target aislado: `rm -f alpha.processed && make alpha.processed` imprime solo `[raw→processed] alpha.processed`.

7. Mismo target, otro prerrequisito. Añade **después** de las anteriores:
   ```makefile
   %.processed: %.txt
   	@tr '[:lower:]' '[:upper:]' < $< > $@
   	@echo "[txt→processed] $@"
   ```
   ```bash
   printf 'delta\n' > delta.txt && make delta.processed && cat delta.processed
   ```
   ```
   [txt→processed] delta.processed
   DELTA
   ```
   No existe `delta.raw`, así que la primera regla se descarta y Make usa la segunda.

8. ¿Y si existen los dos prerrequisitos? Crea `alpha.txt` y fuerza la reconstrucción:
   ```bash
   printf 'otro\n' > alpha.txt && make -B alpha.processed
   ```
   ```
   [raw→processed] alpha.processed
   ```
   Las dos reglas casan con el mismo stem (`alpha`); gana la que aparece primero en el Makefile. Cambia el orden de las dos reglas `.processed`, repite y anota qué sale. Deja el orden original.

9. Encadenamiento. Añade una regla que cuente líneas a partir de un `.processed`:
   ```makefile
   %.summary: %.processed
   	@wc -l < $< > $@
   	@echo "[summary] $@ ($$(cat $@) líneas)"
   ```
   ```bash
   printf 'uno\ndos\n' > zeta.raw && make zeta.summary && ls zeta*
   ```
   ```
   [raw→processed] zeta.processed
   [summary] zeta.summary (2 líneas)
   rm zeta.processed
   zeta.raw
   zeta.summary
   ```
   Make construyó `zeta.processed` con la primera regla, lo usó y lo borró porque es intermedio. Repite con `rm -f gamma.processed && make gamma.summary`: esta vez `gamma.processed` **no** se borra, porque el Makefile lo menciona en `PROC`. (En la semana 06 controlarás esto con `.SECONDARY` y `.PRECIOUS`.)

## Criterios de éxito

- [ ] `make process` crea los tres `.processed` y `make backup` los tres `.backup`, sin reglas explícitas por archivo
- [ ] `make delta.processed` imprime `[txt→processed] delta.processed` y el archivo contiene `DELTA`
- [ ] Con `alpha.raw` y `alpha.txt` presentes, `make -B alpha.processed` usa la regla escrita primero
- [ ] `make zeta.summary` imprime `rm zeta.processed` al final y deja `zeta.summary` con `2`
- [ ] `make clean` elimina todos los archivos generados

## Reto extra

Añade un target `report` que dependa de `$(STEMS:%=%.summary)` e imprima cada resumen con su nombre. Ejecútalo desde cero (`make clean && make setup && make report`) y explica por qué ninguno de los `.processed` se borra.
