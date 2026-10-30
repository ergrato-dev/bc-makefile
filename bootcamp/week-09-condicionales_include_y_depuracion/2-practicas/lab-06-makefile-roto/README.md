# Lab 06 — Diagnosticar y corregir un Makefile roto

**Duración estimada:** 60 min

## Objetivo

Reparar un Makefile heredado con seis errores que Make reporta y dos que no,
usando los mensajes de Make, `--warn-undefined-variables` y `$(info)`.

## Contexto

Este lab invierte el flujo: no implementas nada, diagnosticas. El starter no
dice dónde están los errores. Los seis primeros detienen Make o lo hacen
quejarse; los dos últimos solo producen una salida incorrecta, y son los que
llegan a producción.

Método: ejecuta, lee el mensaje **entero** (archivo, línea, texto), corrige
una sola cosa, repite. Cada corrección lleva un comentario `# FIX:` que diga
la causa, no solo el cambio.

## Instrucciones

1. Copia el starter y lee el primer error:
   ```bash
   cp -r starter/ mi-lab-06 && cd mi-lab-06
   make ci
   ```
   ```
   Makefile:22: *** missing separator (did you mean TAB instead of 8 spaces?).  Stop.
   ```

2. Corrige y repite `make ci` hasta que imprima `CI completo`. Irás viendo, en
   este orden, mensajes como:
   ```
   Makefile:48: *** missing 'endif'.  Stop.
   Makefile:14: mk/config.mk: No such file or directory
   make: *** No rule to make target 'check-syntax', needed by 'lint'.  Stop.
   make: Circular deploy <- ci dependency dropped.
   ```
   Fíjate en el último: Make **no se detiene**, descarta la dependencia y
   sigue. Mira qué imprime `make ci` justo antes de `CI completo`: tu pipeline
   de CI estaba desplegando en producción.

3. Cuando `make ci` pase, prueba el target que falta:
   ```bash
   make deploy
   ```
   ```
   Makefile:NN: *** Recursive variable 'VERSION' references itself (eventually).  Stop.
   ```
   La versión correcta es `1.0.0`.

4. **Errores silenciosos.** `make ci` y `make deploy` ya terminan bien, pero
   mira la salida:
   ```
   Compilando  --debug
   Desplegando mi-app 1.0.0 en production
   ```
   Falta el nombre en el primero y `--confirm` en el segundo. Pide ayuda a Make:
   ```bash
   make --warn-undefined-variables ci deploy 2>&1 | grep undefined
   ```
   El primer aviso es un typo. El segundo es más sutil: añade en columna 0,
   justo antes del `ifeq` de `DEPLOY_FLAGS`, la línea temporal
   `$(info ENV al leer = $(ENV))` y explica por qué ese `ifeq` nunca es
   verdadero aunque `deploy` imprima `en production`. Corrígelo sin usar `ifeq`.

5. **Un `lint` que sirva.** Quitar `check-syntax` deja un `lint` que siempre
   dice OK. Haz que ejecute `$(MAKE) -n --warn-undefined-variables build deploy`,
   capture la salida y falle si contiene `undefined variable`: así los errores
   7 y 8 no vuelven. No incluyas `ci` ni `lint` en ese dry-run (pista: las
   líneas con `$(MAKE)` se ejecutan incluso con `-n`). Comprueba el resultado:
   ```bash
   make ci
   make deploy
   make --warn-undefined-variables ci deploy 2>&1 | grep -c undefined   # 0
   make help
   ```

## Pistas (ábrelas solo si llevas 10 minutos atascado en un error)

<details>
<summary>Pista 1 — Categorías de los 8 errores</summary>

1. Receta indentada con espacios
2. `ifeq` sin `endif`
3. `include` sin guion de un archivo opcional que no existe
4. Prerrequisito sin regla
5. Dependencia circular
6. Variable recursiva que se referencia a sí misma
7. Nombre de variable mal escrito
8. `ifeq` que depende de una variable de target

</details>

<details>
<summary>Pista 2 — El error 8</summary>

Los condicionales se evalúan al leer el Makefile, con el valor global de
`ENV`. `deploy: ENV := production` solo existe mientras se ejecuta `deploy`.
Si la variable de target funciona para `ENV`, también funciona para
`DEPLOY_FLAGS`.

</details>

<details>
<summary>Pista 3 — lint</summary>

Con `.SHELLFLAGS := -eu -o pipefail -c`, `out=$$($(MAKE) ...)` ya falla si el
sub-make falla. Después basta `if grep 'undefined variable' <<<"$$out"; then exit 1; fi`.

</details>

## Criterios de éxito

- [ ] `make ci` imprime `Compilando mi-app --debug`, `Tests OK`, `Lint OK` y `CI completo`, sin aviso `Circular` ni ninguna línea `Desplegando`
- [ ] `make deploy` imprime `Desplegando mi-app 1.0.0 en production --confirm`
- [ ] `make --warn-undefined-variables ci deploy` no imprime ningún `undefined variable`
- [ ] `make lint` falla (y muestra el aviso) si vuelves a escribir `$(APP_NMAE)`
- [ ] Cada uno de los 8 errores tiene su comentario `# FIX:` con la causa

## Reto extra

Amplía `lint` para que también falle si alguna asignación de variable lleva
un comentario en la misma línea (`VAR := valor # comentario`), el error que
añade un espacio invisible al valor. Escribe la expresión regular y
pruébala con un caso que debe fallar y otro que no.
