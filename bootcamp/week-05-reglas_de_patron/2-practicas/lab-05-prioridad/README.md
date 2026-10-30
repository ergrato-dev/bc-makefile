# Lab 05 — Cómo elige Make una regla

⏱ Duración estimada: ~60 min

## Objetivo

Comprobar en la terminal cada paso del algoritmo con el que GNU Make elige la regla de un target y desactivar las reglas implícitas de serie con `MAKEFLAGS += -r`.

## Contexto

La simplificación "explícita > static > patrón > implícita" falla en casos reales. Lo que dice el manual de GNU Make (resumido en [02-reglas-implicitas.md](../../1-teoria/02-reglas-implicitas.md)):

- Una regla explícita **con receta** gana. Una static pattern rule también es explícita; si dos dan receta al mismo target, gana la última con un aviso.
- Una regla explícita **sin receta** solo añade prerrequisitos: Make sigue buscando un patrón.
- Entre reglas de patrón aplicables gana la de **stem más corto**; con empate, la primera del archivo. Las de serie son reglas de patrón más, por detrás de las tuyas.

## Instrucciones

1. Entra en `starter/`. Solo hay una regla de patrón general. Compila y ejecuta:
   ```bash
   make all && ./app
   ```
   ```
   gcc -Wall -std=c11 -c main.c -o main.o
   [patrón %] main.o stem=main
   gcc -Wall -std=c11 -c normal.c -o normal.o
   [patrón %] normal.o stem=normal
   gcc -Wall -std=c11 -c debug.c -o debug.o
   [patrón %] debug.o stem=debug
   gcc main.o normal.o debug.o -o app
   modulo normal activo
   modulo debug (sin flag DEBUG)
   ```

2. **Explícita con receta.** Añade la regla `debug.o: debug.c` con `-g -DDEBUG` (ver TODO) y reconstruye:
   ```bash
   make -B debug.o && make all && ./app
   ```
   ```
   gcc -Wall -std=c11 -g -DDEBUG -c debug.c -o debug.o
   [explícita] debug.o compilado con -g -DDEBUG
   gcc main.o normal.o debug.o -o app
   modulo normal activo
   DEBUG: modulo debug activo
   ```

3. **Explícita sin receta.** `normal.c` incluye `config.h`. Añade solo `normal.o: config.h` y comprueba que el patrón sigue mandando, ahora con un prerrequisito más:
   ```bash
   touch config.h && make all
   ```
   ```
   gcc -Wall -std=c11 -c normal.c -o normal.o
   [patrón %] normal.o stem=normal
   gcc main.o normal.o debug.o -o app
   ```

4. **Stem más corto.** `test_normal.c` exige `-DTEST`. Con la regla general falla:
   ```bash
   make test_normal.o
   ```
   ```
   test_normal.c:3:2: error: #error "test_normal.c necesita -DTEST"
   ```
   Añade `test_%.o: test_%.c` (con `-DTEST`) **después** de `%.o: %.c` y repite:
   ```
   gcc -Wall -std=c11 -DTEST -c test_normal.c -o test_normal.o
   [patrón test_%] test_normal.o stem=normal
   ```
   Gana aunque esté escrita después: stem `normal` frente a `test_normal`.

5. **Las reglas de serie.** Comenta las tres líneas de tu `%.o: %.c` y fuerza `main.o`:
   ```bash
   make -B main.o
   make -p 2>/dev/null | grep -A2 '^%.o: %.c'
   ```
   ```
   gcc -Wall -std=c11   -c -o main.o main.c
   %.o: %.c
   #  recipe to execute (built-in):
   	$(COMPILE.c) $(OUTPUT_OPTION) $<
   ```
   Sin tu regla, Make usó la suya. Descomenta la regla.

6. **`MAKEFLAGS += -r`.** Pide un target que tu Makefile no define:
   ```bash
   make main
   ```
   ```
   gcc   main.o   -o main
   /usr/bin/ld: main.o: in function `main':
   …undefined reference to `normal_module'
   make: *** [<builtin>: main] Error 1
   ```
   La regla de serie `%: %.o` intentó enlazar un ejecutable que nadie pidió. Añade `MAKEFLAGS += -r` tras el preámbulo y repite:
   ```
   make: *** No rule to make target 'main'.  Stop.
   ```
   Repite el paso 5 con `-r` activo: ahora `make -B main.o` sin tu regla da `No rule to make target 'main.o'`.

7. **Dos recetas explícitas para el mismo target.** Añade al final, temporalmente:
   ```makefile
   SPECIAL := debug.o
   $(SPECIAL): %.o: %.c
   	$(CC) $(CFLAGS) -O2 -c $< -o $@
   	@echo "[static] $@"
   ```
   ```bash
   make -B debug.o
   ```
   ```
   Makefile:<línea>: warning: overriding recipe for target 'debug.o'
   Makefile:<línea>: warning: ignoring old recipe for target 'debug.o'
   gcc -Wall -std=c11 -O2 -c debug.c -o debug.o
   [static] debug.o
   ```
   Ni la explícita ni la static "gana" por tipo: gana la última. Borra el bloque.

8. Inspecciona qué guardó Make para `debug.o`:
   ```bash
   make -p -q 2>/dev/null | grep -A4 '^debug.o:'
   ```
   La última línea dice `recipe to execute (from 'Makefile', line N)`: la receta de tu regla explícita.

## Criterios de éxito

- [ ] `./app` imprime `modulo normal activo` y `DEBUG: modulo debug activo`
- [ ] `touch config.h && make all` recompila `normal.o` con `[patrón %]`
- [ ] `make test_normal.o` imprime `[patrón test_%] test_normal.o stem=normal`
- [ ] Con `MAKEFLAGS += -r`, `make main` falla con `No rule to make target 'main'`
- [ ] Puedes explicar por qué en el paso 7 la static pattern rule anula a la explícita
- [ ] `make clean` elimina objetos y binarios

## Reto extra

Ejecuta `make --debug=i -B test_normal.o 2>&1 | grep -E 'Trying pattern rule|Found an implicit rule'` (sin `-r` y con `-r`) y compara cuántas reglas prueba Make en cada caso.
