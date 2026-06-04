# Rúbrica de Evaluación — Semana 01

Puntaje total: **100 puntos**

## Labs (50 pts)

| Lab | Criterio de evaluación | Pts |
|-----|------------------------|-----|
| lab-01 | `make saludar` imprime "Hola desde Make!" e `make info` muestra fecha, usuario y directorio | 10 |
| lab-02 | `make run` ejecuta los 4 pasos en orden: prepare → compile → link → run | 10 |
| lab-03 | Con un archivo llamado `clean` presente, `make clean` igual se ejecuta gracias a `.PHONY` | 10 |
| lab-04 | Segunda ejecución de `make reporte.txt` dice "Nothing to be done"; tras `touch datos.csv` sí regenera | 10 |
| lab-05 | Los 4 errores del Makefile identificados y corregidos; `make all` corre sin errores | 10 |
| lab-06 | `make help` lista todos los targets con descripción, usando el patrón `##` | 10 |

> Nota: se evalúan 6 labs pero el puntaje máximo de esta sección es 50. Completar 5 de 6 otorga 50 pts.

## Proyecto semanal (30 pts)

| Criterio | Pts |
|----------|-----|
| `make build` copia `src/` a `dist/` sin errores | 8 |
| `make clean` elimina `dist/` completamente | 6 |
| `make check` verifica existencia de archivos HTML y falla si faltan | 8 |
| `make help` lista todos los targets con descripción | 8 |

## Calidad del Makefile (20 pts)

| Criterio | Pts |
|----------|-----|
| Todos los targets no-archivo declarados en `.PHONY` | 5 |
| Recetas usan TAB (no espacios) — verificable con `cat -A Makefile` | 5 |
| `.DEFAULT_GOAL := help` definido | 5 |
| Variables en `UPPER_SNAKE_CASE`, targets en `lower-kebab-case` | 5 |
