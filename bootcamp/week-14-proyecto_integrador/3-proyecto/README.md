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
│   ├── requirements.txt
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
2. `shared-mk/test.mk` — target `test` con reporte por servicio
3. `shared-mk/docker.mk` — `build-image` y `push`; push protegido con guardia `CI=true`
4. `shared-mk/deploy.mk` — `deploy` y `rollback` con `ifeq` para entornos; producción requiere `CONFIRM=yes`
5. `shared-mk/ci.mk` — `ci` y `lint` que encadenan las etapas del pipeline
6. `backend/Makefile` — define `APP_NAME`, `IMAGE_NAME`, importa todos los módulos
7. `frontend/Makefile` — define `APP_NAME`, `IMAGE_NAME`, importa todos los módulos
8. `infra/Makefile` — define `APP_NAME`, importa `deploy.mk` y `ci.mk`
9. `Makefile` raíz — orquesta con `$(MAKE) -C` para `all`, `ci`, `test`, `deploy`, `clean`
10. `hooks/pre-commit` y `hooks/pre-push` + target `hooks-install` en el Makefile raíz

## Comandos de verificación

```bash
# Pipeline completo desde la raíz
make ci
# Esperado: lint + test + build-image de backend, frontend e infra en orden

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

make -C frontend build-image
# Esperado: docker build --tag frontend:1.0.0 .

# Git hooks
make hooks-install
# Esperado: ✓ Hooks instalados en .git/hooks/

# Paralelo
make -j3 all
# Esperado: los tres servicios se construyen en paralelo
```

## Rúbrica del proyecto (30 pts)

| Criterio | Pts |
|----------|-----|
| `make ci` desde raíz ejecuta el pipeline completo de los 3 servicios | 10 |
| Los módulos `shared-mk/*.mk` son importables sin modificación en cualquier proyecto nuevo | 8 |
| `make ENV=production CONFIRM=yes deploy` funciona; sin `CONFIRM=yes` falla con error claro | 7 |
| `make hooks-install` instala hooks funcionales; pre-commit aborta commit si `make check` falla | 5 |

## Instrucciones de entrega

```bash
git add bootcamp/week-14-proyecto_integrador/3-proyecto/
git commit -m "feat(week-14): proyecto - build system multi-lenguaje completo"
```
