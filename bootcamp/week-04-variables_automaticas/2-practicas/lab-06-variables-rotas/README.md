# Lab 06 — Variables automáticas rotas

⏱ Duración estimada: ~50 min

## Objetivo

Diagnosticar y corregir cinco usos incorrectos de variables automáticas en un Makefile con bugs intencionados.

## Contexto

Las variables automáticas tienen reglas de uso estrictas que no producen errores de sintaxis — Make los acepta y ejecuta silenciosamente de forma incorrecta. Los síntomas son:

- Output vacío donde debería haber texto
- Archivo de salida con nombre incorrecto
- Binario sin enlazar correctamente
- Directorio de salida que no existe

Este lab contiene cinco bugs. Tu tarea es identificar cada uno, entender por qué falla y aplicar la corrección mínima.

## Los cinco bugs

| # | Síntoma observable | Variable involucrada |
|---|-------------------|----------------------|
| A | `ETIQUETA` siempre es `"build-"` sin sufijo | `$@` fuera de receta |
| B | El linker solo enlaza `main.o`; falta `utils.o` y `math.o` | `$<` en lugar de `$^` |
| C | El binario se llama `mi-app` aunque el target se renombró | nombre hardcodeado en vez de `$@` |
| D | El mensaje de stem siempre imprime vacío | `$*` en regla explícita, no de patrón |
| E | `make build/main.o` falla con "No such file or directory" | `$(@D)` sin `mkdir -p` |

## Instrucciones

1. Abre `starter/Makefile`. Lee todos los comentarios `# BUG:` para identificar cada problema.

2. Para cada bug, escribe en un comentario `# FIX:` inmediatamente debajo qué cambio harías y por qué.

3. Aplica todas las correcciones. El Makefile corregido debe:
   - Imprimir `ETIQUETA` con el nombre del target correcto
   - El target `enlazar` debe listar los tres objetos
   - El binario debe llamarse igual que el target
   - El mensaje de stem debe mostrar el stem real
   - La compilación en subdirectorio debe crear el directorio automáticamente

4. Verifica con:
   ```bash
   make info-etiqueta
   make enlazar
   make construir
   make alfa.html
   make build/main.o
   ```

## Criterios de éxito

- [ ] Bug A: `make info-etiqueta` imprime una etiqueta no vacía
- [ ] Bug B: `make enlazar` lista los tres objetos en el linker
- [ ] Bug C: `make construir` crea un binario con el nombre del target, no hardcodeado
- [ ] Bug D: `make alfa.html` imprime el stem `alfa`, no una cadena vacía
- [ ] Bug E: `make build/main.o` se ejecuta sin error de directorio
- [ ] Cada corrección tiene un comentario `# FIX:` explicando el cambio

## Reto extra

Rompe tú el Makefile corregido de una sexta forma: usa `$^` en la regla de
compilación en lugar de `$<` y añade `include/util.h` como prerrequisito del
`.o`. Ejecuta `make -B build/main.o` y explica en un comentario `# FIX:` por qué
el error que da gcc no menciona `$^` en ningún momento, y cómo lo habrías
encontrado con `make -n`.
