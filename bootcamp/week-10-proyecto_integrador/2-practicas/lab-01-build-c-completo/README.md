# Lab 01 — Build System C Completo con Dependencias Automáticas

**Duración estimada:** 50 min

## Objetivo

Construir un build system para un proyecto C multi-archivo que use pattern rules, variables automáticas y dependencias automáticas generadas por `gcc -MMD`, de modo que solo los archivos modificados se recompilen.

## Contexto

Un proyecto C real tiene decenas de `.c` y `.h`. Sin dependencias automáticas, cambiar un header obliga a recompilar todo manualmente. Con `gcc -MMD -MP` Make genera archivos `.d` que describen qué `.c` depende de qué `.h`. Incluyendo esos archivos con `-include`, el grafo de dependencias es siempre correcto.

Las piezas que se integran aquí:
- Pattern rule `%.o: %.c` con `$<` y `$@` (semana 04)
- `$(wildcard ...)` para descubrir fuentes (semana 05)
- `$(patsubst ...)` para calcular objetos (semana 05)
- `-include $(DEPS)` para dependencias de headers (técnica pro)

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
   make all          # primera vez: compila todo
   make all          # segunda vez: Nothing to be done
   touch src/utils.c
   make all          # solo recompila utils.o
   ```

7. Verifica clean:
   ```bash
   make clean && ls build/
   # build/ debe estar vacío o eliminado
   ```

## Criterios de éxito

- [ ] `make info` lista los archivos `.c` y `.o` calculados por Make
- [ ] `make all` compila y enlaza sin errores → `build/app` existe
- [ ] `make all` segunda vez → `make: Nothing to be done for 'all'`
- [ ] `touch src/math_utils.c && make all` → solo recompila `math_utils.o`
- [ ] Cambiar `include/config.h` → recompila todos los `.o` que lo incluyen
- [ ] `make clean` elimina `build/`

## Reto extra

Agrega un target `run` que ejecute `build/app` y un target `memcheck` que corra `valgrind build/app` si `valgrind` está instalado; si no, imprime `valgrind no disponible` sin fallar.
