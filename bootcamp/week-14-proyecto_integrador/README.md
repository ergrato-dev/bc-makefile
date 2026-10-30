# Semana 14 — Proyecto Integrador

## Descripción

Trece semanas de Make se juntan aquí. No hay conceptos nuevos: construyes un build system multi-lenguaje (Python con uv, Node.js con pnpm y un healthcheck en C) con modo estricto, módulos `.mk` compartidos, recursión segura con `-j`, stamps, imágenes no-root, hooks y guardas. El resultado es un sistema de build que un equipo podría adoptar mañana.

## Objetivos de aprendizaje

Al terminar esta semana, podrás:

- Combinar pattern rules, `-MMD -MP` y directorios order-only en un build C que recompila exactamente lo necesario
- Encadenar un pipeline Python + Docker con uv que verifica que la imagen no corre como root
- Instalar hooks con `core.hooksPath` que solo llaman a `make check`
- Diseñar módulos `.mk` reutilizables y orquestar servicios con un target phony por servicio y `$(MAKE) -C`
- Evitar trabajo repetido con stamps y paralelizar con `-j` sin carreras, con salida legible (`-O`)
- Diagnosticar un build roto eligiendo la herramienta de Make que revela cada error
- Justificar cada decisión del build system con la semana del bootcamp que la explica

## Prerrequisitos

- Semanas 01–13 completadas (en especial la 03, modo estricto; la 06, dependencias; la 10, paralelismo y recursión; y la 13, seguridad)
- GNU Make ≥ 4.3 (`make --version`; en macOS `gmake`)
- bash, git y gcc (o clang)
- uv 0.12.x y pnpm 11.x (lab 02 y proyecto). Python siempre con uv, nunca pip; Node.js siempre con pnpm, nunca npm
- Docker (solo lab 02; el autograding no lo necesita)

## Contenido

| # | Tipo | Tema | Tiempo |
|---|------|------|--------|
| — | Teoría | [01-contexto.md](1-teoria/01-contexto.md) | 45 min |
| — | Conocimiento | [10 preguntas](rubrica-evaluacion.md#-conocimiento-30) | 15 min |
| 1 | Lab | [lab-01-build-c-completo](2-practicas/lab-01-build-c-completo/) | 60 min |
| 2 | Lab | [lab-02-pipeline-python-docker](2-practicas/lab-02-pipeline-python-docker/) | 60 min |
| 3 | Lab | [lab-03-ci-local](2-practicas/lab-03-ci-local/) | 60 min |
| 4 | Lab | [lab-04-modulos-compartidos](2-practicas/lab-04-modulos-compartidos/) | 60 min |
| 5 | Lab | [lab-05-optimizacion-paralela](2-practicas/lab-05-optimizacion-paralela/) | 60 min |
| 6 | Lab | [lab-06-debug-produccion](2-practicas/lab-06-debug-produccion/) | 60 min |
| — | Proyecto | [Build system multi-lenguaje](3-proyecto/) | 3 h |

**Total: 10 horas**

## Distribución del tiempo

```
[45 min] Leer 1-teoria/01-contexto.md
[15 min] Responder las 10 preguntas de Conocimiento
[60 min] lab-01 — build C con -MMD -MP, order-only, -j y clean con guarda
[60 min] lab-02 — lint, test, build-image y check-nonroot con uv y Docker
[60 min] lab-03 — hooks con core.hooksPath que llaman a make check
[60 min] lab-04 — módulos .mk compartidos y orquestador con subdirectorios phony
[60 min] lab-05 — stamps, -j sin carreras y salida sincronizada con -O
[60 min] lab-06 — cinco errores de producción, cinco herramientas de diagnóstico
[3 h]    Proyecto: build system multi-lenguaje completo
```

## Verificación de completitud

Desde la raíz del repositorio (sin red, sin Docker y sin tocar la configuración
git del repo: los pipelines corren sobre una copia temporal con `UV=: PNPM=:` y
los hooks en un repositorio temporal):

```bash
./scripts/verificar-semana.sh 14
```

## 🔗 Navegación

| Anterior | Actual | Siguiente |
|---|---|---|
| [Semana 13 — Seguridad, portabilidad y alternativas](../week-13-seguridad_portabilidad_y_alternativas/README.md) | **Semana 14 — Proyecto integrador** | — |

[← Volver al índice del bootcamp](../README.md)
