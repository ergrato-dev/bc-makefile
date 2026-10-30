# Semana 02 — Variables y Expansión en Make

## Descripción

Make tiene varios operadores de asignación que se comportan de manera radicalmente distinta. Esta semana dominarás cuándo se evalúa cada variable, de dónde sale su valor (Makefile, entorno o línea de comandos) y cómo construir Makefiles parametrizables que se adapten a distintos entornos sin modificar el archivo.

## Objetivos de aprendizaje

Al terminar esta semana, podrás:

- Diferenciar `=`, `:=`, `?=`, `+=` y `!=` y elegir el correcto en cada situación
- Predecir cuándo se expande una variable: al asignar vs. al usar
- Comprobar el tipo real de una variable con `$(flavor VAR)` y `make -p`
- Averiguar de dónde salió un valor con `$(origin VAR)` y explicar la precedencia entre `override`, línea de comandos, Makefile y entorno
- Sobreescribir variables desde la CLI y forzar valores obligatorios con `override`
- Detectar y corregir bugs de expansión: referencias circulares y referencias adelantadas
- Construir Makefiles multi-entorno con variables parametrizables

## Prerrequisitos

- Semana 01 completada: targets, dependencias, `.PHONY`, patrón `help`
- GNU Make ≥ 4.3 (`make --version`; en macOS `gmake`)
- Terminal Linux/macOS o WSL2 en Windows
- `git` (el proyecto calcula la versión con `git describe`)

## Contenido

| # | Tipo | Tema | Tiempo |
|---|------|------|--------|
| — | Teoría | [01-contexto.md](1-teoria/01-contexto.md) · [02-origen-y-precedencia.md](1-teoria/02-origen-y-precedencia.md) | 45 min |
| — | Conocimiento | [10 preguntas](rubrica-evaluacion.md#-conocimiento-30) | 15 min |
| 1 | Lab | [lab-01-variables-basicas](2-practicas/lab-01-variables-basicas/) | 60 min |
| 2 | Lab | [lab-02-expansion-recursiva](2-practicas/lab-02-expansion-recursiva/) | 60 min |
| 3 | Lab | [lab-03-expansion-inmediata](2-practicas/lab-03-expansion-inmediata/) | 60 min |
| 4 | Lab | [lab-04-variables-condicionales](2-practicas/lab-04-variables-condicionales/) | 60 min |
| 5 | Lab | [lab-05-override-cli](2-practicas/lab-05-override-cli/) | 60 min |
| 6 | Lab | [lab-06-variables-rotas](2-practicas/lab-06-variables-rotas/) | 60 min |
| — | Proyecto | [Makefile multi-entorno](3-proyecto/) | 3 h |

**Total: 10 horas**

## Distribución del tiempo

```
[45 min] Leer 1-teoria/ (operadores + origen, sabor y precedencia)
[15 min] Responder las 10 preguntas de Conocimiento
[60 min] lab-01 — Los operadores de asignación y $(flavor)
[60 min] lab-02 — Expansión diferida con = y la recursión infinita
[60 min] lab-03 — Expansión inmediata: := con $(shell ...) frente a !=
[60 min] lab-04 — Valores por defecto con ?=, entorno y $(origin)
[60 min] lab-05 — Parametrizar desde la CLI y override
[60 min] lab-06 — Depurar cuatro bugs de expansión de variables
[3 h]    Proyecto: Makefile parametrizable multi-entorno
```

## Verificación de completitud

Desde la raíz del repositorio:

```bash
./scripts/verificar-semana.sh 02
```

Comprueba tu proyecto (`3-proyecto/starter/`) contra los 14 requisitos
verificables de la semana. Al terminar deben pasar todos, y estos comandos
deben dar salidas distintas dentro de tu proyecto:

```bash
make config
make config ENV=staging
ENV=prod make config
make build ENV=prod VERSION=1.2.0 BUILD_ARGS=--no-cache
```

## 🔗 Navegación

| Anterior | Actual | Siguiente |
|---|---|---|
| [Semana 01 — Tu primer Makefile](../week-01-tu_primer_makefile/README.md) | **Semana 02 — Variables y expansión** | [Semana 03 — Shell en recetas y modo estricto](../week-03-shell_y_modo_estricto/README.md) |

[← Volver al índice del bootcamp](../README.md)
