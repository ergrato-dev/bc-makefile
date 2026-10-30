# Lab 02 — `build/%.o: src/%.c`: patrón con directorio de salida

⏱ Duración estimada: ~60 min

## Objetivo

Separar fuentes (`src/`) y objetos (`build/`) con una regla de patrón con prefijo de directorio que cree el directorio de salida y funcione a cualquier profundidad.

## Contexto

En proyectos reales fuentes y objetos viven separados: `src/main.c → build/main.o`. El patrón `build/%.o: src/%.c` lo resuelve: el stem `%` es lo que queda al quitar el prefijo y el sufijo, `$<` es `src/main.c`, `$@` es `build/main.o` y `$(@D)` es `build`.

El stem puede contener barras. Para `build/net/ping.o` el stem es `net/ping` y el prerrequisito, `src/net/ping.c`. Por eso `mkdir -p $(@D)` es obligatorio: el compilador no crea directorios.

## Instrucciones

1. Entra en `starter/`. `src/main.c`, `src/utils.c` e `include/utils.h` ya existen. `make` muestra la ayuda.

2. Define `OBJS` con una sustitución con patrón:
   ```makefile
   OBJS := $(SRCS:$(SRC_DIR)/%.c=$(BUILD_DIR)/%.o)
   ```

3. Escribe la regla de patrón con prefijo de directorio:
   ```makefile
   $(BUILD_DIR)/%.o: $(SRC_DIR)/%.c
   	@mkdir -p $(@D)
   	@echo "[cc] stem=$* dir=$(@D)"
   	$(CC) $(CFLAGS) -I$(INC_DIR) -c $< -o $@
   ```

4. Da receta a `$(APP)` (`$(CC) $^ -o $@`) y compila:
   ```bash
   make all && ls build && ./build/app
   ```
   ```
   [cc] stem=main dir=build
   gcc -Wall -std=c11 -Iinclude -c src/main.c -o build/main.o
   [cc] stem=utils dir=build
   gcc -Wall -std=c11 -Iinclude -c src/utils.c -o build/utils.o
   gcc build/main.o build/utils.o -o build/app
   app
   main.o
   utils.o
   add(10, 5) = 15
   uppercase: HOLA MAKE
   ```

5. Limpia y compila un solo objeto: la regla sirve también cuando pides un target concreto.
   ```bash
   make clean && make build/utils.o
   ```
   ```
   rm -rf -- 'build'
   [cc] stem=utils dir=build
   gcc -Wall -std=c11 -Iinclude -c src/utils.c -o build/utils.o
   ```

6. Comprueba por qué hace falta el `mkdir`: comenta la línea `@mkdir -p $(@D)`, ejecuta `make clean && make all` y lee el error.
   ```
   Assembler messages:
   Fatal error: can't create build/main.o: No such file or directory
   make: *** [Makefile:<línea>: build/main.o] Error 1
   ```
   Vuelve a activar la línea.

7. Stem con subdirectorio: crea un módulo en `src/net/` y pídele a Make su objeto sin tocar el Makefile.
   ```bash
   mkdir -p src/net && printf 'int ping(void) { return 1; }\n' > src/net/ping.c
   make build/net/ping.o
   ```
   ```
   [cc] stem=net/ping dir=build/net
   gcc -Wall -std=c11 -Iinclude -c src/net/ping.c -o build/net/ping.o
   ```
   Borra `src/net/` al terminar.

8. Comprueba la guarda de `clean`: con la variable vacía no debe borrar nada.
   ```bash
   make clean BUILD_DIR=
   ```
   ```
   Makefile:<línea>: *** BUILD_DIR vacía: rm -rf no se ejecuta.  Stop.
   ```

## Criterios de éxito

- [ ] `make all` crea `build/main.o`, `build/utils.o` y `build/app`
- [ ] `./build/app` imprime `add(10, 5) = 15` y `uppercase: HOLA MAKE`
- [ ] El `mkdir -p` usa `$(@D)`, no un nombre de directorio fijo
- [ ] `make build/net/ping.o` imprime `stem=net/ping dir=build/net` sin cambiar el Makefile
- [ ] `make clean` elimina `build/`; `make clean BUILD_DIR=` se niega con `BUILD_DIR vacía`

## Reto extra

Usa `$(wildcard $(SRC_DIR)/*.c)` para rellenar `SRCS`. Agrega `src/extra.c` con una función nueva, llámala desde `main.c` y verifica que `make all` la compila sin cambiar el Makefile. ¿Por qué `src/net/ping.c` no entra en esa lista? (Pista: `wildcard` no baja a subdirectorios.)
