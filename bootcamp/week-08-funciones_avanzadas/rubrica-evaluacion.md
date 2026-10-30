# Rúbrica de Evaluación — Semana 08: Funciones Avanzadas

## Puntuación total: 100 puntos

## Labs (50 puntos)

| Lab | Criterio | Puntos |
|-----|----------|--------|
| lab-01-foreach | `make demo` muestra las tres variables generadas con `$(foreach)` correctamente | 5 |
| lab-01-foreach | `make dirs` crea la estructura de directorios correcta | 3 |
| lab-01-foreach | `make report` usa `$(foreach)` dentro de la receta | 2 |
| lab-02-call | Las funciones usan `$1`, `$2` sin repetir código | 5 |
| lab-02-call | `make demo` muestra el resultado de cada `$(call)` correctamente | 5 |
| lab-03-eval | `$(eval)` genera reglas reales (no solo texto) verificable con `make run-unit` | 5 |
| lab-03-eval | `make all` ejecuta todas las suites generadas | 5 |
| lab-04-shell | `make info` muestra todos los valores capturados con `$(shell)` | 5 |
| lab-04-shell | `make version` genera `build/version.txt` con contenido correcto | 5 |
| lab-05-combinadas | `make info` descubre plugins automáticamente con `$(shell)` | 3 |
| lab-05-combinadas | `make all` compila usando reglas generadas por `$(eval)` | 5 |
| lab-06-funciones-rotas | Se identifican y corrigen los 4 bugs (2 pts c/u) | 8 |

## Proyecto semanal (30 puntos)

| Criterio | Puntos |
|----------|--------|
| `make info` muestra servicios auto-descubiertos con `$(shell)` | 8 |
| `make all` compila todos los servicios usando reglas generadas por `$(eval)` | 12 |
| Agregar un nuevo directorio en `services/` compila automáticamente sin editar el Makefile | 10 |

## Calidad del Makefile (20 puntos)

| Criterio | Puntos |
|----------|--------|
| Todos los phony targets declarados en `.PHONY` | 5 |
| Target `help` presente y funcional en todos los Makefiles entregados | 5 |
| Variables en `UPPER_SNAKE_CASE`, targets en `lower-kebab-case` | 5 |
| Separación correcta con TAB (no espacios) en todas las recetas | 5 |
