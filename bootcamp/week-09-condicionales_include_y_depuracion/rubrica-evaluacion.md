# Rúbrica de Evaluación — Semana 09

**Total: 100 puntos**

---

## Labs completados (50 pts)

| Lab | Criterio de evaluación | Pts |
|-----|----------------------|-----|
| lab-01-condicionales | `make info ENV=production` muestra configuración de prod; `make info ENV=development` muestra configuración de dev | 10 |
| lab-02-include-modular | `make build` funciona importando módulos con `include`; `make help` lista targets de todos los módulos | 10 |
| lab-03-depuracion | `make debug-all` ejecuta diagnóstico completo; `$(info)` y `$(warning)` usados correctamente | 10 |
| lab-04-scope-variables | `make show-scope` muestra correctamente qué variables heredan los submakes y cuáles no | 10 |

## Proyecto semanal (30 pts)

| Criterio | Pts |
|----------|-----|
| `make all` funciona desde la raíz e invoca submakes de cada módulo | 10 |
| Los módulos `.mk` son reutilizables: un nuevo proyecto puede importarlos con `include` | 8 |
| `make ENV=staging deploy` adapta el comportamiento correctamente con condicionales | 7 |
| `make debug` genera un reporte de diagnóstico útil (variables, entorno, dependencias) | 5 |

## Calidad del Makefile (20 pts)

| Criterio | Pts |
|----------|-----|
| Todos los targets que no producen archivos tienen `.PHONY` | 5 |
| Target `help` presente y documenta todos los targets con `##` | 5 |
| Variables en `UPPER_SNAKE_CASE`; targets en `lower-kebab-case` | 5 |
| Los módulos `.mk` tienen encabezado documentado y no producen efectos secundarios al importarse | 5 |
