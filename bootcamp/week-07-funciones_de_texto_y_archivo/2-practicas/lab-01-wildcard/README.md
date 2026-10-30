# Lab 01 — wildcard

⏱ Duración estimada: ~60 min

## Objetivo

Reemplazar una lista de fuentes hardcodeada por `$(wildcard)` para que el Makefile descubra automáticamente cualquier archivo `.c` nuevo en `src/` y falle con un mensaje claro si no encuentra ninguno.

## Contexto

El `starter/Makefile` compila con una lista manual (`SRCS := src/main.c src/calc.c src/io.c`). Si alguien agrega `src/logger.c`, la build no lo incluye hasta que alguien edite el Makefile.

`$(wildcard $(SRC_DIR)/*.c)` se expande al leer el Makefile y devuelve los `.c` que existen en ese momento. Desde Make 4.3 el resultado sale ordenado; entre 3.82 y 4.2 no lo estaba, así que si necesitas un orden estable en cualquier versión, envuélvelo en `$(sort ...)`.

Un patrón que no casa con nada no es un error: `$(wildcard)` devuelve una cadena vacía en silencio. Esa es la trampa que cierras en el paso 7.

## Instrucciones

1. Entra al starter y comprueba el estado inicial:
   ```bash
   cd lab-01-wildcard/starter
   make list-sources
   make build
   make clean
   ```
   El orden de `SRCS` es el de la lista escrita a mano: `src/main.c src/calc.c src/io.c`.

2. Abre `Makefile` y localiza `SRCS` y `OBJS`, las dos listas escritas a mano.

3. Antes de tocar nada, cuenta cuántas líneas tendrías que editar para añadir un módulo nuevo (respuesta: dos, y en dos sitios distintos).

4. Añade el preámbulo estricto y reemplaza `SRCS`:
   ```makefile
   SRCS := $(wildcard $(SRC_DIR)/*.c)
   ```

5. Reemplaza `OBJS` por la versión derivada:
   ```makefile
   OBJS := $(patsubst $(SRC_DIR)/%.c,$(BUILD)/%.o,$(SRCS))
   ```

6. Verifica que todo sigue funcionando:
   ```bash
   make list-sources
   make build
   ```
   Ahora las fuentes salen en orden alfabético (`calc`, `io`, `main`): las ordena `$(wildcard)`, no tú.

7. **Guarda contra la lista vacía.** Como primera línea de la receta de `list-sources` y de `$(TARGET)`, añade:
   ```makefile
   	$(if $(SRCS),,$(error No hay fuentes .c en $(SRC_DIR)/))
   ```
   Prueba con un directorio que no existe:
   ```bash
   make list-sources SRC_DIR=vacio
   ```
   Debes ver (el número de línea puede variar):
   ```
   Makefile:27: *** No hay fuentes .c en vacio/.  Stop.
   ```
   Sin la guarda, `SRCS` vacía no da error: `make build` desde cero acabaría llamando a `gcc` sin archivos de entrada (`gcc: fatal error: no input files`).

8. **`$(wildcard)` como prueba de existencia.** Con un solo nombre, `$(wildcard)` devuelve ese nombre si el archivo existe o vacío si no. Añade:
   ```makefile
   LOGGER := $(wildcard $(SRC_DIR)/logger.c)
   ```
   y en `list-sources` la línea:
   ```makefile
   	@echo "Logger = $(if $(LOGGER),presente,ausente)"
   ```
   `make list-sources` debe terminar con `Logger = ausente`.

9. Prueba la resistencia al cambio. Crea un módulo nuevo:
   ```bash
   cat > src/logger.c << 'EOF'
   #include <stdio.h>
   void logger_demo(void) { printf("[logger] nuevo modulo\n"); }
   EOF
   make list-sources
   make build
   ```
   El nuevo archivo aparece en `SRCS`, se compila, y `Logger = presente`, sin editar el Makefile. Al terminar, `rm src/logger.c && make clean`.

## Criterios de éxito

- [ ] `make list-sources` (pasos 6–8) imprime:
  ```
  SRCS   = src/calc.c src/io.c src/main.c
  OBJS   = build/calc.o build/io.o build/main.o
  Total  = 3 archivos
  Logger = ausente
  ```
- [ ] `make build` imprime:
  ```
  gcc -Wall -Wextra -std=c11 -c src/calc.c -o build/calc.o
  gcc -Wall -Wextra -std=c11 -c src/io.c -o build/io.o
  gcc -Wall -Wextra -std=c11 -c src/main.c -o build/main.o
  gcc -Wall -Wextra -std=c11 build/calc.o build/io.o build/main.o -o build/programa
  Compilado: build/programa
  ```
- [ ] `make list-sources SRC_DIR=vacio` termina con `*** No hay fuentes .c en vacio/.  Stop.` y código de salida distinto de 0
- [ ] Con `src/logger.c` creado, `make list-sources` imprime:
  ```
  SRCS   = src/calc.c src/io.c src/logger.c src/main.c
  OBJS   = build/calc.o build/io.o build/logger.o build/main.o
  Total  = 4 archivos
  Logger = presente
  ```
- [ ] `make clean` elimina `build/` sin error

## Reto extra

Agrega un target `list-dirs` que muestre los directorios únicos donde están los objetos, usando `$(sort $(dir $(OBJS)))`. Debe imprimir `Dirs  = build/`.
