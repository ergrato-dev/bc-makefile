# Labs — Semana 05: Reglas de patrón

| # | Lab | Objetivo | Duración |
|---|-----|----------|----------|
| 1 | [lab-01-patron-basico](lab-01-patron-basico/) | Escribir `%.o: %.c`, comprobar la incrementalidad y ver la regla de serie que actúa si la quitas | 60 min |
| 2 | [lab-02-directorio-salida](lab-02-directorio-salida/) | Usar `build/%.o: src/%.c` con `mkdir -p $(@D)`, incluido un stem con subdirectorio | 60 min |
| 3 | [lab-03-multiples-patrones](lab-03-multiples-patrones/) | Combinar varias reglas de patrón: elección por prerrequisito, por orden y encadenamiento | 60 min |
| 4 | [lab-04-static-pattern](lab-04-static-pattern/) | Compilar dos grupos con flags distintos con static pattern rules y empaquetar una librería | 60 min |
| 5 | [lab-05-prioridad](lab-05-prioridad/) | Comprobar el algoritmo de elección de reglas (receta explícita, stem más corto) y activar `MAKEFLAGS += -r` | 60 min |
| 6 | [lab-06-patrones-rotos](lab-06-patrones-rotos/) | Diagnosticar y corregir seis errores reales en reglas de patrón | 60 min |

Total: 6 h. Cada lab tiene `starter/` (con `TODO`) y `solucion/`. Ejecuta los comandos desde el `starter/` del lab.
