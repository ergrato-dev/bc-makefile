# Glosario — Semana 06: Dependencias automáticas y targets especiales

| Término | Definición en una línea | Ejemplo en Makefile |
|---------|------------------------|---------------------|
| Archivo `.d` | Fragmento de Makefile que escribe el compilador con los headers de cada objeto | `-include $(OBJS:.o=.d)` |
| `-MMD` | Flag de gcc/clang que escribe el `.d` mientras compila, sin headers del sistema | `DEPFLAGS := -MMD -MP` |
| `-MP` | Añade una regla vacía por header para que borrar uno no rompa el build | `include/calc.h:` (línea que genera en el `.d`) |
| `CPPFLAGS` | Flags del preprocesador (`-I`, `-D`), separadas de las del compilador | `CPPFLAGS := -Iinclude` |
| Stamp de flags | Archivo cuya fecha solo avanza cuando cambian las flags; los objetos dependen de él | `build/%.o: src/%.c $(FLAGS_STAMP)` |
| `.EXTRA_PREREQS` | Prerrequisitos que cuentan para rehacer pero no aparecen en `$^` (Make 4.3+) | `$(OBJS): .EXTRA_PREREQS := Makefile` |
| Prerrequisito order-only | Prerrequisito que solo debe existir; su fecha no se compara | `build/%.o: src/%.c \| build/` |
| `$\|` | Variable automática con los prerrequisitos order-only | `@echo "dirs: $\|"` |
| `.SECONDEXPANSION` | Expande otra vez los prerrequisitos por target, cuando ya hay variables automáticas | `build/%.o: src/%.c \| $$(@D)/` |
| `vpath` / `VPATH` | Directorios donde Make busca prerrequisitos que no están en el directorio actual | `vpath %.c src src/core` |
| Grouped target `&:` | Varios targets que una sola ejecución de la receta produce a la vez (Make 4.3+) | `gen/a.c gen/a.h &: a.def` |
| Archivo intermedio | Archivo deducido por una cadena de reglas de patrón; Make lo borra al terminar | `.INTERMEDIATE: build/todos.txt` |
| `.SECONDARY` | Intermedio que no se borra; si falta, no obliga a rehacer | `.SECONDARY: $(GEN_SRCS)` |
| `.PRECIOUS` | No se borra ni como intermedio ni tras un fallo; anula `.DELETE_ON_ERROR` | `.PRECIOUS: %/` |
| `.NOTINTERMEDIATE` | Saca archivos o patrones de la categoría de intermedios (Make 4.4+) | `.NOTINTERMEDIATE: build/%.c` |
