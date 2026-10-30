# Glosario — Semana 04: Variables automáticas

| Término | Definición en una línea | Ejemplo en Makefile |
|---------|------------------------|---------------------|
| Variable automática | Variable que Make inyecta en la receta con un valor específico de la regla actual | `$@`, `$<`, `$^` |
| `$@` | Nombre del target de la regla actual | `gcc $^ -o $@` |
| `$<` | Primer prerrequisito de la regla actual | `gcc -c $< -o $@` |
| `$^` | Todos los prerrequisitos, deduplicados y separados por espacios | `gcc $^ -o $@` |
| `$+` | Todos los prerrequisitos en orden y **con** duplicados | `$(CC) $+ -o $@` (bibliotecas repetidas) |
| `$?` | Prerrequisitos más nuevos que el target; vacío si el target está al día | `@echo "Modificados: $?"` |
| `$*` | El stem que coincidió con `%` en una regla de patrón | `@echo "Módulo: $*"` |
| `$(@D)` | Parte de directorio del nombre del target (`$@`) | `@mkdir -p $(@D)` |
| `$(@F)` | Parte de nombre de archivo del target (`$@`) | `@echo "Archivo: $(@F)"` |
| `$(<D)` / `$(<F)` | Directorio y nombre de archivo del primer prerrequisito (`$<`) | `@echo "$(<D) / $(<F)"` |
| stem | El texto que coincidió con `%` en una regla de patrón | En `%.o: %.c`, el stem de `main.o` es `main` |
| regla de patrón | Regla que usa `%` para coincidir con múltiples targets | `%.o: %.c` |
| rebuild incremental | Recompilar solo los archivos modificados, no todo el proyecto | Comportamiento por defecto de Make con `$?` y timestamps |
| `-MMD -MP` | Flags de gcc que escriben un `.d` por objeto con los headers que incluye, más reglas vacías por header | `$(CC) -MMD -MP -c $< -o $@` + `-include $(DEPS)` |
