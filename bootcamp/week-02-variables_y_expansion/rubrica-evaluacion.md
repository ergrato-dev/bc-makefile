# Rúbrica de evaluación — Semana 02

**Total: 100 puntos**

## Labs (50 pts — 10 pts c/u × 5 labs activos)

El lab-06 es de depuración; los 10 puntos se distribuyen en lab-01 a lab-05.

| Lab | Criterio de evaluación | Pts |
|-----|------------------------|-----|
| lab-01 | Variables `=` `:=` `?=` `+=` definidas y usadas correctamente; outputs verificables | 10 |
| lab-02 | Diferencia entre `=` y `:=` demostrada con el caso de referencia adelantada | 10 |
| lab-03 | `$(shell ...)` con `:=` captura valor una sola vez; con `=` lo re-evalúa en cada uso | 10 |
| lab-04 | `?=` respeta variable preexistente del entorno; CLI la sobreescribe correctamente | 10 |
| lab-05 | Múltiples variables pasadas por CLI funcionan; `override` comportamiento documentado | 10 |

## Proyecto (30 pts)

| Criterio | Pts |
|----------|-----|
| `make config` y `make config ENV=prod` muestran configuraciones distintas | 8 |
| `make deploy ENV=staging` y `make deploy ENV=prod` usan destinos distintos | 8 |
| Variables con `?=` respetan variables de entorno exportadas; CLI las sobreescribe | 7 |
| `make clean` elimina artefactos sin errores | 4 |
| `make help` documenta todos los targets con descripción | 3 |

## Calidad del Makefile (20 pts)

| Criterio | Pts |
|----------|-----|
| Variables agrupadas al inicio por categoría con comentarios de sección | 5 |
| Todos los targets PHONY declarados correctamente | 5 |
| `:=` usado para capturar valores de `$(shell ...)` (no `=`) | 5 |
| Target `help` presente y funcional en todos los entregables | 5 |
