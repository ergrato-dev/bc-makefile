# Rúbrica de Evaluación — Semana 12

**Total: 100 puntos**

---

## Labs completados (50 pts)

| Lab | Criterio de evaluación | Pts |
|-----|----------------------|-----|
| lab-01-env-secrets | `make env-check` detecta variables faltantes y muestra error claro | 10 |
| lab-02-git-hooks | `make hooks-install` instala hooks; `make hooks-status` reporta estado | 10 |
| lab-03-ci-local | `make ci` ejecuta lint → test → build en secuencia; falla limpiamente si algún paso falla | 10 |
| lab-04-lint-calidad | `make lint` ejecuta al menos dos herramientas de análisis estático | 10 |
| lab-05-release | `make version` muestra versión actual; `make bump-patch` incrementa versión en archivo | 10 |

## Proyecto semanal (30 pts)

| Criterio | Pts |
|----------|-----|
| `make ci` ejecuta pipeline completo (lint → test → build → report) | 10 |
| `make env-check` valida todas las variables requeridas con mensajes claros | 8 |
| `make hooks-install` + `make hooks-uninstall` funcionan correctamente | 7 |
| El Makefile maneja correctamente distintos entornos (dev/staging/prod) | 5 |

## Calidad del Makefile (20 pts)

| Criterio | Pts |
|----------|-----|
| Todos los targets que no producen archivos tienen `.PHONY` | 5 |
| Target `help` presente y documenta todos los targets con `##` | 5 |
| Variables en `UPPER_SNAKE_CASE`; targets en `lower-kebab-case` | 5 |
| Secretos y variables sensibles nunca aparecen en el output del pipeline | 5 |
