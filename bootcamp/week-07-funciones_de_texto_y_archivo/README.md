# Semana 07 — Funciones de Texto y Archivo

## Descripción

Un Makefile con fuentes hardcodeadas es deuda técnica inmediata: cada archivo nuevo exige editar el Makefile a mano. Las funciones de texto de Make resuelven esto — descubren, transforman y filtran listas de archivos dinámicamente. Con tres líneas reemplazas un bloque de 30.

Esta semana dominas `$(wildcard)`, `$(patsubst)`, `$(filter)`, `$(dir)`, `$(notdir)`, `$(strip)`, `$(words)` y las funciones que convierten un Makefile frágil en un sistema que se adapta solo.

## Objetivos de aprendizaje

Al terminar esta semana, podrás:

- Usar `$(wildcard)` para descubrir archivos automáticamente sin listas hardcodeadas
- Transformar listas de archivos con `$(patsubst)` y `$(subst)`
- Filtrar subconjuntos de listas con `$(filter)` y `$(filter-out)`
- Manipular rutas con `$(dir)`, `$(notdir)`, `$(basename)` y `$(suffix)`
- Agregar prefijos y sufijos con `$(addprefix)` y `$(addsuffix)`
- Contar, seleccionar y limpiar listas con `$(sort)`, `$(words)`, `$(word)` y `$(strip)`
- Validar argumentos de línea de comandos con `$(filter)` y `$(error)`
- Combinar múltiples funciones para construir un build system auto-configurable

## Prerrequisitos

- Semanas 01–06 completadas; en especial la 03 (preámbulo estricto, guardas de `rm -rf`) y la 05 (reglas de patrón)
- GNU Make ≥ 4.3 (`make --version`; en macOS `gmake`)
- `gcc` instalado — requerido para los labs 01 y 05 y el proyecto (`gcc --version`)

## Contenido

| # | Tipo | Tema | Tiempo |
|---|------|------|--------|
| — | Teoría | [01-contexto.md](1-teoria/01-contexto.md) · [02-trampas-y-utilidades.md](1-teoria/02-trampas-y-utilidades.md) | 45 min |
| — | Conocimiento | [10 preguntas](rubrica-evaluacion.md#-conocimiento-30) | 15 min |
| 1 | Lab | [lab-01-wildcard](2-practicas/lab-01-wildcard/README.md) | 60 min |
| 2 | Lab | [lab-02-patsubst](2-practicas/lab-02-patsubst/README.md) | 60 min |
| 3 | Lab | [lab-03-filter](2-practicas/lab-03-filter/README.md) | 60 min |
| 4 | Lab | [lab-04-rutas](2-practicas/lab-04-rutas/README.md) | 60 min |
| 5 | Lab | [lab-05-combinadas](2-practicas/lab-05-combinadas/README.md) | 60 min |
| 6 | Lab | [lab-06-funciones-rotas](2-practicas/lab-06-funciones-rotas/README.md) | 60 min |
| — | Proyecto | [Build multi-módulo auto-configurable](3-proyecto/README.md) | 3 h |

**Total: 10 horas**

Apoyo: [diagramas](0-assets/) · [recursos](4-recursos/) · [glosario](5-glosario/README.md)

## Distribución del tiempo

```
[45 min] Leer 1-teoria/ (01-contexto y 02-trampas-y-utilidades)
[15 min] Responder las 10 preguntas de Conocimiento
[60 min] lab-01 — $(wildcard): descubrir fuentes, guarda de lista vacía, prueba de existencia
[60 min] lab-02 — $(patsubst), $(VAR:a=b) y $(subst): dónde rompe subst
[60 min] lab-03 — $(filter)/$(filter-out) y filter como prueba de pertenencia
[60 min] lab-04 — dir, notdir, basename, suffix, addprefix y sus casos límite
[60 min] lab-05 — build auto-configurable con subdirectorios
[60 min] lab-06 — depurar seis bugs, incluidos espacios invisibles y $(strip)
[3 h]    Proyecto: build multi-módulo con report, manifest y objs MODULE=...
```

## Verificación de completitud

Desde la raíz del repositorio:

```bash
./scripts/verificar-semana.sh 07
```

Comprueba tu proyecto (`3-proyecto/starter/`) contra las 17 comprobaciones de [`checks.json`](checks.json). Cada fallo trae una pista con el lab y el paso donde se arregla.

## 🔗 Navegación

| Anterior | Actual | Siguiente |
|---|---|---|
| [Semana 06 — Dependencias automáticas y targets especiales](../week-06-dependencias_y_targets_especiales/README.md) | **Semana 07 — Funciones de texto y archivo** | [Semana 08 — Funciones avanzadas](../week-08-funciones_avanzadas/README.md) |

[← Volver al índice del bootcamp](../README.md)
