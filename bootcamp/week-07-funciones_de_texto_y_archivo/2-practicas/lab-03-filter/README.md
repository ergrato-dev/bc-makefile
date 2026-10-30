# Lab 03 — filter

⏱ Duración estimada: ~60 min

## Objetivo

Seleccionar y excluir subconjuntos de una lista mixta de archivos usando `$(filter)` y `$(filter-out)`, y usar `$(filter)` como prueba de pertenencia para validar un argumento de la línea de comandos.

## Contexto

`$(filter pattern,text)` conserva solo las palabras de `text` que coinciden con `pattern`. Acepta múltiples patrones separados por espacios:

```makefile
# Conserva .c y .h, descarta el resto
$(filter %.c %.h, main.c utils.h build/main.o)
# → main.c utils.h
```

`$(filter-out pattern,text)` es el complemento: elimina las palabras que coinciden y conserva el resto:

```makefile
$(filter-out %.o, main.c utils.h build/main.o)
# → main.c utils.h
```

Ambas funciones son el mecanismo estándar para clasificar listas de archivos por tipo o por directorio.

## Instrucciones

1. Entra al directorio starter y añade el preámbulo estricto:
   ```bash
   cd lab-03-filter/starter
   ```

2. Ejecuta `make demo`. Todos los valores estarán vacíos o incorrectos.

3. Completa `C_SRCS` para conservar solo archivos `.c`:
   ```makefile
   C_SRCS := $(filter %.c,$(ALL_FILES))
   ```

4. Completa `HEADERS` para conservar solo archivos `.h`:
   ```makefile
   HEADERS := $(filter %.h,$(ALL_FILES))
   ```

5. Completa `OBJECTS` para conservar solo archivos `.o`:
   ```makefile
   OBJECTS := $(filter %.o,$(ALL_FILES))
   ```

6. Completa `NO_DOCS` usando `$(filter-out)` para excluir todo lo que empiece con `docs/`:
   ```makefile
   NO_DOCS := $(filter-out docs/%,$(ALL_FILES))
   ```

7. Completa `SRC_AND_INC` usando dos patrones en un solo `$(filter)`:
   ```makefile
   SRC_AND_INC := $(filter src/% include/%,$(ALL_FILES))
   ```

8. Ejecuta `make demo` y verifica la salida esperada.

9. **Patrón construido con una variable.** El target `pick` debe imprimir solo los archivos del directorio que pases en `DIR`. El patrón se arma con la variable:
   ```makefile
   pick: ## Lista los archivos de un directorio (DIR=include)
   	@echo "$(filter $(DIR)/%,$(ALL_FILES))"
   ```
   ```bash
   make -s pick DIR=include
   ```
   ```
   include/utils.h include/types.h
   ```
   Prueba ahora `make -s pick DIR=lib`: imprime una línea vacía y sale con 0. Un error de tecleo pasa inadvertido.

10. **`$(filter)` como prueba de pertenencia.** `$(filter palabra,lista)` devuelve `palabra` si está en la lista y vacío si no: es un `if x in lista`. `DIRS` ya contiene `build docs include src`. Añade como primera línea de la receta de `pick`:
    ```makefile
    	$(if $(filter $(DIR),$(DIRS)),,$(error Directorio '$(DIR)' no existe; disponibles: $(DIRS)))
    ```
    ```bash
    make pick DIR=lib
    ```
    ```
    Makefile:36: *** Directorio 'lib' no existe; disponibles: build docs include src.  Stop.
    ```
    Comprueba también `make pick` (sin `DIR`) y `make pick DIR=build/main.o`: los dos deben fallar. `filter` compara palabras completas, así que `build/main.o` no es `build`.

## Criterios de éxito

```
$ make demo
Todos:      src/main.c src/utils.c include/utils.h include/types.h build/main.o build/utils.o docs/README.md docs/API.md
.c:         src/main.c src/utils.c
.h:         include/utils.h include/types.h
.o:         build/main.o build/utils.o
Sin docs:   src/main.c src/utils.c include/utils.h include/types.h build/main.o build/utils.o
src+inc:    src/main.c src/utils.c include/utils.h include/types.h
```

- [ ] `make -s pick DIR=include` imprime `include/utils.h include/types.h`
- [ ] `make pick DIR=lib` falla con `Directorio 'lib' no existe; disponibles: build docs include src` y código de salida distinto de 0
- [ ] `make pick` sin `DIR` también falla

## Reto extra

Agrega `BUILD_ONLY` con los archivos que están en `build/` **y** son `.o`. Ojo: dos patrones en un `$(filter)` son un "o" (`$(filter build/% %.o,...)` devuelve la unión); el "y" se escribe con un solo patrón, `build/%.o`. Después agrega `DEPS := $(filter %.d,$(ALL_FILES))` (habrá cero) y muéstrala con un mensaje de respaldo: `$(if $(DEPS),$(DEPS),(ninguno))`.
