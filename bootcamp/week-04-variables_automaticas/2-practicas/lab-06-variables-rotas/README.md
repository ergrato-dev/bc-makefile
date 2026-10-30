# Lab 06 — Variables automáticas rotas

⏱ Duración estimada: ~60 min

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

1. Crea los archivos de prueba que usan los targets:
   ```bash
   make setup
   ```
   Debes ver `[setup] Listo: main.c utils.c alfa.md main.o utils.o math.o`.

2. Ejecuta cada target **antes** de corregir y anota el síntoma:
   ```bash
   make info-etiqueta   # Etiqueta: build-
   make enlazar         # [ld] Enlazando: main.o
   make construir       # [cc+ld] Binario: mi-app
   make alfa.html       # [convert] Stem: (vacío)
   make build/main.o    # touch: cannot touch 'build/main.o': No such file or directory
   ```

3. Abre `starter/Makefile`. Lee todos los comentarios `# BUG:` para identificar cada problema. Para cada bug, escribe en un comentario `# FIX:` inmediatamente debajo qué cambio harías y por qué.

4. Aplica todas las correcciones. El Makefile corregido debe:
   - Imprimir `ETIQUETA` con el nombre del target correcto
   - El target `enlazar` debe listar los tres objetos
   - El binario debe llamarse igual que el target
   - El mensaje de stem debe mostrar el stem real
   - La compilación en subdirectorio debe crear el directorio automáticamente

5. **Comprueba sin ejecutar.** Antes de lanzar cada target corregido, mira qué
   haría con `make -n` (y `-B` para que lo rehaga aunque esté al día):
   ```bash
   make limpiar && make setup
   make -n -B build/main.o
   # mkdir -p build
   # echo "[cc] Compilando main.c → build/main.o"
   # touch build/main.o
   ```
   Fíjate en que las variables automáticas ya salen expandidas: `make -n` es
   la forma más rápida de ver qué vale `$@`, `$<` o `$^` en una regla concreta.

6. Verifica con:
   ```bash
   make info-etiqueta
   make enlazar
   make construir
   make alfa.html
   make build/main.o
   make limpiar
   ```

## Criterios de éxito

- [ ] Bug A: `make info-etiqueta` imprime `Etiqueta: build-info-etiqueta`
- [ ] Bug B: `make enlazar` lista los tres objetos en el linker
- [ ] Bug C: `make construir` muestra un binario con el nombre del target, no hardcodeado
- [ ] Bug D: `make alfa.html` imprime el stem `alfa`, no una cadena vacía
- [ ] Bug E: `make build/main.o` se ejecuta sin error de directorio
- [ ] `make -n -B build/main.o` muestra `mkdir -p build` como primer comando
- [ ] Cada corrección tiene un comentario `# FIX:` explicando el cambio

## Reto extra

Rompe tú el Makefile corregido de una sexta forma: cambia la receta de
`build/main.o` por una compilación real que use `$^` en lugar de `$<`
(`gcc -c $^ -o $@`) y añade `utils.c` como segundo prerrequisito. Ejecuta
`make -B build/main.o` y explica en un comentario `# FIX:` por qué el error de
gcc no menciona `$^` en ningún momento, y cómo lo habrías encontrado con
`make -n`.
