# Semana 12 — Make como Orquestador DevOps

Un Makefile bien diseñado puede reemplazar scripts de CI/CD, instalar git hooks, gestionar secretos de entorno y ejecutar un pipeline completo antes de que el código llegue al servidor. Esta semana conviertes Make en la columna vertebral del flujo DevOps local: un `make ci` que cualquier desarrollador puede ejecutar y que replica exactamente lo que corre en el servidor.

Al terminar sabrás construir el pipeline local que los equipos de alto rendimiento usan para detectar problemas antes del `git push`.

## Objetivos de aprendizaje

Al terminar esta semana serás capaz de:

- Cargar y validar archivos `.env` con Make sin exponer secretos
- Instalar y gestionar git hooks desde targets Make
- Construir un pipeline CI/CD local reproducible con Make
- Implementar targets de calidad de código (lint, format, security scan)
- Automatizar releases con versionado semántico desde Make
- Depurar pipelines rotos usando las técnicas de Make

## Prerrequisitos

- Semanas 01–11 del bootcamp
- GNU Make ≥ 4.x
- git instalado y configurado
- bash (los hooks usan bash)
- Python 3.10+ (labs 03 y 04)
- Opcional: shellcheck, hadolint (lab 04)

## Tabla de contenidos

| Sección | Contenido | Tiempo |
|---------|-----------|--------|
| [1-teoria](./1-teoria/01-contexto.md) | Make como orquestador DevOps | 30 min |
| [lab-01-env-secrets](./2-practicas/lab-01-env-secrets/README.md) | Cargar `.env` y validar secretos | 50 min |
| [lab-02-git-hooks](./2-practicas/lab-02-git-hooks/README.md) | Instalar y gestionar git hooks | 50 min |
| [lab-03-ci-local](./2-practicas/lab-03-ci-local/README.md) | Pipeline CI/CD local completo | 50 min |
| [lab-04-lint-calidad](./2-practicas/lab-04-lint-calidad/README.md) | Targets de calidad y análisis estático | 50 min |
| [lab-05-release](./2-practicas/lab-05-release/README.md) | Automatizar releases con versionado semántico | 50 min |
| [lab-06-pipeline-roto](./2-practicas/lab-06-pipeline-roto/README.md) | Depurar un pipeline con errores intencionales | 50 min |
| [3-proyecto](./3-proyecto/README.md) | Pipeline local completo | 2h 30min |
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
# Lab 01 — env-secrets
cd 2-practicas/lab-01-env-secrets/solucion && make env-check

# Lab 02 — git-hooks
cd 2-practicas/lab-02-git-hooks/solucion && make hooks-status

# Lab 03 — ci-local
cd 2-practicas/lab-03-ci-local/solucion && make ci

# Lab 04 — lint-calidad
cd 2-practicas/lab-04-lint-calidad/solucion && make lint

# Lab 05 — release
cd 2-practicas/lab-05-release/solucion && make version

# Lab 06 — pipeline-roto (la solución corregida)
cd 2-practicas/lab-06-pipeline-roto/solucion && make ci

# Proyecto
cd 3-proyecto/solucion && make ci
cd 3-proyecto/solucion && make env-check
```

## 🔗 Navegación

| Anterior | Actual | Siguiente |
|---|---|---|
| [Semana 11 — Makefiles para proyectos modernos](../week-11-makefiles_para_proyectos_modernos/README.md) | **Semana 12 — Make como orquestador DevOps** | [Semana 13 — Seguridad, portabilidad y alternativas](../week-13-seguridad_portabilidad_y_alternativas/README.md) |

[← Volver al índice del bootcamp](../README.md)
