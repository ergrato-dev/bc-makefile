# Lab 01 — wildcard

**Duración estimada:** 50 minutos

## Objetivo

Reemplazar una lista de fuentes hardcodeada por `$(wildcard)` para que el Makefile descubra automáticamente cualquier archivo `.c` nuevo en `src/`.

## Contexto

El `starter/Makefile` compila correctamente con una lista manual:

```makefile
SRCS := src/main.c src/calc.c src/io.c
OBJS := build/main.o build/calc.o build/io.o
```

El problema: si alguien agrega `src/logger.c`, la build no lo incluye hasta que alguien edite el Makefile. Con `$(wildcard)` ese problema desaparece.

`$(wildcard src/*.c)` se expande en tiempo de evaluación a todos los archivos `.c` que existen en `src/` en ese momento. Combinado con `$(patsubst)`, la lista de objetos se genera sola.

## Instrucciones

1. Entra al directorio starter:
   ```bash
   cd lab-01-wildcard/starter
   ```

2. Verifica que el Makefile funciona en su estado inicial:
   ```bash
   make list-sources
   make build
   make clean
   ```

3. Abre `Makefile` y localiza las dos variables con lista hardcodeada.

4. Reemplaza `SRCS` por:
   ```makefile
   SRCS := $(wildcard src/*.c)
   ```

5. Reemplaza `OBJS` por la versión generada automáticamente:
   ```makefile
   OBJS := $(patsubst src/%.c,$(BUILD)/%.o,$(SRCS))
   ```

6. Verifica que `make list-sources` y `make build` siguen funcionando.

7. Prueba la resistencia al cambio — crea un nuevo archivo fuente:
   ```bash
   cat > src/logger.c << 'EOF'
   #include <stdio.h>
   void logger_demo(void) { printf("[logger] nuevo modulo\n"); }
   EOF
   make list-sources
   ```
   El nuevo archivo debe aparecer en `SRCS` sin editar el Makefile.

## Criterios de éxito

```
$ make list-sources
SRCS  = src/calc.c src/io.c src/main.c
OBJS  = build/calc.o build/io.o build/main.o
Total = 3 archivos
```

```
$ make build
gcc -Wall -Wextra -std=c11 -c src/calc.c -o build/calc.o
gcc -Wall -Wextra -std=c11 -c src/io.c -o build/io.o
gcc -Wall -Wextra -std=c11 -c src/main.c -o build/main.o
gcc -Wall -Wextra -std=c11 build/calc.o build/io.o build/main.o -o build/programa
Compilado: build/programa
```

Después de agregar `src/logger.c`:
```
$ make list-sources
SRCS  = src/calc.c src/io.c src/logger.c src/main.c
OBJS  = build/calc.o build/io.o build/logger.o build/main.o
Total = 4 archivos
```

## Reto extra

Agrega un target `list-dirs` que muestre los directorios únicos donde están los objetos, usando `$(sort $(dir $(OBJS)))`.
