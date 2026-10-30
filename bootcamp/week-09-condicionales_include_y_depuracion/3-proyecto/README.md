# Proyecto Semana 09 — Librería de Módulos Make Reutilizables

**Duración estimada:** 3 h

## Contexto

Tu equipo mantiene tres servicios (`api`, `worker`, `frontend`) con Makefiles
que duplican las mismas 200 líneas de build, test y deploy. Cada mejora del
pipeline se copia a mano en los otros dos, y la última vez alguien lo olvidó:
`frontend` desplegó en producción sin la confirmación que sí tenían los demás.
Además, un compañero con macOS ejecutó `make` (la 3.81 de Apple) y obtuvo
errores incomprensibles.

Vas a construir una **librería de módulos Make** en `shared-mk/` que cada
servicio importa con `include`. Los Makefiles de servicio solo definen sus
variables; la lógica vive una sola vez. El Makefile raíz orquesta los tres
servicios, se niega a correr con un Make demasiado viejo y ofrece un `doctor`
que diagnostica el entorno antes de que nadie pierda una tarde.

## Estructura del proyecto

```
3-proyecto/starter/
├── Makefile               # Raíz: guarda de versión, recursión y doctor
├── shared-mk/             # Librería compartida
│   ├── build.mk           # build, package, clean (artefacto real en BUILD_DIR)
│   ├── test.mk            # test: comprueba el artefacto
│   ├── deploy.mk          # deploy (ifeq para production), rollback
│   └── debug.mk           # debug-vars, validate
├── api/
│   ├── Makefile           # APP_NAME, VERSION, PORT + 4 includes
│   └── src/               # routes.conf, server.conf
├── worker/
│   ├── Makefile           # APP_NAME, VERSION, WORKERS + 4 includes
│   └── src/               # jobs.conf
└── frontend/
    ├── Makefile           # APP_NAME, VERSION, BUILD_DIR := dist + 4 includes
    └── src/               # index.html, app.js
```

Los archivos de `src/` ya están; no hace falta tocarlos. El "build" de cada
servicio genera un artefacto de texto con cabecera y el contenido de sus
fuentes: lo importante es que sea un **archivo real** con dependencias reales.

## Entregables

Trabaja en este orden: cada paso se puede probar antes de seguir.

1. **Guarda de versión en el Makefile raíz** (TODO 0). `MIN_MAKE_VERSION := 4.3`
   y un `ifneq` que compare con `$(firstword $(sort ...))`, sin `$(shell)`.
   Con un Make anterior, `$(error ...)` con un mensaje que contenga
   `requiere GNU Make`, la versión en uso y cómo arreglarlo.
2. **`shared-mk/build.mk`**. `BUILD_DIR ?= build` y `SRC_DIR ?= src` (con `?=`
   para que `frontend` use `dist`); `SRCS`, `ARTIFACT`
   (`$(BUILD_DIR)/$(APP_NAME)-$(VERSION).txt`) y `PACKAGE` (`.tar.gz`).
   `build` depende del artefacto, el artefacto depende de `SRCS` e imprime
   `[api] Compilando api 1.0.0` solo cuando se rehace. `package` crea el
   `.tar.gz` con `tar -C` para que contenga únicamente el `.txt`. `clean` borra
   `BUILD_DIR` con guarda de vacío.
3. **`shared-mk/test.mk`**. `test` depende del artefacto y comprueba con
   `grep -qx` que contiene `version=$(VERSION)`; imprime `[api] Tests OK`.
4. **`shared-mk/deploy.mk`**. `ifeq ($(ENV),production)` elige la receta: en
   production imprime `[api] Desplegando en production (CONFIRMADO)`; en otro
   entorno, `[api] Desplegando en <ENV>`. `rollback` imprime
   `[api] Rollback a versión anterior`.
5. **`shared-mk/debug.mk`**. `debug-vars` imprime con `$(info)` `APP_NAME`,
   `VERSION`, `ENV`, `BUILD_DIR`, `ARTIFACT` y `MAKEFILE_LIST`. `validate`
   falla nombrando la variable si `APP_NAME` o `VERSION` están vacías, o si
   `src/` no tiene fuentes; si todo va bien imprime `[api] Validación OK`.
6. **`doctor` en el Makefile raíz** (TODO 4). Depende de `<módulo>/validate`
   de los tres y muestra `MAKE_VERSION`, `MAKECMDGOALS`, `MODULES` y `ENV`.
7. **Makefiles de servicio**. Preámbulo estricto y los cuatro `include
   ../shared-mk/*.mk`. Nada más: si copias una receta aquí, el proyecto pierde
   su razón de ser.
8. **Recursión en el Makefile raíz** (TODOs 1–3). Un target phony por módulo y
   meta (`api/build`, `worker/validate`...), `ENV=$(ENV)` explícito, y `all`,
   `clean`, `test`, `deploy` solo con prerrequisitos.

## Comandos de verificación

```bash
make help MAKE_VERSION=3.81
# Makefile:NN: *** Este proyecto requiere GNU Make >= 4.3 y estás usando 3.81. ...  Stop.

make all
# [api] Compilando api 1.0.0
# [worker] Compilando worker 1.0.0
# [frontend] Compilando frontend 1.0.0

make all                      # segunda vez: ningún "Compilando"
ls api/build frontend/dist    # api-1.0.0.txt  /  frontend-1.0.0.txt

make test                     # [api] Tests OK ... x3
make -C api package && tar -tzf api/build/api-1.0.0.tar.gz   # api-1.0.0.txt

make ENV=staging deploy       # [api] Desplegando en staging ... x3
make -C api ENV=production deploy
# [api] Desplegando en production (CONFIRMADO)

make doctor
# [api] Validación OK ... x3
# MAKE_VERSION  = 4.3 (mínimo 4.3)
# MAKECMDGOALS  = doctor
# ...
# Diagnóstico OK

make -C frontend validate VERSION=          # ERROR: VERSION no puede estar vacía...
make -C api clean BUILD_DIR=                # *** BUILD_DIR vacía: rm -rf no se ejecuta

make -C api clean && make -C api --trace build
# ../shared-mk/build.mk:NN: update target 'build/api-1.0.0.txt' due to: ...

make clean && make --warn-undefined-variables all   # ningún "undefined variable"
```

> [!TIP]
> Si `make all` desde la raíz falla y no sabes en qué módulo, ejecuta
> `make -C <módulo> debug-vars`: `MAKEFILE_LIST` te dice qué se incluyó y
> `ARTIFACT` qué ruta espera Make.

## ✅ Requisitos verificables

Los comprueba `./scripts/verificar-semana.sh 09` desde la raíz del repositorio
(60 de los 100 puntos del Producto). Los otros 40 son de calidad: ver la
[rúbrica](../rubrica-evaluacion.md#-producto-30).

- [ ] Con una versión de Make anterior a 4.3 el Makefile raíz se niega a ejecutar con un mensaje claro
- [ ] make all desde la raíz construye api, worker y frontend
- [ ] make all genera el artefacto de cada módulo dentro de su BUILD_DIR
- [ ] Una segunda ejecución de make all no recompila ningún módulo
- [ ] make -C api package crea un .tar.gz que contiene el artefacto
- [ ] make test desde la raíz ejecuta los tests de los tres módulos
- [ ] Si un módulo falla, make all desde la raíz sale con error
- [ ] make ENV=staging deploy despliega los tres módulos en staging
- [ ] deploy en production toma la rama ifeq que marca CONFIRMADO
- [ ] debug-vars muestra en MAKEFILE_LIST los cuatro módulos incluidos
- [ ] validate falla con mensaje claro si VERSION está vacía
- [ ] make doctor muestra la versión de Make en uso
- [ ] make doctor ejecuta validate en los tres módulos
- [ ] --trace muestra que la regla del artefacto vive en shared-mk/build.mk
- [ ] make all no usa ninguna variable indefinida (--warn-undefined-variables)
- [ ] make clean se niega a borrar si BUILD_DIR está vacío
- [ ] El Makefile raíz ejecuta las recetas con bash -eu -o pipefail
- [ ] Los Makefiles de api, worker y frontend también usan bash -eu -o pipefail

## Instrucciones de entrega

Antes de entregar, `make clean` desde la raíz: `build/` y `dist/` no se comitean.

```bash
git add bootcamp/week-09-condicionales_include_y_depuracion/3-proyecto/
git commit -m "feat(week-09): proyecto - librería de módulos Make reutilizables"
```
