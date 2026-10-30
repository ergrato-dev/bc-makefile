# Lab 04 — Static pattern rules: restringir el patrón

⏱ Duración estimada: ~60 min

## Objetivo

Aplicar static pattern rules para compilar dos grupos de objetos con flags distintos, empaquetar uno de ellos en una librería estática y comprobar que el patrón no se escapa a otros targets.

## Contexto

Una static pattern rule tiene tres partes: `LISTA: patrón-target: patrón-prerrequisito`. A diferencia de `%.o: %.c`, no es una plantilla que Make consulta para cualquier nombre: genera una regla explícita por cada target de `LISTA`, y solo para ellos.

Úsala cuando grupos de archivos necesitan recetas distintas (aquí, `-fPIC` solo para la librería) o cuando quieres que un target que no está en la lista falle en lugar de compilarse con la regla equivocada.

## Instrucciones

1. Entra en `starter/`. Están `src/main.c`, `src/math_ops.c`, `src/string_ops.c` y sus headers en `include/`. `make` muestra la ayuda.

2. Define las dos listas de objetos:
   ```makefile
   LIB_OBJS := $(LIB_SRCS:src/%.c=$(BUILD)/lib/%.o)
   APP_OBJS := $(APP_SRCS:src/%.c=$(BUILD)/main/%.o)
   ```

3. Escribe la static pattern rule de la librería, con `-fPIC`:
   ```makefile
   $(LIB_OBJS): $(BUILD)/lib/%.o: src/%.c
   	@mkdir -p $(@D)
   	$(CC) $(CFLAGS) $(LIB_CFLAGS) -I$(INC_DIR) -c $< -o $@
   ```

4. Escribe la de la aplicación (`$(APP_OBJS): $(BUILD)/main/%.o: src/%.c`), igual pero **sin** `$(LIB_CFLAGS)`.

5. Da receta a la librería (`$(AR) rcs $@ $^`) y al binario (`$(CC) $^ -o $@`). Compila y ejecuta:
   ```bash
   make all && ./build/calculator
   ```
   ```
   gcc -Wall -std=c11 -Iinclude -c src/main.c -o build/main/main.o
   gcc -Wall -std=c11 -fPIC -Iinclude -c src/math_ops.c -o build/lib/math_ops.o
   gcc -Wall -std=c11 -fPIC -Iinclude -c src/string_ops.c -o build/lib/string_ops.o
   ar rcs build/libops.a build/lib/math_ops.o build/lib/string_ops.o
   gcc build/main/main.o build/libops.a -o build/calculator
   suma(3, 4) = 7
   producto(3, 4) = 12
   uppercase: HOLA
   ```

6. Cuenta cuántas compilaciones llevan `-fPIC` sin ejecutar nada:
   ```bash
   make -B -n all | grep -c -- -fPIC
   ```
   ```
   2
   ```

7. Comprueba que el patrón no se escapa. Existen `src/main.c` y `src/math_ops.c`, pero ninguno está en la lista equivocada:
   ```bash
   make build/lib/main.o
   make build/main/math_ops.o
   ```
   ```
   make: *** No rule to make target 'build/lib/main.o'.  Stop.
   make: *** No rule to make target 'build/main/math_ops.o'.  Stop.
   ```
   Con dos reglas de patrón (`build/lib/%.o: src/%.c` y `build/main/%.o: src/%.c`) los dos comandos habrían compilado.

8. Rompe la lista a propósito. Añade debajo de `LIB_OBJS` la línea `LIB_OBJS += $(BUILD)/other/x.o` y ejecuta `make -n all`:
   ```
   Makefile:<línea>: target 'build/other/x.o' doesn't match the target pattern
   …
   gcc -Wall -std=c11 -fPIC -Iinclude -c  -o build/other/x.o
   ```
   Es solo un aviso: Make sigue con `$<` vacío y el `gcc` real fallaría con `no input files`. Lee los avisos. Quita la línea.

## Criterios de éxito

- [ ] `make all` produce `build/lib/math_ops.o`, `build/lib/string_ops.o`, `build/main/main.o` y `build/libops.a`
- [ ] `./build/calculator` imprime `suma(3, 4) = 7`, `producto(3, 4) = 12` y `uppercase: HOLA`
- [ ] `make -B -n all | grep -c -- -fPIC` imprime `2`
- [ ] `make build/lib/main.o` falla con `No rule to make target`
- [ ] El Makefile no tiene ninguna regla de patrón genérica `%.o: %.c`
- [ ] `make clean` elimina `build/`; con `BUILD=` se niega

## Reto extra

Agrega `TEST_SRCS := tests/test_math.c` (créalo con un `main` que compruebe `sum(2, 2) == 4` y devuelva 1 si falla) con su static pattern rule hacia `build/test/%.o` y el flag `-DTEST`. Crea un target `test` que enlace el objeto de test con `build/libops.a` y lo ejecute.
