# Lab 05 — combinadas

⏱ Duración estimada: ~60 min

## Objetivo

Construir un build system completo que combine `$(wildcard)`, `$(patsubst)`, `$(sort)`, `$(dir)`, `$(addprefix)`, `$(basename)`, `$(notdir)` y `$(filter-out)` para compilar un proyecto C con subdirectorios sin ninguna lista hardcodeada.

## Contexto

El starter tiene 4 fuentes en `src/` y un Makefile incompleto. Aquí no hay listas predefinidas: `$(wildcard)` descubre y el resto de funciones transforma.

```
$(wildcard)          → SRCS     (archivos reales en disco)
$(patsubst)          → OBJS     (rutas de objetos)
$(sort $(dir))       → OBJ_DIRS (directorios únicos a crear)
$(addprefix -I,)     → INCS     (flags de include)
$(filter-out $(notdir $(basename))) → MODULES (nombres para mostrar)
```

`OBJ_DIRS` no es decorativa: en el paso 10 se convierte en el prerrequisito order-only que crea cada directorio de salida una sola vez, en lugar de un `mkdir -p` por objeto.

## Instrucciones

1. Entra al starter y añade el preámbulo estricto:
   ```bash
   cd lab-05-combinadas/starter
   ```

2. Ejecuta `make info`. Todas las variables están vacías.

3. Completa `SRCS` con `$(wildcard src/*.c)`.

4. Completa `OBJS` con `$(patsubst src/%.c,$(BUILD)/%.o,$(SRCS))`.

5. Completa `OBJ_DIRS` con `$(sort $(dir $(OBJS)))`.

6. Completa `INCS` con `$(addprefix -I,include)`.

7. En `$(TARGET)`, agrega `$(OBJS)` como prerrequisito y la receta de enlazado:
   ```makefile
   $(TARGET): $(OBJS)
   	$(CC) $(CFLAGS) $^ -o $@
   	@echo "Compilado: $@"
   ```

8. Verifica:
   ```bash
   make info
   make all
   ./build/pipeline
   make all        # debe decir: Nothing to be done for 'all'.
   ```

9. Agrega un módulo sin tocar el Makefile:
   ```bash
   cat > src/reporter.c << 'EOF'
   #include <stdio.h>
   void reporter_run(void) { printf("[reporter] reporte generado\n"); }
   EOF
   make all
   ```
   Solo se compila `reporter.o` y se vuelve a enlazar. Bórralo después: `rm src/reporter.c && make clean`.

10. **Subdirectorios y directorios de salida.** Crea una fuente en un subdirectorio:
    ```bash
    mkdir -p src/net
    printf '#include <stdio.h>\nvoid http_run(void) { printf("[http] ok\\n"); }\n' > src/net/http.c
    make all
    ```
    No se compila: `src/*.c` no baja a `src/net/`. Amplía el descubrimiento con un segundo patrón:
    ```makefile
    SRCS := $(wildcard src/*.c src/*/*.c)
    ```
    Ahora `make all` falla en `gcc ... -o build/net/http.o` porque `build/net/` no existe: el `mkdir -p $(BUILD)` del starter solo crea `build/`. Sustitúyelo usando `OBJ_DIRS`. Borra el `@mkdir -p $(BUILD)` de la regla de patrón y añade:
    ```makefile
    $(OBJS): | $(OBJ_DIRS)

    $(OBJ_DIRS):
    	mkdir -p $@
    ```
    `make info` debe mostrar `OBJ_DIRS: build/ build/net/` y `make all` debe ejecutar `mkdir -p build/net/` antes de compilar `http.c`.

11. **Nombres para mostrar.** Completa `MODULES` con los nombres sin ruta ni extensión, quitando `main`:
    ```makefile
    MODULES := $(filter-out main,$(notdir $(basename $(SRCS))))
    ```
    Con `src/net/http.c` presente, `make info` termina con `MODULES:  formatter parser validator http`. Al terminar: `rm -r src/net && make clean`.

## Criterios de éxito

- [ ] `make info` (sin `src/net/`) imprime:
  ```
  SRCS:     src/formatter.c src/main.c src/parser.c src/validator.c
  OBJS:     build/formatter.o build/main.o build/parser.o build/validator.o
  OBJ_DIRS: build/
  INCS:     -Iinclude
  MODULES:  formatter parser validator
  ```
- [ ] `./build/pipeline` imprime:
  ```
  === Pipeline de procesamiento ===
  [parser]    analizando entrada
  [formatter] formateando salida
  [validator] validando datos
  ```
- [ ] Una segunda ejecución de `make all` imprime `Nothing to be done for 'all'.`
- [ ] Con `src/net/http.c`, `make info` muestra `OBJ_DIRS: build/ build/net/` y `make all` compila `build/net/http.o` sin editar el Makefile más allá del paso 10
- [ ] Ninguna receta de compilación contiene `mkdir`: los directorios los crea la regla de `$(OBJ_DIRS)`

## Reto extra

Agrega un target `count` que muestre el número de fuentes encontradas (`$(words $(SRCS))`) y, dentro de la receta de `$(TARGET)`, una línea que diga cuántos objetos cambiaron desde el último enlace (`$(words $?)`). Toca un solo `.c` y comprueba que dice `1`.
