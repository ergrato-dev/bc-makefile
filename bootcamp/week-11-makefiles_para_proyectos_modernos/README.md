# Semana 11 — Makefiles para Proyectos Modernos

## Descripción

Make no es solo para proyectos C. Es la interfaz universal que unifica Python, Docker y Node.js bajo un mismo comando. Esta semana conviertes Make en el punto de entrada único de cualquier proyecto moderno: un `make test` y un `make check` que funcionan igual en tu máquina y en CI, sin importar si el proyecto usa uv, pnpm o Dockerfile.

Al terminar sabrás construir el Makefile que todo equipo de desarrollo quiere: uno que cualquier persona puede clonar y ejecutar sin leer documentación extensa.

## Objetivos de aprendizaje

Al terminar esta semana serás capaz de:

- Gestionar entornos Python con uv desde Make usando archivos testigo (sentinel files) que no mienten
- Ejecutar lint y formato con ruff y agrupar las comprobaciones de CI en un único target `check`
- Construir y etiquetar imágenes Docker desde Make, con build incremental mediante `--iidfile`
- Envolver pnpm/Node.js en un Makefile coherente con el resto del proyecto
- Orquestar `docker compose` desde Make y tratar `.env` como precondición y como Makefile
- Combinar varios stacks en un solo Makefile con targets prefijados, `-j` y `-k`
- Diagnosticar los errores típicos de Makefiles de servicios: sentinels incompletos, versiones vacías, secretos exportados

## Prerrequisitos

- Semanas 01–10 del bootcamp (preámbulo estricto de la Semana 03)
- GNU Make ≥ 4.3
- Python 3.14 y [uv](https://docs.astral.sh/uv/) (labs 01 y 05, proyecto). Nunca pip.
- Node.js 26 LTS y pnpm (labs 03 y 05). Nunca npm.
- Docker Engine 27+ con Compose v2 (labs 02 y 04; `build`/`up` del proyecto)

## Contenido

| Sección | Contenido | Tiempo |
|---------|-----------|--------|
| [1-teoria](./1-teoria/01-contexto.md) | Make como interfaz universal: sentinel, uv, ruff, `.env` | 45 min |
| [Conocimiento](./rubrica-evaluacion.md#-conocimiento-30) | 10 preguntas de la rúbrica, por escrito | 15 min |
| [lab-01-python](./2-practicas/lab-01-python/README.md) | uv, pytest y ruff (check + format) desde Make | 60 min |
| [lab-02-docker](./2-practicas/lab-02-docker/README.md) | Build, run y push de imágenes; build incremental con `--iidfile` | 60 min |
| [lab-03-nodejs](./2-practicas/lab-03-nodejs/README.md) | pnpm install, test y build incremental con Make | 60 min |
| [lab-04-compose](./2-practicas/lab-04-compose/README.md) | `docker compose` orquestado con Make; `.env` como precondición | 60 min |
| [lab-05-multi-stack](./2-practicas/lab-05-multi-stack/README.md) | Backend Python + frontend Node en un Makefile; `-j` y `-k` | 60 min |
| [lab-06-targets-rotos](./2-practicas/lab-06-targets-rotos/README.md) | Seis bugs reales de un Makefile de servicio | 60 min |
| [3-proyecto](./3-proyecto/README.md) | Makefile de microservicio listo para producción | 3 h |
| **Total** | | **10 h** |

## Distribución del tiempo

```
 45 min  ███░░░░░░░░░░░░░░░░░  Teoría
 15 min  █░░░░░░░░░░░░░░░░░░░  Conocimiento
360 min  ████████████████████  Labs (6 × 60 min)
180 min  ██████████░░░░░░░░░░  Proyecto
```

## Verificación de completitud

El proyecto se comprueba desde la raíz del repositorio, sin red ni Docker
(los targets de contenedores se verifican con `make -n`):

```bash
./scripts/verificar-semana.sh 11
```

Además, estos comandos de los labs deben funcionar sin errores:

```bash
# Lab 01 — Python (requiere uv)
cd 2-practicas/lab-01-python/solucion && make install && make test && make lint

# Lab 02 — Docker (requiere docker)
cd 2-practicas/lab-02-docker/solucion && make build VERSION=1.0.0 && make info VERSION=1.0.0

# Lab 03 — Node.js (requiere node y pnpm)
cd 2-practicas/lab-03-nodejs/solucion && make install && make test && make build

# Lab 04 — compose (make config requiere Docker y .env)
cd 2-practicas/lab-04-compose/solucion && make info

# Lab 05 — multi-stack (requiere uv, node y pnpm)
cd 2-practicas/lab-05-multi-stack/solucion && make test && make lint

# Lab 06 — targets rotos
cd 2-practicas/lab-06-targets-rotos/solucion && make demo

# Proyecto (requiere uv)
cd 3-proyecto/solucion && make check && make info
```

Termina cada lab con su `make clean` (o `make clean-image`): ni `.venv/` ni `node_modules/` ni `.build/` se commitean.

## 🔗 Navegación

| Anterior | Actual | Siguiente |
|---|---|---|
| [Semana 10 — Paralelismo y recursión](../week-10-paralelismo_y_recursion/README.md) | **Semana 11 — Makefiles para proyectos modernos** | [Semana 12 — Make como orquestador DevOps](../week-12-make_como_orquestador_devops/README.md) |

[← Volver al índice del bootcamp](../README.md)
