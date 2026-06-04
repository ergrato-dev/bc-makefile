# Lab 01 — Variables básicas

⏱ Duración estimada: ~50 min

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
- [ ] `make help` lista los cuatro targets con descripción

## Reto extra

Agrega una variable `BUILD_DIR` con `:=` y valor `"build"`. Crea un target `mkdir-build` que ejecute `mkdir -p $(BUILD_DIR)` y luego imprima `"Directorio $(BUILD_DIR) listo."`. Decláralo en `.PHONY` y agrégalo a `help`.
