# Semana 08 — Funciones Avanzadas de Make

## Descripción

Con las funciones de la semana anterior descubres y transformas archivos. Con las funciones de esta semana *programas* Make: iteras sobre listas, defines funciones reutilizables, generas reglas en tiempo de ejecución y consultas el sistema operativo. Cuatro herramientas que convierten un Makefile en un meta-programa.

Esta semana dominas `$(foreach)`, `$(call)`, `$(eval)` y `$(shell)` — las funciones que separan un Makefile avanzado de uno profesional.

## Objetivos de aprendizaje

Al terminar esta semana serás capaz de:

- Iterar sobre listas con `$(foreach)` para generar texto repetitivo sin copy-paste
- Definir funciones Make reutilizables con `define...endef` y llamarlas con `$(call)`
- Generar reglas y variables dinámicamente en tiempo de evaluación con `$(eval)`
- Capturar la salida de comandos de shell con `$(shell)` para integrar información del sistema
- Combinar las cuatro funciones para construir un Meta-Makefile que genera sus propias reglas

## Prerrequisitos

- Semana 01: targets, dependencias, recetas, `.PHONY`
- Semana 02: variables (`=`, `:=`, `?=`, `+=`), override CLI
- Semana 04: variables automáticas (`$@`, `$<`, `$^`, `$*`)
- Semana 05: pattern rules (`%.o: %.c`), static pattern rules
- Semana 07: `$(wildcard)`, `$(patsubst)`, `$(filter)`, `$(dir)`, `$(notdir)`
- GNU Make ≥ 4.x y GCC instalado

## Tabla de contenidos

| Sección | Contenido | Tiempo |
|---------|-----------|--------|
| [1-teoria](./1-teoria/01-contexto.md) | Referencia rápida de funciones avanzadas | 30 min |
| [lab-01-foreach](./2-practicas/lab-01-foreach/README.md) | Iteración con foreach | 50 min |
| [lab-02-call](./2-practicas/lab-02-call/README.md) | Funciones reutilizables con call | 50 min |
| [lab-03-eval](./2-practicas/lab-03-eval/README.md) | Generación dinámica de reglas con eval | 50 min |
| [lab-04-shell](./2-practicas/lab-04-shell/README.md) | Integración con el shell | 50 min |
| [lab-05-combinadas](./2-practicas/lab-05-combinadas/README.md) | Meta-build system con las 4 funciones | 50 min |
| [lab-06-funciones-rotas](./2-practicas/lab-06-funciones-rotas/README.md) | Depuración de funciones avanzadas | 50 min |
| [3-proyecto](./3-proyecto/README.md) | Meta-Makefile: reglas que se generan solas | 2h 30min |
| **Total** | | **8h** |

## Distribución del tiempo

```
30 min  ████░░░░░░░░░░░░░░░░  Teoría
300 min ████████████████████  Labs (6 × 50 min)
150 min ████████████░░░░░░░░  Proyecto
```

## Verificación de completitud

Desde la raíz del repositorio, el autograding del proyecto
(ver [rúbrica](./rubrica-evaluacion.md)):

```bash
./scripts/verificar-semana.sh 08
```

Al terminar la semana, estos comandos deben funcionar sin errores:

```bash
# Lab 01 — foreach
cd 2-practicas/lab-01-foreach/solucion && make demo

# Lab 02 — call
cd 2-practicas/lab-02-call/solucion && make demo

# Lab 03 — eval
cd 2-practicas/lab-03-eval/solucion && make demo

# Lab 04 — shell
cd 2-practicas/lab-04-shell/solucion && make info

# Lab 05 — combinadas
cd 2-practicas/lab-05-combinadas/solucion && make info

# Lab 06 — rotas
cd 2-practicas/lab-06-funciones-rotas/solucion && make demo

# Proyecto
cd 3-proyecto/solucion && make info
cd 3-proyecto/solucion && make generate
```

## 🔗 Navegación

| Anterior | Actual | Siguiente |
|---|---|---|
| [Semana 07 — Funciones de texto y archivo](../week-07-funciones_de_texto_y_archivo/README.md) | **Semana 08 — Funciones avanzadas** | [Semana 09 — Condicionales, include y depuración](../week-09-condicionales_include_y_depuracion/README.md) |

[← Volver al índice del bootcamp](../README.md)
