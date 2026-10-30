# Semana 07 — Funciones de Texto y Archivo

## Descripción

Un Makefile con fuentes hardcodeadas es deuda técnica inmediata: cada archivo nuevo exige editar el Makefile a mano. Las funciones de texto de Make resuelven esto — descubren, transforman y filtran listas de archivos dinámicamente. Con tres líneas reemplazas un bloque de 30.

Esta semana dominas `$(wildcard)`, `$(patsubst)`, `$(filter)`, `$(dir)`, `$(notdir)` y las funciones que convierten un Makefile frágil en un sistema robusto que se adapta solo.

## Objetivos de aprendizaje

Al terminar esta semana serás capaz de:

- Usar `$(wildcard)` para descubrir archivos automáticamente sin listas hardcodeadas
- Transformar listas de archivos con `$(patsubst)` y `$(subst)`
- Filtrar subconjuntos de listas con `$(filter)` y `$(filter-out)`
- Manipular rutas con `$(dir)`, `$(notdir)`, `$(basename)` y `$(suffix)`
- Agregar prefijos y sufijos con `$(addprefix)` y `$(addsuffix)`
- Combinar múltiples funciones para construir un build system auto-configurable

## Prerrequisitos

- Semana 01: targets, dependencias, recetas, `.PHONY`
- Semana 02: variables (`=`, `:=`, `?=`, `+=`), override CLI
- Semana 04: variables automáticas (`$@`, `$<`, `$^`, `$*`)
- Semana 05: pattern rules (`%.o: %.c`), static pattern rules
- GNU Make ≥ 4.x y GCC instalado

## Tabla de contenidos

| Sección | Contenido | Tiempo |
|---------|-----------|--------|
| [1-teoria](./1-teoria/01-contexto.md) | Referencia rápida de funciones | 30 min |
| [lab-01-wildcard](./2-practicas/lab-01-wildcard/README.md) | Descubrimiento automático de archivos | 50 min |
| [lab-02-patsubst](./2-practicas/lab-02-patsubst/README.md) | Transformación de listas con patsubst | 50 min |
| [lab-03-filter](./2-practicas/lab-03-filter/README.md) | Filtrado con filter y filter-out | 50 min |
| [lab-04-rutas](./2-practicas/lab-04-rutas/README.md) | Manipulación de rutas y extensiones | 50 min |
| [lab-05-combinadas](./2-practicas/lab-05-combinadas/README.md) | Build system auto-configurable | 50 min |
| [lab-06-funciones-rotas](./2-practicas/lab-06-funciones-rotas/README.md) | Depuración de funciones incorrectas | 50 min |
| [3-proyecto](./3-proyecto/README.md) | Generador automático de reglas | 2h 30min |
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
./scripts/verificar-semana.sh 07
```

Al terminar la semana, estos comandos deben funcionar sin errores:

```bash
# Lab 01 — wildcard
cd 2-practicas/lab-01-wildcard/solucion && make list-sources

# Lab 02 — patsubst
cd 2-practicas/lab-02-patsubst/solucion && make demo

# Lab 03 — filter
cd 2-practicas/lab-03-filter/solucion && make demo

# Lab 04 — rutas
cd 2-practicas/lab-04-rutas/solucion && make demo

# Lab 05 — combinadas
cd 2-practicas/lab-05-combinadas/solucion && make all

# Lab 06 — rotas
cd 2-practicas/lab-06-funciones-rotas/solucion && make demo

# Proyecto
cd 3-proyecto/solucion && make report
cd 3-proyecto/solucion && make all
```

## 🔗 Navegación

| Anterior | Actual | Siguiente |
|---|---|---|
| [Semana 06 — Dependencias automáticas y targets especiales](../week-06-dependencias_y_targets_especiales/README.md) | **Semana 07 — Funciones de texto y archivo** | [Semana 08 — Funciones avanzadas](../week-08-funciones_avanzadas/README.md) |

[← Volver al índice del bootcamp](../README.md)
