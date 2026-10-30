# Semana 09 — Condicionales, include y depuración

## Descripción

Los Makefiles reales no son monolíticos: usan condicionales para adaptarse al entorno, `include` para reutilizar lógica entre proyectos y herramientas de depuración y guardas de versión para saber por qué Make no hace lo que esperas, y en qué máquinas puede hacerlo. Esta semana dominas las técnicas que separan un Makefile profesional de uno básico.

Al terminar tendrás un sistema de Makefiles modulares que cualquier proyecto de tu organización puede importar y reutilizar sin copiar y pegar.

## Objetivos de aprendizaje

Al terminar esta semana serás capaz de:

- Distinguir qué ocurre al leer el Makefile y qué al ejecutar una receta
- Adaptar un Makefile al entorno con `ifeq`, `ifneq`, `ifdef` e `ifndef`, y validar variables con `$(error)`
- Separar un Makefile en módulos con `include` y `-include`, y generar un include con una regla
- Controlar qué variables reciben los sub-makes con paso explícito, `export`, `unexport` y `override`
- Depurar con `$(info)`, `$(warning)`, `make -n`, `--debug`, `--trace`, `--warn-undefined-variables` y `make -p`
- Proteger un Makefile con una guarda de versión mínima y detección de `.FEATURES`
- Diseñar una librería de módulos Make reutilizable por varios proyectos

## Prerrequisitos

- Semanas 01–08 del bootcamp (en especial `$(filter)`, `$(foreach)` y `$(addsuffix)`)
- GNU Make ≥ 4.3 (`make --version`; en macOS, `gmake`)
- bash, coreutils y `tar`

## Contenido

| # | Tipo | Tema | Tiempo |
|---|------|------|--------|
| — | Teoría | [01-contexto.md](./1-teoria/01-contexto.md) — fases, condicionales, include, depuración y portabilidad | 45 min |
| — | Conocimiento | [10 preguntas de la rúbrica](./rubrica-evaluacion.md#-conocimiento-30), respondidas por escrito | 15 min |
| 1 | Lab | [lab-01-condicionales](./2-practicas/lab-01-condicionales/README.md) | 60 min |
| 2 | Lab | [lab-02-include-modular](./2-practicas/lab-02-include-modular/README.md) | 60 min |
| 3 | Lab | [lab-03-depuracion](./2-practicas/lab-03-depuracion/README.md) | 60 min |
| 4 | Lab | [lab-04-scope-variables](./2-practicas/lab-04-scope-variables/README.md) | 60 min |
| 5 | Lab | [lab-05-portabilidad-y-diagnostico](./2-practicas/lab-05-portabilidad-y-diagnostico/README.md) | 60 min |
| 6 | Lab | [lab-06-makefile-roto](./2-practicas/lab-06-makefile-roto/README.md) | 60 min |
| — | Proyecto | [Librería de módulos Make reutilizables](./3-proyecto/README.md) | 3 h |

**Total: 10 horas**

Diagramas de apoyo en [0-assets/](./0-assets/), recursos en [4-recursos/](./4-recursos/)
y términos nuevos en el [glosario](./5-glosario/README.md).

## Distribución del tiempo

```
[45 min] Teoría: 1-teoria/01-contexto.md
[15 min] Conocimiento: 10 preguntas de la rúbrica
[60 min] lab-01 — Condicionales y validación al leer
[60 min] lab-02 — Módulos .mk e include generado
[60 min] lab-03 — $(info), $(warning), $(error), -n y --debug
[60 min] lab-04 — Variables entre Make padre e hijo
[60 min] lab-05 — Guarda de versión, --trace, --warn-undefined-variables
[60 min] lab-06 — Makefile heredado con 8 errores
[3 h   ] Proyecto: librería shared-mk/ con guarda de versión y doctor
```

## Verificación de completitud

Desde la raíz del repositorio, el autograding del proyecto (18 comprobaciones,
60 de los 100 puntos del Producto; ver la [rúbrica](./rubrica-evaluacion.md)):

```bash
./scripts/verificar-semana.sh 09
```

Y en tu copia del proyecto:

```bash
cd 3-proyecto/starter
make doctor
make all && make test
make ENV=staging deploy
make clean
```

## 🔗 Navegación

| Anterior | Actual | Siguiente |
|---|---|---|
| [Semana 08 — Funciones avanzadas](../week-08-funciones_avanzadas/README.md) | **Semana 09 — Condicionales, include y depuración** | [Semana 10 — Paralelismo y recursión](../week-10-paralelismo_y_recursion/README.md) |

[← Volver al índice del bootcamp](../README.md)
