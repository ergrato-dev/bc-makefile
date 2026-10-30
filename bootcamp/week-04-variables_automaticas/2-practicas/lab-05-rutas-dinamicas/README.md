# Lab 05 — `$(@D)` y `$(@F)`: construir rutas de salida dinámicas

⏱ Duración estimada: ~50 min

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

4. Ejecuta `make all` y verifica el árbol de archivos:
   ```bash
   make all
   find dist/ -type f
   # dist/reportes/informe-q1.txt
   # dist/reportes/informe-q2.txt
   # dist/datos/estadisticas.csv
   ```

5. Completa `limpiar` para eliminar el directorio `dist/` completo.

6. Verifica que cambiar `DIST := dist` por `DIST := output` y ejecutar `make all` construye la misma estructura en `output/` sin cambiar ninguna receta.

## Criterios de éxito

- [ ] `make all` crea `dist/reportes/informe-q1.txt`, `dist/reportes/informe-q2.txt` y `dist/datos/estadisticas.csv`
- [ ] Las recetas usan `$(@D)` para `mkdir -p` — sin paths hardcodeados
- [ ] Cambiar `DIST` en la variable hace que todo se construya en el nuevo directorio sin tocar las recetas
- [ ] `make limpiar` elimina `dist/` sin errores
- [ ] `make help` lista todos los targets con descripción

## Reto extra

Agrega una regla que construya un archivo de índice `$(DIST)/indice.txt` que liste todos los artefactos. En la receta, usa `$(@D)` para crear el directorio y `$^` para escribir la lista de artefactos en el archivo: `@echo "$^" > $@`.
