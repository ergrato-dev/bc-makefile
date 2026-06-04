# Glosario — Semana 03: Variables automáticas

| Término | Definición en una línea | Ejemplo en Makefile |
|---------|------------------------|---------------------|
| Variable automática | Variable que Make inyecta en la receta con un valor específico de la regla actual | `$@`, `$<`, `$^` |
| `$@` | Nombre del target de la regla actual | `gcc $^ -o $@` |
| `$<` | Primer prerrequisito de la regla actual | `gcc -c $< -o $@` |
| `$^` | Todos los prerrequisitos, deduplicados y separados por espacios | `gcc $^ -o $@` |
| `$?` | Prerrequisitos más nuevos que el target; vacío si el target está al día | `@echo "Modificados: $?"` |
| `$*` | El stem que coincidió con `%` en una regla de patrón | `@echo "Módulo: $*"` |
| `$(@D)` | Parte de directorio del nombre del target (`$@`) | `@mkdir -p $(@D)` |
| `$(@F)` | Parte de nombre de archivo del target (`$@`) | `@echo "Archivo: $(@F)"` |
| `$(<D)` | Parte de directorio del primer prerrequisito (`$<`) | `@echo "Dir fuente: $(<D)"` |
| `$(<F)` | Parte de nombre de archivo del primer prerrequisito (`$<`) | `@echo "Fuente: $(<F)"` |
| stem | El texto que coincidió con `%` en una regla de patrón | En `%.o: %.c`, el stem de `main.o` es `main` |
| regla de patrón | Regla que usa `%` para coincidir con múltiples targets | `%.o: %.c` |
| regla explícita | Regla con nombres de archivo concretos, sin wildcards | `main.o: main.c utils.h` |
| rebuild incremental | Recompilar solo los archivos modificados, no todo el proyecto | Comportamiento por defecto de Make con `$?` y timestamps |
