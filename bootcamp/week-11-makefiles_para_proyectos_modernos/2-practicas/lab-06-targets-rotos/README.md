# Lab 06 — Targets Rotos

**Duración estimada:** 60 minutos

**Requisitos:** GNU Make y bash. No hace falta uv ni Docker: la instalación y la imagen están simuladas con `echo`.

## Objetivo

Diagnosticar y corregir seis errores reales de un Makefile de servicio Python con Docker, reproduciendo cada síntoma antes de tocar el código.

## Contexto

Un compañero dejó el Makefile del servicio `pedidos` con seis bugs. Dos son clásicos de cualquier Makefile; los otros cuatro son específicos de proyectos modernos: sentinels mal declarados, versiones de imagen vacías, secretos filtrados al entorno y fechas que cambian dentro del mismo despliegue. Ninguno hace fallar el build de forma ruidosa salvo el primero: ahí está la dificultad.

La regla del lab: **primero reproduces, después corriges**. Para cada bug apunta en un comentario `# FIX N:` el síntoma que viste, la causa y por qué tu cambio la elimina.

## Instrucciones

1. Entra al directorio starter y ejecuta cualquier target:
   ```bash
   cd lab-06-targets-rotos/starter
   make help
   ```
   **Síntoma 1:** `Makefile:NN: *** missing separator.  Stop.` Es un error de sintaxis: Make no llega a leer el resto del archivo. Localiza la línea, mírala con `cat -A Makefile | sed -n 'NN p'` (un TAB se ve como `^I`) y corrígelo.

2. **Síntoma 2.** Ejecuta `make build` dos veces:
   ```bash
   make build
   make build
   ```
   La segunda dice `make: 'build' is up to date.` aunque nunca le pediste que comprobara nada. Explica por qué la primera ejecución "rompe" la segunda y corrígelo.

3. **Síntoma 3.** Ejecuta `make tag` y `make release`. ¿Qué etiqueta de imagen sale? Prueba `docker build -t pedidos: .` si tienes Docker: falla con `invalid reference format`. Corrige `VERSION` para que nunca quede vacía (hash corto de git con `--always`, y `0.0.0` fuera de un repo).

4. **Síntoma 4.** Simula que un compañero ejecutó `uv lock --upgrade` y solo cambió el lock:
   ```bash
   make install
   touch uv.lock
   make install
   ```
   Make no reinstala: tu entorno sigue con las versiones viejas. Corrige el sentinel y comprueba que ahora `touch uv.lock && make -n install` muestra la instalación.

5. **Síntoma 5.** Ejecuta `make env-check`. La receta solo necesita `LOG_LEVEL`, pero ve también `DB_PASSWORD`: cualquier script, dependencia o log de esa receta puede filtrarla. Busca la línea responsable y sustitúyela por un `export` con lista explícita.

6. **Síntoma 6.** Ejecuta `make release` y compara las dos horas:
   ```
   docker build --build-arg BUILD_DATE=08:33:04 -t pedidos:... .
   Etiqueta org.opencontainers.image.created=08:33:05
   ```
   Son distintas dentro del mismo despliegue. Explica por qué `BUILD_DATE` se calcula dos veces y corrígelo.

7. Verifica el Makefile corregido y limpia:
   ```bash
   make demo
   make demo        # build se rehace; install no
   make clean
   ```

## Criterios de éxito

```
$ make demo
Build OK: build/artefacto.txt
uv sync --locked  (simulado)
Imagen: pedidos:ef69027
docker build --build-arg BUILD_DATE=08:33:14 -t pedidos:ef69027 .
Etiqueta org.opencontainers.image.created=08:33:14
LOG_LEVEL=INFO
```

- Ningún `missing separator` ni `'build' is up to date`.
- La imagen lleva versión (hash de git, tag o `0.0.0`), nunca `pedidos:`.
- `touch uv.lock && make -n install` muestra `uv sync --locked  (simulado)`.
- `make env-check` muestra `LOG_LEVEL` y **no** `DB_PASSWORD`.
- Las dos horas de `make release` son iguales.
- Cada corrección lleva su comentario `# FIX N:` con síntoma, causa y arreglo.

## Reto extra

Ejecuta `make --warn-undefined-variables demo` sobre el Makefile **original** (con el bug 1 ya corregido). ¿Detecta alguno de los otros cinco bugs? Explica en dos líneas por qué estos errores no se pueden encontrar con flags de Make y sí con una comprobación de comportamiento como las de `checks.json`.
