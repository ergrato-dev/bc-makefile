# Lab 03 — filter

**Duración estimada:** 50 minutos

## Objetivo

Seleccionar y excluir subconjuntos de una lista mixta de archivos usando `$(filter)` y `$(filter-out)`.

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

1. Entra al directorio starter:
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

## Reto extra

Agrega una variable `BUILD_ONLY` que use `$(filter)` con dos patrones para obtener solo los archivos que están en `build/` y son `.o`. Luego agrega `DEPS` que filtre archivos `.d` de la misma lista (habrá cero — muestra la lista vacía explícitamente con un mensaje de fallback usando `$(if ...)`.
