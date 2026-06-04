# Lab 04 — Targets que crean archivos vs targets PHONY

⏱ Duración estimada: ~50 min

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

## Criterios de éxito

- [ ] Primera ejecución de `make reporte.txt`: crea el archivo
- [ ] Segunda ejecución sin cambios: `make: 'reporte.txt' is up to date`
- [ ] Tras `touch datos.csv`: Make regenera `reporte.txt`
- [ ] `make clean` elimina ambos archivos

## Reto extra

Agrega un segundo archivo de entrada `config.txt` como dependencia adicional de `reporte.txt`. Verifica que tocar cualquiera de los dos (`datos.csv` o `config.txt`) dispara la regeneración.
