# Semana 09 — Condicionales, include y depuración

Los Makefiles reales no son monolíticos: usan condicionales para adaptarse al entorno, `include` para reutilizar lógica entre proyectos, recursión para gestionar repositorios multi-módulo, y herramientas de depuración para diagnosticar por qué Make no hace lo que esperas. Esta semana dominas las técnicas que separan un Makefile profesional de uno básico.

Al terminar tendrás un sistema de Makefiles modulares que cualquier proyecto de tu organización puede importar y reutilizar sin copiar y pegar.

## Objetivos de aprendizaje

Al terminar esta semana serás capaz de:

- Usar condicionales (`ifeq`, `ifneq`, `ifdef`, `ifndef`) para adaptar el comportamiento según el entorno
- Separar un Makefile en módulos con `include` y `-include`
- Construir builds recursivos con `$(MAKE)` en repositorios multi-módulo
- Depurar Makefiles con `make -n`, `--debug`, `$(info)`, `$(warning)` y `$(error)`
- Controlar el scope de variables entre Make padre e hijos
- Diseñar una librería de módulos Make reutilizables

## Prerrequisitos

- Semanas 01–08 del bootcamp
- GNU Make ≥ 4.x
- bash
- Python 3.10+ (algunos labs)
- git

## Tabla de contenidos

| Sección | Contenido | Tiempo |
|---------|-----------|--------|
| [1-teoria](./1-teoria/01-contexto.md) | Condicionales, include, recursión, depuración | 30 min |
| [lab-01-condicionales](./2-practicas/lab-01-condicionales/README.md) | Condicionales `ifeq`, `ifdef`, lógica de entorno | 50 min |
| [lab-02-include-modular](./2-practicas/lab-02-include-modular/README.md) | Separar Makefile en módulos con `include` | 50 min |
| [lab-03-recursion](./2-practicas/lab-03-recursion/README.md) | Builds recursivos con `$(MAKE)` | 50 min |
| [lab-04-depuracion](./2-practicas/lab-04-depuracion/README.md) | Depurar con `--debug`, `$(info)`, `$(error)` | 50 min |
| [lab-05-scope-variables](./2-practicas/lab-05-scope-variables/README.md) | Scope de variables en Make recursivo | 50 min |
| [lab-06-makefile-roto](./2-practicas/lab-06-makefile-roto/README.md) | Diagnosticar y corregir Makefiles con errores | 50 min |
| [3-proyecto](./3-proyecto/README.md) | Librería de módulos Make reutilizables | 2h 30min |
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
# Lab 01 — condicionales
cd 2-practicas/lab-01-condicionales/solucion && make info ENV=production

# Lab 02 — include modular
cd 2-practicas/lab-02-include-modular/solucion && make build

# Lab 03 — recursion
cd 2-practicas/lab-03-recursion/solucion && make all

# Lab 04 — depuracion
cd 2-practicas/lab-04-depuracion/solucion && make debug-all

# Lab 05 — scope de variables
cd 2-practicas/lab-05-scope-variables/solucion && make show-scope

# Lab 06 — makefile-roto (versión corregida)
cd 2-practicas/lab-06-makefile-roto/solucion && make ci

# Proyecto
cd 3-proyecto/solucion && make all
cd 3-proyecto/solucion && make ENV=staging deploy
```

## 🔗 Navegación

| Anterior | Actual | Siguiente |
|---|---|---|
| [Semana 08 — Funciones avanzadas](../week-08-funciones_avanzadas/README.md) | **Semana 09 — Condicionales, include y depuración** | [Semana 10 — Paralelismo y recursión](../week-10-paralelismo_y_recursion/README.md) |

[← Volver al índice del bootcamp](../README.md)
