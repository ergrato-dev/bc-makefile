# Lab 01 — `$@`: el target se conoce a sí mismo

⏱ Duración estimada: ~60 min

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

7. **`$@` con archivos reales.** Hasta ahora `$@` solo aparecía en mensajes.
   Su uso de verdad es nombrar el archivo que produce la receta. La regla
   `ventas.txt gastos.txt:` tiene **dos targets**: Make la ejecuta una vez por
   cada uno, y `$@` vale uno u otro. Completa su TODO y ejecuta:
   ```bash
   make archivos
   cat ventas.txt
   ```
   Debes ver:
   ```
   [listo] ventas.txt creado
   [listo] gastos.txt creado
   Informe ventas.txt del YYYY-MM-DD
   ```

8. Comprueba que son archivos de verdad para Make:
   ```bash
   make archivos       # make: Nothing to be done for 'archivos'.
   rm gastos.txt
   make archivos       # [listo] gastos.txt creado   (solo ese)
   make limpiar
   ```
   Como `$@` coincide con el nombre del target, Make puede comparar el archivo
   que existe con el que la regla promete crear. Si la receta escribiera en
   otro nombre, Make la ejecutaría en cada llamada sin saber por qué.

## Criterios de éxito

- [ ] `make reporte-html` imprime:
  ```
  [generando] reporte-html
  [listo] Archivo: YYYY-MM-DD-reporte-html.html
  ```
- [ ] `make reporte-pdf` imprime el mismo patrón con `reporte-pdf` y extensión `.pdf`
- [ ] `make reporte-csv` ídem con `.csv`
- [ ] Ninguna receta contiene el string `"reporte-html"`, `"reporte-pdf"` ni `"reporte-csv"` escrito literalmente
- [ ] `make archivos` crea `ventas.txt` y `gastos.txt` con una sola regla, y cada archivo contiene su propio nombre
- [ ] Tras `rm gastos.txt`, `make archivos` regenera solo `gastos.txt`
- [ ] `make help` lista los targets (incluyendo `reporte-json`) con descripción

## Reto extra

Unifica los cuatro targets en una sola regla de patrón `reporte-%:`. La receta usa `$@` para el mensaje de inicio y `$*` para derivar la extensión del archivo de salida. Pista: `$*` = `html`, `pdf`, `csv` o `json` según el target invocado.
