# Rúbrica de Evaluación — Semana 11

**Total: 100 puntos**

---

## Labs (50 pts — 10 pts cada uno, se evalúan 5 de 6)

| Lab | Criterio | Puntos |
|-----|----------|--------|
| lab-01-python | `make install` crea `.venv/` y `make test` ejecuta pytest sin errores | 10 |
| lab-02-docker | `make build` construye la imagen y `make info` muestra metadata correcta | 10 |
| lab-03-nodejs | `make install` genera `node_modules/` y `make test` ejecuta los tests | 10 |
| lab-04-compose | `make info` muestra servicios y `make up`/`make down` funcionan sin error | 10 |
| lab-05-multi-stack | `make info` muestra stack completo; targets `backend-*` y `frontend-*` separados | 10 |
| lab-06-targets-rotos | Los 5 bugs identificados y corregidos; `make demo` pasa sin errores | 10 |

---

## Proyecto semanal (30 pts)

| Criterio | Puntos |
|----------|--------|
| `make install` usa sentinel file — no reinstala si `requirements.txt` no cambió | 6 |
| `make test` y `make lint` funcionan correctamente | 6 |
| `make build` construye imagen con `VERSION` y `BUILD_DATE` inyectados | 6 |
| `make info` muestra versión, imagen, fecha y entorno | 6 |
| `make deploy-prod` pide confirmación antes de ejecutar | 6 |

---

## Calidad del Makefile (20 pts)

| Criterio | Puntos |
|----------|--------|
| Todos los targets no-archivo están en `.PHONY` | 5 |
| Target `help` documenta todos los targets con `##` y formato alineado | 5 |
| Variables en `UPPER_SNAKE_CASE`; targets en `lower-kebab-case` | 5 |
| `-include .env` con `export` para propagar variables al shell | 5 |
