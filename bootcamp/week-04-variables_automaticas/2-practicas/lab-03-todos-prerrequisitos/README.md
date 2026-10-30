# Lab 03 — `$^` y `$?`: todos vs. los modificados

⏱ Duración estimada: ~50 min

## Objetivo

Distinguir `$^` (todos los prerrequisitos, deduplicado) de `$?` (solo los más nuevos que el target) y comprender cuándo usar cada uno.

## Contexto

- **`$^`**: lista todos los prerrequisitos, eliminando duplicados. Útil para el linker o para comandos que operan sobre todos los archivos de entrada.

- **`$?`**: lista solo los prerrequisitos cuyo timestamp es más reciente que el del target. Solo tiene sentido en targets **no phony** (archivos reales). En targets phony siempre lista todos.

Para ver `$?` en acción, el target debe ser un archivo real que Make pueda comparar con sus prerrequisitos. Este lab usa `manual.txt` como target real.

**Nota sobre timestamps:** Make compara timestamps con resolución de segundo. Para que `$?` funcione correctamente en el lab, los archivos de prueba deben tener timestamps más antiguos que `manual.txt`. El target `setup` se encarga de esto.

## Instrucciones

1. Abre `starter/Makefile`. Lee todos los comentarios antes de editar.

2. Completa el target `enlazar` para demostrar deduplicación de `$^`:
   ```bash
   make enlazar
   # [ld] Lista con duplicados: main.o utils.o math.o main.o utils.o
   # [ld] $^ (deduplicado):     main.o utils.o math.o
   ```

3. Crea los archivos de prueba:
   ```bash
   make setup
   ```

4. Intenta construir `manual.txt`:
   ```bash
   make manual.txt
   # Make responde: "Nothing to be done for 'manual.txt'"
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

## Criterios de éxito

- [ ] `make enlazar` muestra la lista sin duplicados en `$^`
- [ ] Tras `make setup` y `touch seccion-b.txt`, `make manual.txt` muestra solo `seccion-b.txt` en `$?`
- [ ] `make limpiar` elimina todos los archivos de prueba sin errores
- [ ] `make help` lista todos los targets con descripción

## Reto extra

Agrega un target real `log.txt` que dependa de tres archivos `.log` creados por `setup`. Usa `$?` en la receta para imprimir qué logs son nuevos. Modifica uno de los logs y verifica el comportamiento incremental.
