# Semana 14 — Proyecto Integrador

Diez semanas de Make confluyen aquí. Esta semana no introduces conceptos nuevos: construyes un build system multi-lenguaje completo que integra variables automáticas, pattern rules, funciones avanzadas, módulos con `include`, recursión, condicionales, hooks de CI y orquestación DevOps. El resultado es un sistema de build profesional que podrías llevar a producción mañana.

Al terminar tendrás un build system reutilizable que gestiona servicios en Python, Node.js e infraestructura desde un único punto de control, con pipeline CI local, módulos compartidos y diagnóstico integrado.

## Objetivos de aprendizaje

Al terminar esta semana serás capaz de:

- Combinar pattern rules, wildcards y variables automáticas en un build C real con dependencias automáticas
- Construir un pipeline completo Python + Docker: lint, test, build image, push
- Implementar CI local con git hooks gestionados desde Make
- Diseñar una librería de módulos `.mk` reutilizables entre proyectos
- Optimizar builds con paralelismo (`-j`), timestamps y detección inteligente de cambios
- Orquestar un sistema multi-servicio desde un Makefile raíz con recursión

## Prerrequisitos

- Semanas 01–13 del bootcamp completas
- GNU Make ≥ 4.x
- bash, git
- Docker (labs 02 y proyecto)
- Python 3.10+ y Node.js 18+ (labs y proyecto)
- gcc (lab 01)

## Tabla de contenidos

| Sección | Contenido | Tiempo |
|---------|-----------|--------|
| [1-teoria](./1-teoria/01-contexto.md) | Repaso integrador: qué combinar y cuándo | 30 min |
| [lab-01-build-c-completo](./2-practicas/lab-01-build-c-completo/README.md) | Build C con dependencias automáticas y pattern rules | 50 min |
| [lab-02-pipeline-python-docker](./2-practicas/lab-02-pipeline-python-docker/README.md) | Pipeline lint → test → build image → push | 50 min |
| [lab-03-ci-local](./2-practicas/lab-03-ci-local/README.md) | Git hooks pre-commit y pre-push gestionados por Make | 50 min |
| [lab-04-modulos-compartidos](./2-practicas/lab-04-modulos-compartidos/README.md) | Librería `.mk` compartida entre múltiples proyectos | 50 min |
| [lab-05-optimizacion-paralela](./2-practicas/lab-05-optimizacion-paralela/README.md) | Builds paralelas, stamps y detección de cambios | 50 min |
| [lab-06-debug-produccion](./2-practicas/lab-06-debug-produccion/README.md) | Diagnosticar y corregir un build system roto en producción | 50 min |
| [3-proyecto](./3-proyecto/README.md) | Build system multi-lenguaje completo | 2h 30min |
| **Total** | | **8h** |

## Distribución del tiempo

```
30 min  ████░░░░░░░░░░░░░░░░  Teoría (repaso integrador)
300 min ████████████████████  Labs (6 × 50 min)
150 min ████████████░░░░░░░░  Proyecto final
```

## Verificación de completitud

Al terminar la semana, estos comandos deben funcionar sin errores:

```bash
# Lab 01 — build C completo
cd 2-practicas/lab-01-build-c-completo/solucion && make all

# Lab 02 — pipeline Python + Docker
cd 2-practicas/lab-02-pipeline-python-docker/solucion && make ci

# Lab 03 — CI local con git hooks
cd 2-practicas/lab-03-ci-local/solucion && make hooks-install && make check

# Lab 04 — módulos compartidos
cd 2-practicas/lab-04-modulos-compartidos/solucion/service-a && make build
cd 2-practicas/lab-04-modulos-compartidos/solucion/service-b && make build

# Lab 05 — optimización paralela
cd 2-practicas/lab-05-optimizacion-paralela/solucion && make -j4 all

# Lab 06 — debug producción (versión corregida)
cd 2-practicas/lab-06-debug-produccion/solucion && make ci

# Proyecto integrador
cd 3-proyecto/solucion && make all
cd 3-proyecto/solucion && make ENV=staging deploy
cd 3-proyecto/solucion && make ci
```

## 🔗 Navegación

| Anterior | Actual | Siguiente |
|---|---|---|
| [Semana 13 — Seguridad, portabilidad y alternativas](../week-13-seguridad_portabilidad_y_alternativas/README.md) | **Semana 14 — Proyecto integrador** | — |

[← Volver al índice del bootcamp](../README.md)
