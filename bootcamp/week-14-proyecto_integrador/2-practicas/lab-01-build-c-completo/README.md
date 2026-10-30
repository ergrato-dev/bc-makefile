# Lab 01 — Build System C Completo con Dependencias Automáticas

⏱ Duración estimada: ~60 min

## Objetivo

Construir un build system para un proyecto C multi-archivo que use pattern rules, variables automáticas y dependencias automáticas generadas por `gcc -MMD`, de modo que solo los archivos modificados se recompilen.

## Contexto

Un proyecto C real tiene decenas de `.c` y `.h`. Sin dependencias automáticas, cambiar un header obliga a recompilar todo manualmente. Con `gcc -MMD -MP` Make genera archivos `.d` que describen qué `.c` depende de qué `.h`. Incluyendo esos archivos con `-include`, el grafo de dependencias es siempre correcto.

Las piezas que se integran aquí:
- Pattern rule `$(BUILD_DIR)/%.o: $(SRC_DIR)/%.c` con `$<` y `$@` (semanas 04 y 05)
- `$(wildcard ...)` y `$(patsubst ...)` para descubrir fuentes y calcular objetos (semana 07)
- `-MMD -MP` + `-include $(DEPS)` y el directorio de salida como prerrequisito order-only (semana 06)
- `make -j` sin carreras porque cada dependencia está declarada (semana 10)

## Instrucciones

1. Copia el starter:
   ```bash
   cp -r starter/ mi-lab-01 && cd mi-lab-01
   ```

2. Explora la estructura del proyecto:
   ```bash
   find . -type f | sort
   ```

3. Implementa las variables que calculan fuentes y objetos automáticamente:
   ```bash
   make info
   # Debe listar todos los .c encontrados y los .o correspondientes
   ```

4. Implementa la pattern rule `%.o: %.c` con generación de dependencias:
   ```bash
   make build/main.o
   # Debe crear build/main.o y build/main.d
   ```

5. Implementa el target `all` que compila el ejecutable final:
   ```bash
   make all
   # Debe imprimir: Enlazando build/app ...
   # Debe crear: build/app
   ```

6. Verifica la recompilación inteligente:
   ```bash
   make all                  # primera vez: compila todo
   make all                  # make: Nothing to be done for 'all'.
   touch src/math_utils.c
   make all                  # solo "Compilando src/math_utils.c ..." y el enlace
   touch include/config.h
   make all                  # solo main.o: es el único .c que incluye config.h
   cat build/main.d          # la regla que generó -MMD
   ```

7. Comprueba qué aporta `-MP`. Añade un header, úsalo y compila:
   ```bash
   printf '#define GREETING "hola"\n' > include/extra.h
   sed -i '1i #include "extra.h"' src/main.c      # macOS: usa un editor
   make all
   ```
   Ahora deja de usarlo y bórralo, como en cualquier refactor:
   ```bash
   sed -i '/extra.h/d' src/main.c && rm include/extra.h
   make all; echo "exit=$?"
   ```
   Con `-MMD -MP` recompila `main.o` y sale con 0. Repite los dos bloques
   quitando `-MP` de la regla: el segundo `make all` falla con
   `No rule to make target 'include/extra.h', needed by 'build/main.o'`.
   `-MP` añade una regla vacía por header, así que un header borrado deja de
   ser un error. Vuelve a poner `-MP`.

8. Compila en paralelo desde cero, varias veces:
   ```bash
   make clean && make -j4 all
   ```
   Debe funcionar siempre: `build/` es prerrequisito *order-only*
   (`| $(BUILD_DIR)`), así que se crea antes que cualquier objeto pero su
   fecha no fuerza recompilaciones.

9. Verifica clean y su guarda:
   ```bash
   make clean && ls build/          # No such file or directory
   make clean BUILD_DIR=; echo "exit=$?"   # BUILD_DIR vacía: rm -rf no se ejecuta ... exit=2
   ```

## Criterios de éxito

- [ ] `make info` lista los archivos `.c` y `.o` calculados por Make
- [ ] `make all` compila y enlaza sin errores → `build/app` existe
- [ ] `make all` segunda vez → `make: Nothing to be done for 'all'`
- [ ] `touch src/math_utils.c && make all` → solo recompila `math_utils.o`
- [ ] `touch include/config.h && make all` → recompila solo `main.o`
- [ ] Borrar un header que ya no se incluye no rompe el build (`-MP`)
- [ ] `make clean && make -j4 all` funciona siempre
- [ ] `make clean` elimina `build/` y `make clean BUILD_DIR=` se niega a borrar

## Reto extra

Agrega un target `run` que ejecute `build/app` y un target `memcheck` que corra `valgrind build/app` si `valgrind` está instalado; si no, imprime `valgrind no disponible` sin fallar.
