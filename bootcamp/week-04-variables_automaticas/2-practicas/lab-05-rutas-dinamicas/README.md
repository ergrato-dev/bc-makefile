# Lab 05 — `$(@D)` y `$(@F)`: construir rutas de salida dinámicas

⏱ Duración estimada: ~60 min

## Objetivo

Usar `$(@D)` y `$(@F)` para construir archivos en subdirectorios sin hardcodear rutas en las recetas, creando el directorio destino dinámicamente con `mkdir -p $(@D)`.

## Contexto

Cuando un target tiene una ruta con subdirectorios (`dist/reportes/informe-q1.txt`), las recetas necesitan crear el directorio antes de escribir el archivo. Hardcodear `mkdir -p dist/reportes` funciona pero se rompe si cambias la estructura de directorios.

Las variables de directorio y archivo resuelven esto:

| Variable | Para `dist/reportes/informe-q1.txt` | Para `build/main.o` |
|----------|-------------------------------------|---------------------|
| `$(@D)` | `dist/reportes` | `build` |
| `$(@F)` | `informe-q1.txt` | `main.o` |
| `$(<D)` | directorio de `$<` | directorio de `$<` |
| `$(<F)` | nombre de archivo de `$<` | nombre de archivo de `$<` |

Con `mkdir -p $(@D)`, la receta crea el directorio correcto sin importar cuántos niveles tenga la ruta.

## Instrucciones

1. Abre `starter/Makefile`. El target `all` depende de tres artefactos en subdirectorios distintos.

2. Completa la regla `$(DIST)/reportes/%.txt:`:
   ```makefile
   $(DIST)/reportes/%.txt:
   	@mkdir -p $(@D)
   	@echo "[gen] Directorio: $(@D)"
   	@echo "[gen] Archivo:    $(@F)"
   	@touch $@
   ```
   Verifica: `make dist/reportes/informe-q1.txt` debe crear el directorio y el archivo.

3. Completa la regla `$(DIST)/datos/%.csv:` con el mismo patrón.

4. Ejecuta `make all` y verifica el árbol de archivos de los informes:
   ```bash
   make all
   find dist/reportes dist/datos -type f
   # dist/reportes/informe-q1.txt
   # dist/reportes/informe-q2.txt
   # dist/datos/estadisticas.csv
   ```
   (Las reglas de los pasos 7 y 8 aún imprimen su TODO.)

5. Completa `limpiar` con la guarda de la semana 03 (ver el TODO): borra
   `dist/` y se niega a ejecutar `rm -rf` si `DIST` está vacía:
   ```bash
   make limpiar DIST=
   # Makefile:NN: *** DIST vacía: rm -rf no se ejecuta.  Stop.
   ```

6. Verifica que todo se construye en otro directorio sin cambiar ninguna receta:
   ```bash
   make all DIST=output
   find output -type f | sort
   make limpiar DIST=output
   ```

7. **El otro lado: `$(<D)` y `$(<F)`.** La regla `$(DIST)/docs/%.md` copia
   `plantillas/guia.md` y `plantillas/faq.md` (ya están en la carpeta del lab).
   Entrada y salida viven en directorios distintos. Completa su TODO y ejecuta:
   ```bash
   make all
   ```
   Debes ver:
   ```
   [copia] plantillas / guia.md → dist/docs / guia.md
   [copia] plantillas / faq.md → dist/docs / faq.md
   ```
   `$(<D)` y `$(<F)` descomponen el prerrequisito igual que `$(@D)` y `$(@F)`
   descomponen el target.

8. **Un índice que se mantiene solo.** Completa `$(DIST)/indice.txt`: depende
   de todos los artefactos y escribe uno por línea con `printf '%s\n' $^ > $@`.
   Comprueba el comportamiento incremental:
   ```bash
   make all                    # [indice] dist/indice.txt listo.
   cat dist/indice.txt         # cinco rutas, una por línea
   make all                    # make: Nothing to be done for 'all'.
   touch plantillas/faq.md
   make all                    # solo la copia de faq.md y el índice
   ```
   Termina con `make limpiar`.

## Criterios de éxito

- [ ] `make all` crea los tres informes, las dos copias en `dist/docs/` y `dist/indice.txt`
- [ ] Las recetas usan `$(@D)` para `mkdir -p` — sin paths hardcodeados
- [ ] `make all DIST=output` construye la misma estructura en `output/` sin tocar las recetas
- [ ] La regla de copia imprime `plantillas / guia.md → dist/docs / guia.md` usando `$(<D)`, `$(<F)`, `$(@D)` y `$(@F)`
- [ ] Tras `touch plantillas/faq.md`, `make all` rehace solo esa copia y el índice
- [ ] `make limpiar` elimina `dist/`; `make limpiar DIST=` se niega a borrar
- [ ] `make help` lista todos los targets con descripción

## Reto extra

Haz que el índice muestre solo los artefactos que cambiaron desde la última
vez, además de la lista completa: añade al final de `dist/indice.txt` una
línea `# cambiados: ...` con `$?`. Toca un solo informe con `touch` y comprueba
que la línea lo refleja.
