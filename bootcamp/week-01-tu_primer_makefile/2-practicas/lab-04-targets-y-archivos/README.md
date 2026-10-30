# Lab 04 — Targets que crean archivos vs targets PHONY

⏱ Duración estimada: ~60 min

## Objetivo

Ver en acción la lógica de timestamps de Make: cuando el nombre del target coincide con un archivo real, Make lo omite si ese archivo es más nuevo que sus dependencias.

## Contexto

Make compara timestamps. Si el target produce `reporte.txt` y ese archivo ya existe y es más nuevo que `datos.csv`, Make dice `Nothing to be done for 'reporte.txt'`. Esto es una feature, no un bug — evita trabajo innecesario. Pero hay que declarar la dependencia correctamente para que funcione.

## Instrucciones

1. Ejecuta el setup inicial:
   ```bash
   make preparar
   ```
   Crea `datos.csv` con tres filas.

2. Genera el reporte:
   ```bash
   make reporte.txt
   ```
   Debe crear `reporte.txt`.

3. Ejecuta `make reporte.txt` de nuevo sin cambiar nada:
   ```bash
   make reporte.txt
   ```
   Observa el mensaje de Make. ¿Ejecutó la receta?

4. Abre `starter/Makefile`. El target `reporte.txt` no tiene dependencias declaradas. Agrega `datos.csv` como dependencia (ver TODO):
   ```makefile
   reporte.txt: datos.csv
   ```

5. Actualiza el timestamp de `datos.csv` para simular un cambio:
   ```bash
   touch datos.csv
   ```

6. Ejecuta `make reporte.txt` de nuevo:
   ```bash
   make reporte.txt
   ```
   Ahora sí regenera — `datos.csv` es más nuevo que `reporte.txt`.

7. Limpia y repite desde el paso 1 para confirmar:
   ```bash
   make clean
   ```

8. **Cadena de dos niveles.** `resumen.txt` cuenta las líneas de
   `reporte.txt`. Completa su TODO (`resumen.txt: reporte.txt`) y construye todo
   de nuevo:
   ```bash
   make preparar
   make resumen.txt
   ```
   Make genera `reporte.txt` primero (no existía) y después `resumen.txt`. Ahora
   predice qué se regenera en cada caso antes de ejecutarlo:

   | Comando | Debes ver |
   |---------|-----------|
   | `make resumen.txt` (sin tocar nada) | `make: 'resumen.txt' is up to date.` |
   | `touch reporte.txt && make resumen.txt` | Solo `Generando resumen.txt...` |
   | `touch datos.csv && make resumen.txt` | `Generando reporte.txt...` y después `Generando resumen.txt...` |
   | `rm reporte.txt && make resumen.txt` | Los dos, en ese orden |

   Make recorre la cadena hacia atrás desde el target pedido y solo rehace
   los eslabones cuya dependencia es más nueva o falta.

9. Comprueba el contenido:
   ```bash
   cat resumen.txt
   ```
   Debe decir `Líneas del reporte: 7`. Observa el `$$(wc -l < reporte.txt)` de
   la receta: `$$` llega a la shell como `$`, y es la shell la que ejecuta
   `wc`. Termina con `make clean`.

## Criterios de éxito

- [ ] Primera ejecución de `make reporte.txt`: crea el archivo
- [ ] Segunda ejecución sin cambios: `make: 'reporte.txt' is up to date`
- [ ] Tras `touch datos.csv`: Make regenera `reporte.txt`
- [ ] Tras `touch reporte.txt`, `make resumen.txt` regenera solo `resumen.txt`
- [ ] Tras `touch datos.csv`, `make resumen.txt` regenera los dos, en orden
- [ ] `make clean` elimina los tres archivos

## Reto extra

Agrega un segundo archivo de entrada `config.txt` como dependencia adicional de `reporte.txt`. Verifica que tocar cualquiera de los dos (`datos.csv` o `config.txt`) dispara la regeneración.
