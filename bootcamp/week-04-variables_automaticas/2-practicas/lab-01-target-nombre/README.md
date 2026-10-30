# Lab 01 — `$@`: el target se conoce a sí mismo

⏱ Duración estimada: ~50 min

## Objetivo

Usar la variable automática `$@` para que una receta referencie el nombre de su propio target sin escribirlo literalmente en ningún `@echo` o comando.

## Contexto

`$@` expande al nombre del target de la regla actual. Cada vez que Make ejecuta una regla, inyecta el nombre exacto de ese target en `$@`. Esto tiene dos consecuencias importantes:

- Una receta que usa `$@` funciona correctamente sin importar cómo se llame el target.
- Si renombras el target, la receta sigue siendo correcta sin modificarla.

El uso más directo es en recetas que producen un archivo con el nombre del target: `gcc ... -o $@` siempre escribe el binario correcto.

## Instrucciones

1. Abre `starter/Makefile`. Hay tres targets de reporte: `reporte-html`, `reporte-pdf`, `reporte-csv`.

2. Completa la receta de `reporte-html` usando `$@`:
   ```makefile
   reporte-html:
   	@echo "[generando] $@"
   	@echo "[listo] Archivo: $(FECHA)-$@.html"
   ```
   Verifica: `make reporte-html` debe imprimir `[generando] reporte-html`.

3. Completa `reporte-pdf` con el mismo patrón de receta. El único cambio permitido es la extensión en el segundo `@echo` (`.pdf` en lugar de `.html`). No escribas `reporte-pdf` en ninguna línea de la receta.

4. Completa `reporte-csv` con extensión `.csv`.

5. Verifica los tres targets:
   ```bash
   make reporte-html
   make reporte-pdf
   make reporte-csv
   ```

6. Agrega un cuarto target `reporte-json` con extensión `.json`. Decláralo en `.PHONY` y en `help`. No escribas `reporte-json` en la receta.

## Criterios de éxito

- [ ] `make reporte-html` imprime:
  ```
  [generando] reporte-html
  [listo] Archivo: YYYY-MM-DD-reporte-html.html
  ```
- [ ] `make reporte-pdf` imprime el mismo patrón con `reporte-pdf` y extensión `.pdf`
- [ ] `make reporte-csv` ídem con `.csv`
- [ ] Ninguna receta contiene el string `"reporte-html"`, `"reporte-pdf"` ni `"reporte-csv"` escrito literalmente
- [ ] `make help` lista los cuatro targets (incluyendo `reporte-json`) con descripción

## Reto extra

Unifica los cuatro targets en una sola regla de patrón `reporte-%:`. La receta usa `$@` para el mensaje de inicio y `$*` para derivar la extensión del archivo de salida. Pista: `$*` = `html`, `pdf`, `csv` o `json` según el target invocado.
