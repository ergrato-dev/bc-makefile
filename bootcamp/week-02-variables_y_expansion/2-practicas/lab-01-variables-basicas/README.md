# Lab 01 — Variables básicas

⏱ Duración estimada: ~60 min

## Objetivo

Definir variables con los cuatro operadores de Make (`=`, `:=`, `?=`, `+=`) y verificar su comportamiento en targets concretos.

## Contexto

Make distingue entre cuatro formas de asignar una variable:

- `CC := gcc` — evalúa `gcc` inmediatamente y lo almacena
- `CFLAGS = -Wall` — almacena la expresión; la evalúa cuando se usa
- `ENV ?= dev` — solo asigna si `ENV` no tiene valor todavía
- `LIBS += -lpthread` — agrega `-lpthread` al valor actual de `LIBS`

En la práctica, `+=` hereda el tipo del operador anterior: si `LIBS` fue definido con `:=`, entonces `LIBS +=` también es inmediato.

## Instrucciones

1. Abre `starter/Makefile`. Verás las secciones con TODOs.

2. Define `CC` con `:=` y valor `"gcc"`.

3. Define `CFLAGS` con `=` y valor `"-Wall -Wextra -std=c11"`.

4. Define `ENV` con `?=` y valor `"dev"`.

5. Define `LIBS` con `:=` y valor `"-lm"`, luego agrégale `"-lpthread"` con `+=`.

6. Completa los tres targets: `info-compilador`, `info-entorno`, `info-libs` para que impriman las variables correspondientes.

7. Verifica:
   ```bash
   make info-compilador
   make info-entorno
   make info-libs
   make info-entorno ENV=prod
   ```

8. **Comprueba el tipo real de cada variable.** La función `$(flavor VAR)`
   devuelve `simple` (`:=`), `recursive` (`=` y `?=`) o `undefined`. Completa
   el target `tipos` y ejecútalo:
   ```bash
   make tipos
   ```
   Debes ver:
   ```
   CC:     simple
   CFLAGS: recursive
   ENV:    recursive
   LIBS:   simple
   NADA:   undefined
   ```
   `ENV` es `recursive` porque `?=` crea una variable `=`. `LIBS` sigue siendo
   `simple` después del `+=`: el append conserva el tipo de la primera
   asignación.

9. Demuéstralo cambiando el tipo de origen: sustituye `LIBS := -lm` por
   `LIBS = -lm` y repite `make tipos` y `make info-libs`. Ahora `LIBS` es
   `recursive` y su valor sigue siendo `-lm -lpthread`: el `+=` se adaptó al
   nuevo tipo sin que lo tocaras. Deja `LIBS := -lm` como estaba.

## Criterios de éxito

- [ ] `make info-compilador` imprime:
  ```
  CC:     gcc
  CFLAGS: -Wall -Wextra -std=c11
  ```
- [ ] `make info-entorno` imprime:
  ```
  Entorno: dev
  ```
- [ ] `make info-entorno ENV=prod` imprime:
  ```
  Entorno: prod
  ```
- [ ] `make info-libs` imprime:
  ```
  LIBS: -lm -lpthread
  ```
- [ ] `make tipos` imprime `simple`, `recursive`, `recursive`, `simple`, `undefined` en ese orden
- [ ] Con `LIBS = -lm`, `make tipos` muestra `LIBS:   recursive` y `make info-libs` sigue mostrando `-lm -lpthread`
- [ ] `make help` lista los cinco targets con descripción

## Reto extra

Agrega una variable `BUILD_DIR` con `:=` y valor `"build"`. Crea un target `mkdir-build` que ejecute `mkdir -p $(BUILD_DIR)` y luego imprima `"Directorio $(BUILD_DIR) listo."`. Decláralo en `.PHONY` y agrégalo a `help`.
