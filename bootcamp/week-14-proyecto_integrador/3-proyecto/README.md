# Proyecto Semana 14 — Build System Multi-Lenguaje Completo

**Duración estimada:** 2h 30min

## Contexto

Tu empresa opera una plataforma con tres componentes: un backend Python (Flask), un frontend Node.js y scripts de infraestructura. Cada equipo tiene su propio Makefile, pero la lógica de CI, Docker y deploy está duplicada en los tres. Cuando DevOps actualizó el procedimiento de push al registry, tuvo que editar tres archivos. La siguiente semana olvidó editar el del frontend.

Tu tarea es construir el build system definitivo de esta plataforma:
- Una librería `shared-mk/` con cinco módulos reutilizables
- Makefiles de servicio mínimos (solo variables + include)
- Un Makefile raíz que orquesta todo con recursión
- Git hooks instalables desde Make
- Pipeline CI completo en un solo comando

## Estructura del proyecto

```
3-proyecto/starter/
├── Makefile                     # Orquestador raíz
├── .env.example                 # Variables de entorno con defaults
├── shared-mk/                   # Librería compartida
│   ├── build.mk                 # build, clean, package
│   ├── test.mk                  # test, coverage
│   ├── docker.mk                # build-image, push
│   ├── deploy.mk                # deploy, rollback (con condicionales de entorno)
│   └── ci.mk                    # ci, lint (pipeline completo)
├── hooks/
│   ├── pre-commit               # Ejecuta: make check
│   └── pre-push                 # Ejecuta: make check
├── backend/
│   ├── Makefile                 # APP_NAME + include
│   ├── src/app.py
│   ├── tests/test_app.py
│   ├── pyproject.toml
│   ├── uv.lock
│   └── Dockerfile
├── frontend/
│   ├── Makefile                 # APP_NAME + include
│   ├── src/index.js
│   ├── package.json
│   └── Dockerfile
└── infra/
    ├── Makefile                 # APP_NAME + include
    └── scripts/deploy.sh
```

## Entregables

1. `shared-mk/build.mk` — targets `build`, `clean`, `package` que usan `APP_NAME` y `VERSION`
2. `shared-mk/test.mk` — target `test` con reporte por servicio; con `FAIL=<servicio>` los tests de ese servicio fallan (`exit 1`) para comprobar que el fallo se propaga
3. `shared-mk/docker.mk` — `build-image` y `push`; push protegido con guardia `CI=true`
4. `shared-mk/deploy.mk` — `deploy` y `rollback` con `ifeq` para entornos; producción requiere `CONFIRM=yes`
5. `shared-mk/ci.mk` — `ci` y `lint` que encadenan las etapas del pipeline
6. `backend/Makefile` — define `APP_NAME`, `IMAGE_NAME`, importa todos los módulos
7. `frontend/Makefile` — define `APP_NAME`, `IMAGE_NAME`, importa todos los módulos
8. `infra/Makefile` — define `APP_NAME`, importa `build.mk`, `test.mk`, `deploy.mk` y `ci.mk` (`ci` depende de `test`)
9. `Makefile` raíz — modo estricto y un target phony por servicio y meta (`backend/ci`, `infra/test`...) que llama a `$(MAKE) -C`; sin bucles `for`
10. `hooks/pre-commit` y `hooks/pre-push` versionados + `hooks-install` con `git config core.hooksPath`

## Comandos de verificación

```bash
# Pipeline completo desde la raíz
make ci
# Esperado: lint + test + build de backend, frontend e infra en orden

# Build de todos los servicios
make all
# Esperado: [backend] Build 1.0.0 / [frontend] Build 1.0.0 / [infra] Build 1.0.0

# Deploy por entorno
make ENV=development deploy
# Esperado: Desplegando en development (sin confirmación)

make ENV=production deploy
# Esperado: ERROR: producción requiere CONFIRM=yes

make ENV=production CONFIRM=yes deploy
# Esperado: Desplegando en production ✓

# Servicio individual
make -C backend test
# Esperado: [backend] Ejecutando tests ... ✓

make -C frontend -n build-image
# Esperado: docker build --tag mi-plataforma-frontend:1.0.0 .

# Git hooks
make hooks-install
# Esperado: ✓ Hooks activos desde <ruta>/hooks
# Ojo: `git commit --no-verify` salta los hooks. Son ayuda, no control:
# el control real es `make ci` en el pipeline.

# Paralelo
make -j3 all
# Esperado: los tres servicios se construyen en paralelo

# Un fallo en cualquier servicio detiene el pipeline
make ci FAIL=backend; echo "exit=$?"
# Esperado: [backend] ✗ Tests fallidos, frontend e infra no se ejecutan, exit=2 (no 0)
```

## ✅ Requisitos verificables

Los comprueba `./scripts/verificar-semana.sh 14` desde la raíz del repositorio
(60 de los 100 puntos del Producto). Los otros 40 son de calidad: ver la
[rúbrica](../rubrica-evaluacion.md#-producto-30). Ninguna comprobación necesita
red ni Docker: `build-image` y `push` se verifican con `make -n`, y los hooks en
un repositorio temporal.

- [ ] El Makefile raíz ejecuta las recetas con bash -eu -o pipefail
- [ ] El Makefile raíz declara .DELETE_ON_ERROR
- [ ] make all construye backend, frontend e infra
- [ ] make ci en un servicio ejecuta lint, test y build en ese orden
- [ ] make ci desde la raíz termina bien y construye los tres servicios
- [ ] Si los tests del primer servicio fallan, make ci sale con error
- [ ] Tras el fallo de backend, make ci no sigue con los demás servicios
- [ ] make infra/test ejecuta solo los tests de infra
- [ ] make deploy ENV=production sin CONFIRM=yes falla con un error claro
- [ ] make deploy ENV=production CONFIRM=yes despliega los tres servicios
- [ ] make push se niega a publicar si CI no es true
- [ ] Con CI=true, make push publica la imagen con su IMAGE_NAME y VERSION
- [ ] make build-image etiqueta la imagen como IMAGE_NAME:VERSION
- [ ] make hooks-install apunta core.hooksPath al directorio hooks/ del proyecto
- [ ] make check ejecuta el lint de los tres servicios
- [ ] make -j3 all reparte el jobserver con los sub-makes

## Instrucciones de entrega

```bash
git add bootcamp/week-14-proyecto_integrador/3-proyecto/
git commit -m "feat(week-14): proyecto - build system multi-lenguaje completo"
```
