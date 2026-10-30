# Lab 06 — Dependencias rotas

⏱ Duración estimada: ~60 min

## Objetivo

Diagnosticar y corregir cinco bugs de dependencias en un Makefile que parece correcto, reproduciendo cada síntoma antes de tocar el código.

## Contexto

- Ninguno de los cinco bugs es de sintaxis. Todos son errores reales que aparecen en proyectos C: unos rompen el primer build, otros solo se ven con `-j` o al borrar un header, y uno hace que el build nunca esté al día.
- Regla del lab: **primero reproduces el síntoma, después corriges**. Una corrección sin síntoma reproducido no cuenta.
- Repasa los labs 01, 02 y 04 si no reconoces un síntoma: cada bug corresponde a uno de ellos.

## Los cinco bugs

| Bug | Síntoma | Cómo reproducirlo |
|:--:|---|---|
| A | Ni siquiera `make help` funciona en un clon recién hecho | `make` |
| E | El primer build falla: `build_info.h: No such file or directory` | `make clean && make all` |
| D | El generador corre dos veces | `make clean && make -j4 all` |
| C | Cada `make all` recompila todo, aunque no cambies nada | `make all` dos veces |
| B | Borrar un header que ya no se usa rompe el build | ver paso 5 |

El orden es el de aparición: cada bug tapa al siguiente.

## Instrucciones

Trabaja dentro de `starter/`. Para cada bug: reprodúcelo, corrígelo con el cambio
mínimo y deja encima un comentario `# FIX X:` que explique **por qué** fallaba.

1. **Bug A.**
   ```bash
   make
   ```
   ```
   Makefile:63: build/gen/build_info.d: No such file or directory
   make: *** No rule to make target 'build/gen/build_info.d'.  Stop.
   ```
   Pista: ¿qué archivos existen en un clon recién hecho? Tras corregirlo, `make`
   muestra la ayuda y `make clean` funciona.

2. **Bug E.**
   ```bash
   make clean && make all
   ```
   ```
   [cc]   src/main.c
   src/main.c:2:10: fatal error: build_info.h: No such file or directory
   ```
   `main.c` incluye un header que genera `tools/gen-info.sh`. Pista: en el primer build
   todavía no hay ningún `.d`. La corrección no debe hacer que tocar `VERSION`
   recompile `util.o`: compruébalo con `touch VERSION && make all`, que debe recompilar
   solo `main.c` y `build_info.c`.

3. **Bug D.**
   ```bash
   make clean && make -j4 all
   ```
   ```
   [gen]  build/gen/build_info.c + build_info.h (v2.0.1)
   [gen]  build/gen/build_info.c + build_info.h (v2.0.1)
   ```
   Tras corregirlo, `make clean && make -j4 all | grep -c '^.gen.'` imprime `1` siempre.

4. **Bug C.**
   ```bash
   make all
   make all
   ```
   El segundo vuelve a imprimir `[cc] src/main.c`, `[cc] src/util.c` y `[link]`. Tras
   corregirlo, imprime `make: Nothing to be done for 'all'.` y `touch build/x && make all`
   tampoco recompila.

5. **Bug B.** Con todo compilado, `include/obsoleto.h` ya no lo usa nadie. Borra la
   línea `#include "obsoleto.h"` de `src/util.c` y el archivo:
   ```bash
   rm include/obsoleto.h
   make all
   ```
   ```
   make: *** No rule to make target 'include/obsoleto.h', needed by 'build/util.o'.  Stop.
   ```
   Para comprobar tu corrección necesitas un `.d` regenerado **con** el header:
   `git restore src/util.c include/obsoleto.h`, `make clean && make all`, y repite el
   borrado. Debe recompilar `util.c` sin error.

6. **Verificación final.**
   ```bash
   make clean && make -j4 all && make run
   ```
   ```
   app 2.0.1
   doble(21) = 42
   ```

## Criterios de éxito

- [ ] Bug A: `make` en un árbol sin `build/` muestra la ayuda
- [ ] Bug E: `make clean && make all` compila sin error, y `touch VERSION && make all` recompila exactamente dos fuentes
- [ ] Bug D: `make clean && make -j4 all | grep -c '^.gen.'` imprime `1`
- [ ] Bug C: un segundo `make all` imprime `Nothing to be done for 'all'.`
- [ ] Bug B: borrar el `#include` y el header no rompe el build
- [ ] Cada corrección tiene encima su comentario `# FIX X:`

## Reto extra

Un sexto bug, este sin síntoma visible: `make all CFLAGS=-O2` no recompila nada.
Corrígelo con el stamp de flags del lab 01 y verifica que `make all CFLAGS=-O2`
recompila los tres objetos y que repetirlo no hace nada.
