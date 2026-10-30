# Lab 01 — Anatomía del `.d`

⏱ Duración estimada: ~60 min

## Objetivo

Hacer que un build C se recompile exactamente cuando cambian sus headers, sus flags o su Makefile, usando `-MMD -MP`, un stamp de flags y `.EXTRA_PREREQS`.

## Contexto

- El starter compila bien, pero solo sabe que `build/main.o` depende de `src/main.c`. Cambiar un header, las flags o el propio Makefile no recompila nada.
- Vas a leer los `.d` que escribe gcc, a provocar el error que evita `-MP` y a cubrir las dos dependencias que el compilador no puede ver: las flags y el Makefile.
- Teoría: [01-dependencias-automaticas.md](../../1-teoria/01-dependencias-automaticas.md).

## Instrucciones

Trabaja dentro de `starter/`.

1. **El problema.** Compila, toca un header y vuelve a compilar:
   ```bash
   make all
   make run
   touch include/calc.h
   make all
   ```
   Debes ver `suma(2, 3) = 5` y, tras el `touch`:
   ```
   make: Nothing to be done for 'all'.
   ```
   `main.o` y `calc.o` incluyen `calc.h`, pero Make no lo sabe.

2. **`-MMD`.** Completa los TODO del paso 2: `DEPFLAGS := -MMD`, `DEPS := $(OBJS:.o=.d)`,
   `-include $(DEPS)` al final y `$(DEPFLAGS)` en la receta de compilación. Después:
   ```bash
   make all
   ```
   Debes ver `Nothing to be done`: los `.d` solo se escriben **al compilar**, y los
   objetos ya estaban al día. Reconstruye y lee el resultado:
   ```bash
   make clean && make all
   cat build/main.d
   ```
   ```
   build/main.o: src/main.c include/calc.h include/legacy.h
   ```
   Ahora `touch include/calc.h && make all` recompila `calc.o` y `main.o`, y
   `touch include/legacy.h && make all` recompila solo `main.o`.

3. **Qué headers entran.** Compara las dos variantes de gcc:
   ```bash
   gcc -MM -Iinclude src/main.c
   gcc -M -Iinclude src/main.c | wc -l
   ```
   `-MM` (y `-MMD`) lista solo los headers del proyecto. `-M` incluye `stdio.h` y
   decenas de headers del sistema que no vas a cambiar nunca.

4. **El header borrado.** `legacy.h` ya no se usa. Borra la línea
   `#include "legacy.h"` de `src/main.c` y elimina el archivo:
   ```bash
   rm include/legacy.h
   make all
   ```
   ```
   make: *** No rule to make target 'include/legacy.h', needed by 'build/main.o'.  Stop.
   ```
   Make lee el `.d` viejo antes de compilar nada, y ese `.d` dice que `main.o`
   necesita `legacy.h`.

   a. Añade `-MP` a `DEPFLAGS` y repite `make all`. **Sigue fallando**: el `.d` viejo no
      tiene las reglas vacías; solo una compilación nueva las escribe.

   b. Desbloquéalo con un header vacío temporal y bórralo después:
      ```bash
      touch include/legacy.h && make all && rm include/legacy.h
      cat build/main.d
      ```
      ```
      build/main.o: src/main.c include/calc.h
      include/calc.h:
      ```
      La segunda línea es `-MP`: una regla vacía para cada header.

   c. Comprueba que ahora borrar un header ya no rompe nada. Recupera los originales,
      compila y repite el borrado:
      ```bash
      git restore src/main.c include/legacy.h
      make all && cat build/main.d
      ```
      Debe aparecer `include/legacy.h:` en su propia línea. Borra otra vez el
      `#include` y el archivo, y `make all` recompila `main.o` sin error.

5. **`CPPFLAGS` frente a `CFLAGS`.** Compila con otra optimización:
   ```bash
   make -B all CFLAGS=-O2
   ```
   ```
   src/calc.c:1:10: fatal error: calc.h: No such file or directory
   ```
   `-Iinclude` estaba dentro de `CFLAGS` y la línea de comandos lo pisó. Muévelo a
   `CPPFLAGS := -Iinclude`, añade `$(CPPFLAGS)` a la receta y repite: compila.

6. **Stamp de flags.** Ejecuta `make all` y después `make all CFLAGS=-O2`: no
   recompila nada, aunque el binario debería cambiar. Completa los TODO del paso 6
   (variable `FLAGS_STAMP`, regla del stamp con `FORCE` y `cmp -s`, y el stamp como
   prerrequisito **detrás** del `.c`). Comprueba:
   ```bash
   make all CFLAGS=-O2     # recompila calc.o y main.o, y enlaza
   make all CFLAGS=-O2     # no imprime nada
   cat build/compile-flags.txt
   make all                # vuelve a recompilar los dos
   ```
   ```
   gcc -Iinclude -O2
   ```

7. **El Makefile también es una dependencia.** Añade
   `$(OBJS): .EXTRA_PREREQS := Makefile` y comprueba:
   ```bash
   make all                 # recompila: el Makefile es más nuevo que los objetos
   touch Makefile && make all   # recompila otra vez
   make all                 # no imprime nada
   ```
   `.EXTRA_PREREQS` no aparece en `$^`: el enlace no recibe `Makefile` como argumento.

## Criterios de éxito

- [ ] `cat build/main.d` muestra los headers de `main.c` y una línea `header:` por cada uno
- [ ] `touch include/calc.h && make all` recompila exactamente `calc.o` y `main.o`
- [ ] Borrar un `#include` y su header no produce `No rule to make target`
- [ ] `make -B all CFLAGS=-O2` compila sin error (`-Iinclude` está en `CPPFLAGS`)
- [ ] `make all CFLAGS=-O2` recompila los dos objetos; repetirlo no hace nada
- [ ] `touch Makefile && make all` recompila los objetos
- [ ] `make clean` deja `starter/` sin `build/`

## Reto extra

Añade `-MT '$@ $(@:.o=.d)'` a `DEPFLAGS` y mira el `.d` resultante. ¿Qué cambia en la
primera línea? Explica en un comentario por qué algunos proyectos hacen que el propio
`.d` dependa de los headers, y por qué con `-MMD` (que regenera el `.d` en cada
compilación) no hace falta.
