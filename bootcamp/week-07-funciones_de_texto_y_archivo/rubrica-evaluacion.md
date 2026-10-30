# Rúbrica de Evaluación — Semana 07

**Total: 100 puntos**

## Labs (50 pts)

| Lab | Criterio de evaluación | Puntos |
|-----|------------------------|--------|
| Lab 01 — wildcard | `$(wildcard)` reemplaza la lista hardcodeada; `make list-sources` muestra las fuentes descubiertas y el conteo correcto | 8 |
| Lab 02 — patsubst | `$(patsubst)` y `$(subst)` generan las 3 listas correctamente; `make demo` imprime la salida esperada sin listas vacías | 8 |
| Lab 03 — filter | `$(filter)` y `$(filter-out)` producen los 5 subconjuntos correctos; ningún resultado contiene palabras que no deberían estar | 8 |
| Lab 04 — rutas | Las 6 funciones de ruta (`dir`, `notdir`, `basename`, `suffix`, `addprefix`, `addsuffix`) producen la salida exacta esperada | 9 |
| Lab 05 — combinadas | Build system completo con auto-descubrimiento; `make all` compila correctamente; agregar un nuevo `.c` a `src/` no requiere editar el Makefile | 9 |
| Lab 06 — rotas | Los 4 bugs identificados y corregidos; `make demo` en la solución produce la salida exacta esperada del README | 8 |

## Proyecto (30 pts)

| Criterio | Descripción | Puntos |
|----------|-------------|--------|
| `make all` funcional | Compila todos los módulos auto-descubiertos sin errores | 10 |
| `make report` correcto | Genera estadísticas usando funciones de texto: conteo de fuentes, directorios de módulos, nombre del target | 10 |
| Resistencia al cambio | Agregar un nuevo `.c` en `src/` o en un módulo existente no requiere modificar el Makefile | 10 |

## Calidad del Makefile (20 pts)

| Criterio | Descripción | Puntos |
|----------|-------------|--------|
| `.PHONY` | Declarado para todos los targets que no producen archivos | 5 |
| `help` target | Presente y documenta todos los targets con `## comentario` | 5 |
| Nomenclatura | Variables en `UPPER_SNAKE_CASE`, targets en `lower-kebab-case` | 5 |
| Sin hardcoding | No hay listas de archivos escritas a mano; todo se descubre con funciones de texto | 5 |

---

## Escala de calificación

| Rango | Nivel |
|-------|-------|
| 90–100 | Excelente — build system profesional, listo para producción |
| 75–89 | Bueno — funciona correctamente con detalles de estilo menores |
| 60–74 | Suficiente — cumple lo básico, falta robustez o auto-descubrimiento |
| < 60 | Insuficiente — revisar teoría y repetir labs 01–03 |
