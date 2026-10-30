# Rúbrica de evaluación — Semana 04

**Total: 100 puntos**

## Labs (50 pts — 10 pts c/u × 5 labs activos)

El lab-06 es de depuración; los 10 puntos se distribuyen en lab-01 a lab-05.

| Lab | Criterio de evaluación | Pts |
|-----|------------------------|-----|
| lab-01 | `$@` imprime el nombre exacto de cada target; ningún nombre escrito literalmente en las recetas | 10 |
| lab-02 | `$<` pasa solo el primer prerrequisito; diferencia con `$^` demostrada y comentada | 10 |
| lab-03 | `$^` deduplica prerrequisitos repetidos; `$?` lista solo archivos más nuevos que el target | 10 |
| lab-04 | `$*` extrae el stem correcto en regla de patrón; cada archivo produce output con su propio stem | 10 |
| lab-05 | `$(@D)` crea el directorio destino dinámicamente; `$(@F)` extrae el nombre del archivo | 10 |

## Proyecto (30 pts)

| Criterio | Pts |
|----------|-----|
| Binario se compila correctamente con `make all` desde cero (build/ vacío) | 8 |
| Regla genérica `$(BUILD_DIR)/%.o: $(SRC_DIR)/%.c` usa `$@`, `$<`, `$(@D)` | 8 |
| `make clean` elimina `build/` sin errores; `make all` reconstruye desde cero | 5 |
| Rebuild incremental: modificar un `.c` recompila solo ese objeto, no todos | 5 |
| `make help` documenta todos los targets con descripción | 4 |

## Calidad del Makefile (20 pts)

| Criterio | Pts |
|----------|-----|
| Cero nombres de archivo hardcodeados en recetas (todo via variables automáticas) | 8 |
| Todos los targets phony declarados en `.PHONY` | 4 |
| Variables agrupadas al inicio con comentarios de sección | 4 |
| Target `help` presente y funcional en todos los entregables | 4 |
