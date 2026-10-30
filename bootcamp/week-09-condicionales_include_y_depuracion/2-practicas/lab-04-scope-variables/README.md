# Lab 04 — Scope de variables entre Make padre e hijo

**Duración estimada:** 60 min

## Objetivo

Controlar qué variables recibe un sub-make con paso explícito, `export`,
`unexport` y `override`, y comprobarlo leyendo `MAKEFLAGS` y `MAKELEVEL`.

## Contexto

Un `$(MAKE) -C sub` es otro proceso que lee otro Makefile. Recibe:

1. Las variables de la **línea de comandos** del padre, dentro de `MAKEFLAGS`.
2. Las variables del **entorno**: las que ya venían del shell, y las que el
   padre marca con `export`.
3. Lo que el padre le pase **como argumento**: `$(MAKE) -C sub ENV=$(ENV)`.

Lo que el padre define en su Makefile no viaja por sí solo. La recursión en
profundidad (`-j`, jobserver, `.WAIT`) es la Semana 10; aquí solo importa qué
variables cruzan la frontera.

## Instrucciones

1. Copia el starter y mira qué recibe el hijo sin hacer nada:
   ```bash
   cp -r starter/ mi-lab-04 && cd mi-lab-04
   make show-scope
   ```
   ```
   === Padre (MAKELEVEL=0) invocando sub-make ===
   === Sub-make (MAKELEVEL=1) ===
   ENV        = (no recibido)
   VERSION    = 0.0.0-hijo
   SHARED_VAR =
   SECRET_VAR =
   CFLAGS     = -fPIC
   MAKEFLAGS  =  --no-print-directory
   ```

2. **La línea de comandos sí viaja.** Sin tocar nada:
   ```bash
   make show-scope ENV=production | grep -E 'ENV|MAKEFLAGS'
   ```
   El hijo recibe `ENV = production` y lo ves en `MAKEFLAGS` tras el `--`. Pero
   el `ENV ?= development` del padre no llegó en el paso 1.

3. **`export` (TODO 1).** Exporta `SHARED_VAR` y repite `make show-scope`:
   `SHARED_VAR = valor-compartido`. Escribe en un comentario por qué no se usa
   `export` sin argumentos.

4. **Paso explícito (TODO 2).** Añade `ENV=$(ENV)` a la invocación. Ahora
   `make show-scope` muestra `ENV = development` y `MAKEFLAGS` incluye
   `-- ENV=development`: para el hijo es como si viniera de la línea de comandos.

5. **El entorno se cuela (TODO 3).**
   ```bash
   SECRET_VAR=supersecret make show-scope | grep SECRET   # SECRET_VAR = supersecret
   ```
   El padre no exportó nada y el secreto llegó: las variables del entorno se
   exportan solas. Añade `unexport SECRET_VAR` y repite: `SECRET_VAR =` vacío.

6. **Variables del Makefile del padre (TODO 4).** Implementa `pass-version`:
   ```bash
   make pass-version | grep VERSION            # Padre 1.0.0 / hijo 1.0.0
   make pass-version VERSION=9.9.9 | grep VERSION
   ```
   Sin el paso explícito el hijo usaría su `0.0.0-hijo`.

7. **`override` en el hijo (TODO 5).**
   ```bash
   make show-scope CFLAGS=-O2 | grep CFLAGS    # CFLAGS     = -O2   (falta -fPIC)
   ```
   Una variable de la línea de comandos ignora las asignaciones del Makefile,
   también `+=`. Cambia la línea a `override CFLAGS += -fPIC` y repite:
   `CFLAGS     = -O2 -fPIC`.

8. **Entorno con prioridad (`-e`).** Compara:
   ```bash
   VERSION=7.7.7 make show-scope | grep VERSION      # 0.0.0-hijo
   VERSION=7.7.7 make -e show-scope | grep VERSION   # 7.7.7
   ```
   Con `-e` el entorno gana a las asignaciones del Makefile, en el padre y en
   el hijo (`MAKEFLAGS` empieza por `e`). Anota por qué es peligroso en CI.

## Criterios de éxito

- [ ] `make show-scope` → el hijo imprime `ENV        = development` y `SHARED_VAR = valor-compartido`
- [ ] `make show-scope ENV=production` → `ENV        = production`
- [ ] `SECRET_VAR=supersecret make show-scope` → `SECRET_VAR = ` vacío
- [ ] `make pass-version` → el hijo imprime `VERSION    = 1.0.0`; con `VERSION=9.9.9`, `9.9.9`
- [ ] `make show-scope CFLAGS=-O2` → `CFLAGS     = -O2 -fPIC`
- [ ] Comentarios de los pasos 3 y 8 escritos

## Reto extra

Añade al hijo `MAX_LEVEL := 1` y una guarda que detenga Make con `$(error)` si
`$(MAKELEVEL)` supera ese valor. Provoca el fallo haciendo que `report`
invoque `$(MAKE) report` sobre sí mismo y comprueba que el mensaje sale en el
nivel 2 en lugar de recursar sin fin.
