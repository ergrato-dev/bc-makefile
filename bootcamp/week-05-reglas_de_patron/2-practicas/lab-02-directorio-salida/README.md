# Lab 02 — `build/%.o: src/%.c`: patrón con directorio de salida

⏱ Duración estimada: ~50 min

## Objetivo

Usar una regla de patrón con prefijo de directorio para separar los archivos fuente en `src/` de los objetos compilados en `build/`, creando el directorio de salida de forma automática.

## Contexto

La regla `%.o: %.c` funciona cuando fuentes y objetos conviven en el mismo directorio. En proyectos reales se separan:

```
src/main.c  →  build/main.o
src/utils.c →  build/utils.o
```

El patrón que resuelve esto es:

```makefile
build/%.o: src/%.c
	@mkdir -p $(@D)
	$(CC) $(CFLAGS) -c $< -o $@
```

- El stem `%` captura `main`, `utils`, etc.
- `$<` resuelve a `src/main.c` (el prerrequisito completo)
- `$@` resuelve a `build/main.o` (el target completo)
- `$(@D)` resuelve a `build` (el directorio del target)

El `mkdir -p $(@D)` garantiza que `build/` exista antes de que gcc intente escribir ahí.

## Instrucciones

1. Abre `starter/`. Los archivos `src/main.c`, `src/utils.c` e `include/utils.h` ya están disponibles.

2. En `starter/Makefile`, define las variables de rutas:
   ```makefile
   SRC_DIR   := src
   BUILD_DIR := build
   INC_DIR   := include
   SRCS      := $(SRC_DIR)/main.c $(SRC_DIR)/utils.c
   OBJS      := $(SRCS:$(SRC_DIR)/%.c=$(BUILD_DIR)/%.o)
   ```

3. Escribe la regla de patrón con prefijo de directorio:
   ```makefile
   $(BUILD_DIR)/%.o: $(SRC_DIR)/%.c
   	@mkdir -p $(@D)
   	$(CC) $(CFLAGS) -I$(INC_DIR) -c $< -o $@
   ```

4. Completa el target `$(APP)` para enlazar desde `$(BUILD_DIR)/`:
   ```makefile
   $(APP): $(OBJS)
   	$(CC) $^ -o $@
   ```

5. Verifica:
   ```bash
   make all
   ls build/        # debe mostrar main.o, utils.o, app
   ./build/app
   make clean
   ls build/ 2>/dev/null || echo "build/ eliminado correctamente"
   ```

6. Borra manualmente `build/` y ejecuta `make build/utils.o` para compilar un solo objeto.

## Criterios de éxito

- [ ] `make all` crea `build/main.o`, `build/utils.o` y `build/app`
- [ ] `./build/app` imprime:
  ```
  add(10, 5) = 15
  uppercase: HOLA MAKE
  ```
- [ ] El Makefile no usa `mkdir build` sin `-p`; usa `$(@D)` en el mkdir
- [ ] `make clean` elimina el directorio `build/` completo
- [ ] Agregar un nuevo `.c` en `src/` y actualizar `SRCS` es suficiente para incluirlo en el build

## Reto extra

Usa `$(wildcard $(SRC_DIR)/*.c)` para que `SRCS` se rellene automáticamente sin listar archivos. Agrega `src/extra.c` con una función nueva, modifica `main.c` para llamarla, y verifica que `make all` la compila sin cambiar el Makefile.
