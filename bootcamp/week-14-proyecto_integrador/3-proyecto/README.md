# Proyecto Semana 14 — Build System Multi-Lenguaje Completo

⏱ Duración estimada: 3 h

## Contexto

Tu empresa opera una plataforma con tres componentes: un backend Python (Flask, con uv), un frontend Node.js (con pnpm) e infraestructura, que incluye un pequeño healthcheck escrito en C. Cada equipo tiene su propio Makefile y la lógica de dependencias, CI, Docker y deploy está duplicada en los tres. Cuando DevOps cambió el procedimiento de push al registry tuvo que editar tres archivos, y la semana siguiente olvidó el del frontend.

Tu tarea es construir el build system definitivo de la plataforma, usando lo de todo el bootcamp:

| Eje | Dónde aparece | Semana |
|-----|---------------|:--:|
| Modo estricto y guardas de `rm -rf` | Preámbulo de cada Makefile; `clean` en `build.mk` | 03 |
| Variables automáticas y reglas de patrón | `c.mk`: `$(BUILD_DIR)/obj/%.o: src/%.c` | 04–05 |
| `-MMD -MP` y directorios order-only | `c.mk` | 06 |
| `$(wildcard)`, `$(patsubst)`, `$(foreach)` | `c.mk`, Makefile raíz | 07–08 |
| `include` de módulos y condicionales | Makefiles de servicio, `deploy.mk`, `docker.mk` | 09 |
| Recursión con subdirectorios phony y `-j` con jobserver | Makefile raíz | 10 |
| Stamps con uv y pnpm, imágenes no-root | `python.mk`, `node.mk`, Dockerfiles | 11 |
| Hooks con `core.hooksPath`, pipeline `ci` | Makefile raíz, `ci.mk` | 12 |

## Estructura del proyecto

```
3-proyecto/starter/
├── Makefile                     # Orquestador raíz (TODO)
├── .env.example
├── shared-mk/                   # Librería compartida (TODO en todos)
│   ├── build.mk                 # build, deps, clean (con guarda), package; BUILD_DIR y STAMPS
│   ├── python.mk                # stamp de uv sync --locked; LINT_CMD y TEST_CMD
│   ├── node.mk                  # stamp de pnpm install --frozen-lockfile; LINT_CMD y TEST_CMD
│   ├── c.mk                     # healthcheck en C con -MMD -MP
│   ├── test.mk                  # test, con FAIL=<servicio> para inyectar un fallo
│   ├── ci.mk                    # lint, ci
│   ├── docker.mk                # build-image, push (solo con CI=true)
│   └── deploy.mk                # deploy, rollback (production exige CONFIRM=yes)
├── hooks/
│   ├── pre-commit               # exec make check
│   └── pre-push                 # exec make check
├── backend/                     # Makefile (TODO), Dockerfile (TODO: USER), pyproject.toml, uv.lock
├── frontend/                    # Makefile (TODO), Dockerfile (TODO: USER), package.json, pnpm-lock.yaml
└── infra/                       # Makefile (TODO), src/*.c, include/check.h, include/version.h
```

## Entregables

1. `shared-mk/build.mk` — `build`, `deps` (sin receta), `clean` con guarda de `BUILD_DIR` vacío y `package`; define `BUILD_DIR ?= build` y `STAMPS := $(BUILD_DIR)/.stamps`
2. `shared-mk/c.mk` — fuentes con `$(wildcard)`, objetos en `$(BUILD_DIR)/obj/` con `$(patsubst)`, regla de patrón con `-MMD -MP`, directorio order-only, `-include` de los `.d`; añade el binario a `build` y a `test`
3. `shared-mk/python.mk` y `shared-mk/node.mk` — un stamp `$(STAMPS)/deps` que solo se rehace si cambia el manifiesto o el lockfile (`uv sync --locked`, `pnpm install --frozen-lockfile`); `UV ?= uv` y `PNPM ?= pnpm` sobrescribibles
4. `shared-mk/test.mk` — `test: deps`, ejecuta `$(TEST_CMD)`; con `FAIL=<servicio>` sale con `exit 1`
5. `shared-mk/ci.mk` — `lint: deps` ejecuta `$(LINT_CMD)`; `ci: lint test build`
6. `shared-mk/docker.mk` — `build-image` y `push`, protegido con `CI=true`
7. `shared-mk/deploy.mk` — `deploy` y `rollback`; con `ifeq`, `ENV=production` exige `CONFIRM=yes`
8. Makefiles de servicio — solo variables (`APP_NAME`, `IMAGE_NAME`, `VERSION`) e `include`, con `build.mk` el primero
9. Dockerfiles de backend y frontend con un `USER` sin privilegios antes del `CMD`
10. `Makefile` raíz — modo estricto y un target phony por servicio y meta (`backend/ci`, `infra/test`...) que llama a `$(MAKE) -C`; sin bucles `for`
11. `hooks/` versionados, `hooks-install` con `git config core.hooksPath` y `check` como lint de los tres servicios

## Comandos de verificación

Con uv, pnpm y un compilador de C instalados:

```bash
make deps                      # uv sync --locked, pnpm install --frozen-lockfile
make deps                      # segunda vez: nada que hacer en ningún servicio
make -j3 ci                    # lint, test y build de los tres servicios, en paralelo
make ci FAIL=backend; echo $?  # [backend] ✗ Tests fallidos ... 2; frontend e infra no se ejecutan

make infra/build               # compila build/obj/*.o y build/infra-healthcheck
touch infra/include/check.h
make infra/build               # recompila exactamente check.o y main.o

make deploy ENV=production                 # ERROR: producción requiere CONFIRM=yes
make deploy ENV=production CONFIRM=yes     # Desplegando en production, tres veces
make -C infra clean BUILD_DIR=             # BUILD_DIR vacía: rm -rf no se ejecuta

make -C frontend -n build-image            # docker build --tag mi-plataforma-frontend:1.0.0 .
make -C backend push                       # ERROR: push solo permitido cuando CI=true
make hooks-install                         # ✓ Hooks activos desde <ruta>/hooks
```

Sin red puedes ejecutar todo el pipeline sustituyendo las herramientas por `:`,
el comando de shell que no hace nada. Es lo que hace el autograding:

```bash
make ci UV=: PNPM=:
```

Funciona porque las variables de la línea de comandos llegan a todos los
sub-makes, y porque `UV` y `PNPM` se declaran con `?=`.

## ✅ Requisitos verificables

Los comprueba `./scripts/verificar-semana.sh 14` desde la raíz del repositorio
(60 de los 100 puntos del Producto). Los otros 40 son de calidad: ver la
[rúbrica](../rubrica-evaluacion.md#-producto-30). Ninguna comprobación necesita
red ni Docker: los pipelines corren sobre una copia temporal con `UV=: PNPM=:`,
`build-image` y los stamps se verifican con `make -n`, y los hooks en un
repositorio temporal.

- [ ] El Makefile raíz ejecuta las recetas con bash -eu -o pipefail
- [ ] El Makefile raíz declara .DELETE_ON_ERROR
- [ ] make ci en un servicio ejecuta lint, test y build en ese orden
- [ ] Si los tests del primer servicio fallan, make ci sale con error
- [ ] Tras el fallo de backend, make ci no sigue con los demás servicios
- [ ] make infra/test ejecuta solo los tests de infra
- [ ] make deploy ENV=production sin CONFIRM=yes falla con un error claro
- [ ] make deploy ENV=production CONFIRM=yes despliega los tres servicios
- [ ] make push se niega a publicar si CI no es true
- [ ] make build-image etiqueta la imagen como IMAGE_NAME:VERSION
- [ ] make hooks-install apunta core.hooksPath al directorio hooks/ del proyecto
- [ ] make check ejecuta el lint de los tres servicios
- [ ] make -j3 all reparte el jobserver con los sub-makes
- [ ] En backend, uv sync --locked solo se ejecuta si pyproject.toml o uv.lock son más nuevos que el stamp
- [ ] En frontend, pnpm install --frozen-lockfile solo se ejecuta si package.json o pnpm-lock.yaml son más nuevos que el stamp
- [ ] Tocar infra/include/check.h recompila exactamente los dos objetos que lo incluyen
- [ ] make clean en un servicio se niega a borrar si BUILD_DIR está vacío
- [ ] Los Dockerfiles de backend y frontend terminan con un USER que no es root

## Entrega

```bash
make clean
git add bootcamp/week-14-proyecto_integrador/3-proyecto/starter/
git commit -m "feat(week-14): proyecto - build system multi-lenguaje completo"
```

> No commitees `build/`, `.venv/` ni `node_modules/`.
