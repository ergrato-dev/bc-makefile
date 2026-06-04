# Rúbrica de evaluación — Semana 04

## Total: 100 puntos

---

## Labs completados — 60 puntos (10 pts c/u)

| Lab | Criterio de evaluación | Pts |
|-----|------------------------|-----|
| lab-01-patron-basico | La regla `%.o: %.c` compila los tres módulos; sin reglas explícitas por archivo | 10 |
| lab-02-directorio-salida | La regla `build/%.o: src/%.c` crea objetos en `build/`; `mkdir -p $(@D)` correcto | 10 |
| lab-03-multiples-patrones | Dos reglas de patrón distintas (`.processed` y `.backup`) con recetas independientes | 10 |
| lab-04-static-pattern | Static pattern rule `$(LIB_OBJS): build/%.o: src/%.c` solo compila los módulos indicados | 10 |
| lab-05-prioridad | Regla explícita para `main.o` anula la regla de patrón; demostrado con `make -p` | 10 |
| lab-06-patrones-rotos | Los cinco bugs identificados y corregidos; `make all` funciona sin errores | 10 |

---

## Proyecto semanal — 30 puntos

| Criterio | Pts |
|----------|-----|
| Regla de patrón `build/%.o: src/%.c` compila todos los módulos sin nombrarlos | 10 |
| Static pattern rule para `$(TEST_OBJS)` con ruta de salida `build/test/` | 8 |
| `make clean` elimina `build/` completo; `make all` recompila desde cero | 7 |
| `make test` ejecuta el binario de pruebas y muestra resultados | 5 |

---

## Calidad del Makefile — 10 puntos

| Criterio | Pts |
|----------|-----|
| Todos los targets phony declarados en `.PHONY` | 2 |
| Variables en `UPPER_SNAKE_CASE`, targets en `lower-kebab-case` | 2 |
| Target `help` presente y lista todos los targets con descripción | 2 |
| TABs en recetas (no espacios); verificable con `cat -A Makefile` | 2 |
| Sin reglas explícitas `%.o` repetidas donde una sola de patrón alcanza | 2 |
