# Lab 05 — Portabilidad y diagnóstico

**Duración estimada:** 60 min

## Objetivo

Blindar un Makefile contra versiones de Make que no soporta y diagnosticar sus
fallos silenciosos con `--trace`, `--warn-undefined-variables`, `MAKECMDGOALS`
y `make -p`.

## Contexto

El starter genera un informe de ventas a partir de `data/*.csv` y usa un
grouped target (`&:`), que solo existe desde Make 4.3. En la 3.81 de macOS
falla con un error que no menciona la versión. Además tiene dos erratas en
nombres de variable que no rompen nada: solo producen una salida incorrecta.

Make no avisa de ninguna de las dos cosas por defecto. Vas a hacer que el
Makefile compruebe su propio entorno al leerse, y a usar las herramientas que
delatan lo que Make hace en silencio.

## Instrucciones

1. Copia el starter y genera el informe:
   ```bash
   cp -r starter/ mi-lab-05 && cd mi-lab-05
   make all
   head -1 out/summary.txt
   ```
   Salida:
   ```
   [report] out/report.csv <- 0 archivos
   [totals] out/totals.txt y out/counts.txt
   [summary] out/summary.txt
   Resumen de : 6 líneas
   ```
   El informe une dos archivos y dice `0`; el resumen no tiene nombre de
   proyecto. Anótalo: lo arreglas en el paso 4.

2. **Guarda de versión (TODO 1).** Implementa la comparación con
   `$(firstword $(sort ...))` y pruébala simulando otras versiones (una
   variable de la línea de comandos tapa a `MAKE_VERSION`):
   ```bash
   make help MAKE_VERSION=3.81     # debe fallar
   make help MAKE_VERSION=4.4.1    # debe pasar
   make help                       # tu versión real
   ```
   Ahora prueba `make help MAKE_VERSION=4.10`. Falla, aunque 4.10 sería más
   nueva: `$(sort)` ordena como texto, y `"4.10" < "4.3"`. Escribe en un
   comentario del Makefile por qué no es un problema hoy (no existe una 4.10)
   y qué harías si llegara.

   > [!NOTE]
   > **Make 4.4+.** `$(intcmp)` compara enteros y resuelve el caso 4.10:
   > ```makefile
   > VERSION_PARTS := $(subst ., ,$(MAKE_VERSION))
   > MAKE_OK := $(intcmp $(word 1,$(VERSION_PARTS)),4,,$(intcmp $(word 2,$(VERSION_PARTS)),3,,ok,ok),ok)
   > ifeq ($(MAKE_OK),)
   >   $(error Este Makefile requiere GNU Make >= 4.3 y estás usando $(MAKE_VERSION))
   > endif
   > ```
   > En 4.3 `intcmp` no existe, `MAKE_OK` queda vacía y la guarda rechaza
   > también a la 4.3. Por eso este lab usa `$(sort)`.

3. **Detección de features (TODO 2).** Mira qué anuncia tu Make:
   ```bash
   make -p -f /dev/null 2>/dev/null | grep '^.FEATURES'
   ```
   Comprueba que `grouped-target` está en `$(.FEATURES)` y, si no, detén Make
   con un mensaje que lo diga. Simula un Make que no lo tiene:
   ```bash
   make help .FEATURES=nada        # debe fallar con tu mensaje
   ```
   Preguntar por la feature que usas es más fiable que deducirla de la versión.

4. **Variables indefinidas.** Ejecuta el build con el aviso activado:
   ```bash
   make clean && make --warn-undefined-variables all
   ```
   Salen dos `warning: undefined variable` con archivo y línea. Corrige las dos
   erratas y repite hasta que no quede ningún aviso y `head -1 out/summary.txt`
   imprima `Resumen de ventas: 6 líneas`.

5. **Traza de decisiones.** Modifica un CSV y pide la traza:
   ```bash
   touch data/ventas-sur.csv
   make --trace all
   ```
   Cada target que se rehace va precedido de
   `Makefile:NN: update target '...' due to: ...`, seguido de los comandos
   que ejecuta (incluso los que llevan `@`). Responde por escrito: ¿qué línea
   del Makefile rehizo `out/totals.txt` y qué prerrequisito lo provocó? ¿Por
   qué no aparece una línea para `out/counts.txt`?

6. **Validar solo lo que se pide (TODO 3).** Usa `$(filter publish,$(MAKECMDGOALS))`
   para exigir `DEST` solo cuando se pide `publish`:
   ```bash
   make all                        # funciona sin DEST
   make publish                    # falla: publish necesita DEST: ...
   make publish DEST=/tmp/ventas   # Publicado en /tmp/ventas
   ```

7. **`doctor` y la base de datos (TODO 4).** Implementa `doctor` y ejecútalo
   con un flag para ver cómo aparece en `MAKEFLAGS`:
   ```bash
   make --warn-undefined-variables doctor
   ```
   Después usa `make -p` para averiguar de dónde sale una variable:
   ```bash
   make -p -n help 2>/dev/null | grep -B1 '^OUT_DIR '
   make -p -n help OUT_DIR=tmp 2>/dev/null | grep -B1 '^OUT_DIR '
   ```
   La línea de encima dice el origen: `# makefile (from 'Makefile', line NN)`
   en el primer caso, `# command line` en el segundo.

8. Limpia: `make clean`.

## Criterios de éxito

- [ ] `make help MAKE_VERSION=3.81` sale con error y el mensaje dice `requiere GNU Make >= 4.3` y `3.81`
- [ ] `make help MAKE_VERSION=4.4.1` muestra la ayuda
- [ ] `make help .FEATURES=nada` sale con error y el mensaje nombra los grouped targets
- [ ] `make clean && make --warn-undefined-variables all` no imprime ningún `undefined variable` y muestra `[report] out/report.csv <- 2 archivos`
- [ ] `head -1 out/summary.txt` imprime `Resumen de ventas: 6 líneas`
- [ ] `make publish` sale con error `publish necesita DEST`; `make all` sin `DEST` funciona
- [ ] `make --warn-undefined-variables doctor` imprime `MAKE_VERSION   = 4.3 (mínimo 4.3)` (o tu versión), `grouped-target = sí`, `MAKECMDGOALS   = doctor` y un `MAKEFLAGS` que contiene `--warn-undefined-variables`
- [ ] Respondiste por escrito las preguntas de los pasos 2 y 5

## Reto extra

Haz que `doctor` avise (con `$(warning)`, sin detener Make) si se ejecuta con
`-j` y la salida no está agrupada: busca `-j` y `-O` en `$(MAKEFLAGS)` con
`$(filter)`. Pruébalo con `make -j4 doctor` y `make -j4 -O doctor`.
