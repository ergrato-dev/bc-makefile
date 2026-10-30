# Lab 04 — Static pattern rules: restringir el patrón

⏱ Duración estimada: ~50 min

## Objetivo

Usar static pattern rules para aplicar una regla de patrón únicamente a un subconjunto específico de targets, separando módulos de librería de módulos de aplicación.

## Contexto

Una static pattern rule tiene esta forma:

```makefile
$(LISTA_TARGETS): patrón-target: patrón-prerrequisito
	receta
```

La diferencia con una regla de patrón genérica es que solo aplica a los targets listados en `$(LISTA_TARGETS)`. Esto es útil cuando:

- Tienes módulos en diferentes directorios que se compilan con opciones distintas
- Quieres compilar un subconjunto con flags especiales (p.ej. `-DTEST`)
- Necesitas que una regla no "escape" a targets que accidentalmente coincidan con el patrón

```makefile
LIB_SRCS  := src/math.c src/string_ops.c
APP_SRCS  := src/main.c

LIB_OBJS  := $(LIB_SRCS:src/%.c=build/lib/%.o)
APP_OBJS  := $(APP_SRCS:src/%.c=build/main/%.o)

# Módulos de librería: compilados con -DLIB
$(LIB_OBJS): build/lib/%.o: src/%.c
	@mkdir -p $(@D)
	$(CC) $(CFLAGS) -DLIB -c $< -o $@

# Módulos de aplicación: compilados sin -DLIB
$(APP_OBJS): build/app/%.o: src/%.c
	@mkdir -p $(@D)
	$(CC) $(CFLAGS) -c $< -o $@
```

## Instrucciones

1. Abre `starter/`. Los archivos `src/main.c`, `src/math.c` y `src/string_ops.c` están disponibles.

2. Define las listas separadas de objetos:
   ```makefile
   LIB_SRCS := src/math.c src/string_ops.c
   APP_SRCS := src/main.c
   LIB_OBJS := $(LIB_SRCS:src/%.c=build/lib/%.o)
   APP_OBJS := $(APP_SRCS:src/%.c=build/app/%.o)
   ```

3. Escribe la static pattern rule para `LIB_OBJS`:
   ```makefile
   $(LIB_OBJS): build/lib/%.o: src/%.c
   	@mkdir -p $(@D)
   	$(CC) $(CFLAGS) -I include -c $< -o $@
   ```

4. Escribe la static pattern rule para `APP_OBJS`:
   ```makefile
   $(APP_OBJS): build/main/%.o: src/%.c
   	@mkdir -p $(@D)
   	$(CC) $(CFLAGS) -I include -c $< -o $@
   ```

5. Completa el target `$(APP)` para enlazar ambos grupos de objetos.

6. Verifica:
   ```bash
   make all
   ls build/lib/    # math.o, string_ops.o
   ls build/app/    # main.o
   ./build/app
   ```

## Criterios de éxito

- [ ] `make all` produce `build/lib/math.o`, `build/lib/string_ops.o` y `build/app/main.o`
- [ ] `./build/calculator` imprime:
  ```
  suma(3, 4) = 7
  producto(3, 4) = 12
  uppercase: HOLA
  ```
- [ ] Los objetos de librería están en `build/lib/` y los de aplicación en `build/main/`
- [ ] Una regla de patrón genérica `%.o: %.c` NO existe en el Makefile; se usan static pattern rules
- [ ] `make clean` elimina `build/` completo

## Reto extra

Agrega un grupo `TEST_SRCS := tests/test_math.c tests/test_string.c` con su propia static pattern rule que compile a `build/test/%.o` con el flag `-DTEST`. Crea un target `test-build` que enlace los objetos de test junto con los de librería en `build/test_runner`.
