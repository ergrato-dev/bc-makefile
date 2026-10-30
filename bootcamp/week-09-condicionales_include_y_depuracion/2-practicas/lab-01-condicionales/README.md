# Lab 01 — Condicionales en Make

**Duración estimada:** 60 min

## Objetivo

Adaptar un único Makefile a tres entornos y a CI con `ifeq`, `ifdef` y
`$(error)`, y depurar un condicional que falla en silencio.

## Contexto

- `ifeq`/`ifneq` comparan texto; `ifdef`/`ifndef` preguntan si la variable
  tiene valor no vacío (`make CI=` cuenta como vacía).
- Los condicionales se evalúan **al leer el Makefile**, una vez, con el valor
  global de la variable. No ven variables de target ni la salida de recetas.
- El patrón: valor por defecto con `?=`, validación temprana con `$(error)`,
  y bloques que derivan el resto de variables.

## Instrucciones

1. Copia el starter y mira qué targets tiene:
   ```bash
   cp -r starter/ mi-lab-01 && cd mi-lab-01
   make
   ```

2. **BUILD_FLAGS por entorno (TODO 2).** Escribe el bloque
   `ifeq` / `else ifeq` / `else` / `endif`. Para comprobarlo antes de tener
   `info`, añade temporalmente en columna 0 `$(info BUILD_FLAGS=$(BUILD_FLAGS))`
   y ejecuta:
   ```bash
   make help ENV=staging | grep BUILD_FLAGS     # BUILD_FLAGS=--release
   make help | grep BUILD_FLAGS                 # BUILD_FLAGS=--debug
   ```
   Borra la línea temporal.

3. **Validar ENV al leer (TODO 1).** Un typo como `ENV=prod` hoy cae en la rama
   `else` y compila en modo debug sin avisar. Haz que falle:
   ```bash
   make info ENV=prod
   ```
   Salida esperada:
   ```
   Makefile:NN: *** ENV='prod' no es válido. Usa uno de: development staging production.  Stop.
   ```
   Prueba también `make info ENV=` y explica por qué falla igual.

4. **Detección de CI (TODO 3).** Compara las tres formas:
   ```bash
   CI=true make help | grep 'Modo CI'    # Modo CI activado — paralelo habilitado
   make help CI=true | grep 'Modo CI'    # igual
   make help CI= | grep -c 'Modo CI'     # 0: sin modo CI
   ```
   En el tercer caso `CI` está definida pero vacía, y para `ifdef` eso es
   "no definida". Lo verás con `$(origin CI)` en el paso 6.

5. **Depurar el endpoint (TODO 4).** `REGION` vale `eu`, pero el `ifeq` elige
   US. Añade temporalmente en columna 0, justo antes del `ifeq`:
   ```makefile
   $(info REGION=[$(REGION)])
   ```
   Los corchetes revelan el problema. Corrígelo sin tocar el `ifeq` y deja un
   comentario `# FIX:` que explique la causa. Quita la línea temporal.

6. **`info` y `build` (TODOs 5 y 6).** Completa las recetas:
   ```bash
   make info ENV=staging
   ```
   ```
   APP_NAME    = mi-app
   ENV         = staging
   BUILD_FLAGS = --release
   CI          = [] origin=undefined
   ENDPOINT    = https://eu.api.example.com
   Configuración mostrada.
   ```
   Ejecuta `make info CI=` y `CI=true make info`: la línea `CI` debe mostrar
   `origin=command line` y `origin=environment`.

7. **`deploy` protegido (TODO 7).** En la receta un `ifeq` no sirve para
   decidir por target; usa un test de shell:
   ```bash
   make deploy ENV=development    # ERROR: deploy no permitido en development (sale con 2)
   make deploy ENV=production     # Desplegando en production (https://eu.api.example.com)
   ```

## Criterios de éxito

- [ ] `make info ENV=development` muestra `BUILD_FLAGS = --debug`; con `staging` y `production`, `BUILD_FLAGS = --release`
- [ ] `make info ENV=prod` sale con error `ENV='prod' no es válido. Usa uno de: development staging production`
- [ ] `CI=true make info` imprime `Modo CI activado — paralelo habilitado`; `make info CI=` no lo imprime y muestra `origin=command line`
- [ ] `make info` muestra `ENDPOINT    = https://eu.api.example.com` y el Makefile tiene el `# FIX:` que explica la causa
- [ ] `make build ENV=production` imprime `Compilando mi-app con --release`
- [ ] `make deploy ENV=development` sale con código distinto de 0 e imprime `ERROR: deploy no permitido en development`
- [ ] `make deploy ENV=production` imprime `Desplegando en production (https://eu.api.example.com)`

## Reto extra

Declara `deploy-prod: ENV := production` (variable de target) y, dentro de un
`ifeq ($(ENV),production)` a nivel de archivo, una receta para `deploy-prod`
que imprima `rama production`. Ejecuta `make deploy-prod`: Make responde
`No rule to make target 'deploy-prod'`. Explica por qué la receta no existe,
si dentro de una receta de `deploy-prod` `$(ENV)` valdría `production`.
