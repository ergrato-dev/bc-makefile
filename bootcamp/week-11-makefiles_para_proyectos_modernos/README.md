# Semana 11 — Makefiles para Proyectos Modernos

Make no es solo para proyectos C. Es la interfaz universal que unifica Python, Docker y Node.js bajo un mismo comando. Esta semana conviertes Make en el punto de entrada único de cualquier proyecto moderno: un `make test` que siempre funciona, sin importar si el proyecto usa pip, pnpm o Dockerfile.

Al terminar sabrás construir el Makefile que todo equipo de desarrollo quiere: uno que cualquier persona puede clonar y ejecutar sin leer documentación extensa.

## Objetivos de aprendizaje

Al terminar esta semana serás capaz de:

- Gestionar virtualenvs Python con Make usando archivos testigo (sentinel files)
- Construir, etiquetar y publicar imágenes Docker desde targets Make
- Envolver comandos pnpm/Node.js en un Makefile coherente con el resto del proyecto
- Orquestar `docker compose` (up, down, logs, exec) desde Make
- Combinar múltiples stacks en un solo Makefile con targets prefijados
- Identificar y corregir los cinco errores más comunes en Makefiles para proyectos reales

## Prerrequisitos

- Semanas 01–10 del bootcamp
- Python 3.14 con el módulo venv (labs 01 y 05, proyecto)
- Docker Engine 27+ con Compose v2 (labs 02, 04, 05 y proyecto)
- Node.js 26 LTS y pnpm (labs 03 y 05)
- GNU Make ≥ 4.x

## Tabla de contenidos

| Sección | Contenido | Tiempo |
|---------|-----------|--------|
| [1-teoria](./1-teoria/01-contexto.md) | Make como interfaz universal | 30 min |
| [lab-01-python](./2-practicas/lab-01-python/README.md) | Venv, pytest y flake8 desde Make | 50 min |
| [lab-02-docker](./2-practicas/lab-02-docker/README.md) | Build, run y push de imágenes Docker | 50 min |
| [lab-03-nodejs](./2-practicas/lab-03-nodejs/README.md) | pnpm install, test y build con Make | 50 min |
| [lab-04-compose](./2-practicas/lab-04-compose/README.md) | `docker compose` orquestado con Make | 50 min |
| [lab-05-multi-stack](./2-practicas/lab-05-multi-stack/README.md) | Makefile para proyecto Python + Node + Docker | 50 min |
| [lab-06-targets-rotos](./2-practicas/lab-06-targets-rotos/README.md) | Depuración de Makefiles en proyectos reales | 50 min |
| [3-proyecto](./3-proyecto/README.md) | Makefile de microservicio listo para producción | 2h 30min |
| **Total** | | **8h** |

## Distribución del tiempo

```
30 min  ████░░░░░░░░░░░░░░░░  Teoría
300 min ████████████████████  Labs (6 × 50 min)
150 min ████████████░░░░░░░░  Proyecto
```

## Verificación de completitud

Al terminar la semana, estos comandos deben funcionar sin errores:

```bash
# Lab 01 — Python (requiere python3 y pip)
cd 2-practicas/lab-01-python/solucion && make install && make test

# Lab 02 — Docker (requiere docker)
cd 2-practicas/lab-02-docker/solucion && make build && make info

# Lab 03 — Node.js (requiere node y pnpm)
cd 2-practicas/lab-03-nodejs/solucion && make install && make test

# Lab 04 — compose (requiere Docker con Compose v2)
cd 2-practicas/lab-04-compose/solucion && make info

# Lab 05 — multi-stack
cd 2-practicas/lab-05-multi-stack/solucion && make info

# Lab 06 — targets rotos
cd 2-practicas/lab-06-targets-rotos/solucion && make demo

# Proyecto (requiere python3 y docker)
cd 3-proyecto/solucion && make install && make test
cd 3-proyecto/solucion && make info
```

## 🔗 Navegación

| Anterior | Actual | Siguiente |
|---|---|---|
| [Semana 10 — Paralelismo y recursión](../week-10-paralelismo_y_recursion/README.md) | **Semana 11 — Makefiles para proyectos modernos** | [Semana 12 — Make como orquestador DevOps](../week-12-make_como_orquestador_devops/README.md) |

[← Volver al índice del bootcamp](../README.md)
