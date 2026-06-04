# Lab 05 — Depurar un Makefile roto

⏱ Duración estimada: ~50 min

## Objetivo

Diagnosticar y corregir cuatro errores reales en un Makefile usando los mensajes de error de Make como guía.

## Contexto

Los errores de Make son crípticos al principio. Este lab te expone a los cuatro más frecuentes para que los reconozcas de inmediato en proyectos reales. No busques las respuestas directamente en la solución — intenta leer el mensaje de error y razonarlo primero.

Los cuatro errores en `starter/Makefile`:

| # | Tipo de error | Síntoma en Make |
|---|---------------|-----------------|
| 1 | Espacios en lugar de TAB en la receta | `missing separator. Stop.` |
| 2 | Dependencia circular | `Circular dependency dropped.` |
| 3 | Target de archivo sin `.PHONY` (hay archivo `test` en el dir) | `make: 'test' is up to date` |
| 4 | Referencia a target inexistente como dependencia | `No rule to make target 'X'` |

## Instrucciones

1. Ejecuta `make all` y lee el error:
   ```bash
   make all
   ```

2. **Error 1 — separador faltante:** Abre `starter/Makefile` en tu editor con whitespace visible. Busca la receta que usa espacios en lugar de TAB. Corrígela.

3. Vuelve a ejecutar `make all`. Sigue el siguiente error.

4. **Error 2 — dependencia circular:** Lee el warning de Make. Identifica qué par de targets se llaman mutuamente. Rompe el ciclo eliminando una dependencia incorrecta.

5. **Error 3 — archivo fantasma:** Ejecuta `ls` en la carpeta del lab. Hay un archivo llamado `test`. Agrega ese target al `.PHONY`.

6. **Error 4 — target inexistente:** El error dice `No rule to make target 'validate'`. Busca dónde se referencia `validate` y corrige el nombre (hay un typo).

7. Verifica que todo funciona:
   ```bash
   make all
   make test
   make clean
   ```

## Criterios de éxito

- [ ] `make all` corre sin errores ni warnings
- [ ] `make test` ejecuta la receta aunque exista un archivo `test` en el directorio
- [ ] `make clean` limpia sin errores
- [ ] Puedes explicar cada error y su causa

## Reto extra

Usa `make -n` (dry-run) para ver qué haría Make sin ejecutar nada realmente. Úsalo para verificar el orden de ejecución de `make all` antes de correrlo.
