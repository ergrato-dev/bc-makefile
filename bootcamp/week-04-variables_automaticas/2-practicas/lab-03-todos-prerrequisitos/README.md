# Lab 03 — `$^` y `$?`: todos vs. los modificados

⏱ Duración estimada: ~60 min

## Objetivo

Distinguir `$^` (todos los prerrequisitos, deduplicado) de `$?` (solo los más nuevos que el target) y comprender cuándo usar cada uno.

## Contexto

- **`$^`**: lista todos los prerrequisitos, eliminando duplicados. Útil para el linker o para comandos que operan sobre todos los archivos de entrada.

- **`$?`**: lista solo los prerrequisitos cuyo timestamp es más reciente que el del target. Solo tiene sentido en targets **no phony** (archivos reales). En targets phony siempre lista todos.

Para ver `$?` en acción, el target debe ser un archivo real que Make pueda comparar con sus prerrequisitos: este lab usa `manual.txt` y `cambios.log`. Algunos sistemas de archivos guardan las fechas con resolución de un segundo, así que `setup` espera un segundo antes de crear `manual.txt` para que quede claramente más nuevo que las secciones.

## Instrucciones

1. Abre `starter/Makefile`. Lee todos los comentarios antes de editar.

2. Crea los archivos de prueba (las tres secciones, `manual.txt` y tres `.o`
   vacíos que usa `enlazar`):
   ```bash
   make setup
   ```
   Sin ellos, `make enlazar` se detiene con `No rule to make target 'main.o'`:
   un prerrequisito tiene que existir o tener una regla que lo cree.

3. Completa el target `enlazar` para demostrar deduplicación de `$^`:
   ```bash
   make enlazar
   # [ld] Lista con duplicados: main.o utils.o math.o main.o utils.o
   # [ld] $^ (deduplicado):     main.o utils.o math.o
   ```

4. Intenta construir `manual.txt`:
   ```bash
   make manual.txt
   # Make responde: "make: 'manual.txt' is up to date."
   # Porque manual.txt es más nuevo que todos sus prerrequisitos.
   ```

5. Modifica uno de los prerrequisitos:
   ```bash
   touch seccion-b.txt
   make manual.txt
   # [combinar] TODOS los prerrequisitos: seccion-a.txt seccion-b.txt seccion-c.txt
   # [combinar] Solo los MODIFICADOS:     seccion-b.txt
   ```

6. Completa las recetas con TODOs en el Makefile según lo observado.

7. **`$+`: cuando el orden y las repeticiones importan.** Añade a `enlazar` la
   línea con `$+` y repite `make enlazar`:
   ```
   [ld] $+ (con duplicados):  main.o utils.o math.o main.o utils.o
   ```
   `$+` conserva la lista tal cual. Existe porque algunos enlazadores necesitan
   repetir una biblioteca estática (`-lfoo ... -lfoo`) para resolver
   dependencias circulares; `$^` se las comería.

8. **`$?` en un uso real.** Completa `cambios.log`: un registro que anota solo
   lo que cambió desde la última vez. Ejecuta:
   ```bash
   make cambios.log        # [log] Cambiaron: seccion-a.txt seccion-b.txt seccion-c.txt
   make cambios.log        # make: 'cambios.log' is up to date.
   touch seccion-c.txt
   make cambios.log        # [log] Cambiaron: seccion-c.txt
   cat cambios.log
   ```
   La primera vez `cambios.log` no existe y `$?` trae todo; después, solo lo
   nuevo. Observa el `$$(date +%T)` de la receta: `$$` hace que la hora la
   calcule la shell al ejecutar, no Make. Termina con `make limpiar`.

## Criterios de éxito

- [ ] `make enlazar` muestra la lista sin duplicados en `$^` y con duplicados en `$+`
- [ ] Tras `make setup` y `touch seccion-b.txt`, `make manual.txt` muestra solo `seccion-b.txt` en `$?`
- [ ] `cambios.log` tiene dos líneas: la primera con las tres secciones y la segunda solo con `seccion-c.txt`
- [ ] `make limpiar` elimina todos los archivos de prueba sin errores
- [ ] `make help` lista todos los targets con descripción

## Reto extra

Agrega un target real `log.txt` que dependa de tres archivos `.log` creados por `setup`. Usa `$?` en la receta para imprimir qué logs son nuevos. Modifica uno de los logs y verifica el comportamiento incremental.
