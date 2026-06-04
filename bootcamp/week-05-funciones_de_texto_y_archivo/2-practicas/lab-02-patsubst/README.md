# Lab 02 — patsubst

**Duración estimada:** 50 minutos

## Objetivo

Usar `$(patsubst)` y `$(subst)` para transformar una lista de fuentes en múltiples listas derivadas: objetos, binarios de prueba y rutas de release.

## Contexto

`$(patsubst from,to,text)` sustituye cada palabra en `text` que coincide con `from` por `to`. El comodín `%` captura el "stem" (la parte que varía):

```makefile
# src/main.c → build/main.o
$(patsubst src/%.c,build/%.o,src/main.c)
```

`$(subst from,to,text)` hace sustitución literal sin comodines:

```makefile
# src/main.c → release/main.c
$(subst src,release,src/main.c)
```

La diferencia clave: `patsubst` solo transforma palabras que coinciden con el patrón completo; `subst` reemplaza cualquier ocurrencia del string, en cualquier posición.

## Instrucciones

1. Entra al directorio starter:
   ```bash
   cd lab-02-patsubst/starter
   ```

2. Ejecuta `make demo` y observa que `OBJS`, `TEST_BINS` y `RELEASE_SRCS` están vacíos.

3. Completa `OBJS` usando `$(patsubst)` para transformar las rutas `src/%.c` → `build/%.o`:
   ```makefile
   OBJS := $(patsubst src/%.c,build/%.o,$(SRCS))
   ```

4. Completa `TEST_BINS` para generar rutas `build/%.o` → `bin/%` (sin extensión):
   ```makefile
   TEST_BINS := $(patsubst build/%.o,bin/%,$(OBJS))
   ```

5. Completa `RELEASE_SRCS` usando `$(subst)` para reemplazar `src` por `release`:
   ```makefile
   RELEASE_SRCS := $(subst src,release,$(SRCS))
   ```

6. Ejecuta `make demo` y verifica la salida esperada.

## Criterios de éxito

```
$ make demo
SRCS:         src/main.c src/utils.c src/network.c src/config.c
OBJS:         build/main.o build/utils.o build/network.o build/config.o
TEST_BINS:    bin/main bin/utils bin/network bin/config
RELEASE_SRCS: release/main.c release/utils.c release/network.c release/config.c
```

## Reto extra

Agrega una variable `DEPS` que genere archivos de dependencia `.d` para cada fuente, en el directorio `deps/`:

```makefile
DEPS := $(patsubst src/%.c,deps/%.d,$(SRCS))
```

Muéstrala en `make demo`.
