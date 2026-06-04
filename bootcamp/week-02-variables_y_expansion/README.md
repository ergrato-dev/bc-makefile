# Semana 02 — Variables y Expansión en Make

## Descripción

Make tiene cuatro operadores de asignación que se comportan de manera radicalmente distinta. Esta semana dominarás cuándo se evalúa cada variable, cómo se pasan valores desde la línea de comandos, y cómo construir Makefiles parametrizables que se adapten a distintos entornos sin modificar el archivo.

## Objetivos de aprendizaje

Al terminar esta semana, podrás:

- Diferenciar `=`, `:=`, `?=` y `+=` y elegir el correcto en cada situación
- Predecir cuándo se expande una variable: al asignar vs. al usar
- Sobreescribir variables desde CLI (`make VAR=valor`) sin tocar el Makefile
- Usar `?=` para definir valores por defecto configurables por el usuario
- Detectar y corregir bugs de expansión: referencias circulares y referencias adelantadas
- Construir Makefiles multi-entorno con variables parametrizables

## Prerrequisitos

- Semana 01 completada: targets, dependencias, `.PHONY`, patrón `help`
- GNU Make ≥ 4.x instalado (`make --version`)
- Terminal Linux/macOS o WSL en Windows

## Contenido

| # | Tipo | Tema | Tiempo |
|---|------|------|--------|
| — | Contexto | [01-contexto.md](1-teoria/01-contexto.md) | 30 min |
| 1 | Lab | [lab-01-variables-basicas](2-practicas/lab-01-variables-basicas/) | 50 min |
| 2 | Lab | [lab-02-expansion-recursiva](2-practicas/lab-02-expansion-recursiva/) | 50 min |
| 3 | Lab | [lab-03-expansion-inmediata](2-practicas/lab-03-expansion-inmediata/) | 50 min |
| 4 | Lab | [lab-04-variables-condicionales](2-practicas/lab-04-variables-condicionales/) | 50 min |
| 5 | Lab | [lab-05-override-cli](2-practicas/lab-05-override-cli/) | 50 min |
| 6 | Lab | [lab-06-variables-rotas](2-practicas/lab-06-variables-rotas/) | 50 min |
| — | Proyecto | [Makefile multi-entorno](3-proyecto/) | 2h 30min |

**Total: 8 horas**

## Distribución del tiempo

```
[30 min] Leer 1-teoria/01-contexto.md
[50 min] lab-01 — Los cuatro operadores de asignación
[50 min] lab-02 — Expansión diferida con = y el riesgo de referencias circulares
[50 min] lab-03 — Expansión inmediata con := y $(shell ...)
[50 min] lab-04 — Valores por defecto con ?= y variables de entorno
[50 min] lab-05 — Parametrizar Makefiles desde la línea de comandos
[50 min] lab-06 — Depurar cuatro bugs de expansión de variables
[2h 30] Proyecto: Makefile parametrizable multi-entorno
```

## Verificación de completitud

Al terminar la semana, estos comandos deben funcionar sin errores:

```bash
cd 3-proyecto/solucion
make help
make config
make config ENV=staging
make build ENV=prod VERSION=1.2.0
make clean
```
