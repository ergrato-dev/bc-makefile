# Glosario — Semana 04: Reglas de patrón

| Término | Definición en una línea | Ejemplo en Makefile |
|---------|------------------------|---------------------|
| Regla de patrón | Regla que usa `%` como comodín para coincidir con múltiples targets | `%.o: %.c` |
| Stem | La parte del nombre de archivo que captura el `%` en una regla de patrón | En `%.o: %.c`, para `main.o` el stem es `main` |
| Static pattern rule | Regla de patrón que solo aplica a una lista explícita de targets | `$(OBJS): %.o: %.c` |
| Regla implícita | Regla de patrón predefinida dentro de Make (ej. `%.o: %.c` con `$(CC)`) | Funciona sin declararla; se anula definiéndola explícitamente |
| Prefijo de directorio | Texto fijo antes de `%` en el target o prerrequisito de un patrón | `build/%.o: src/%.c` |
| Prioridad de reglas | Orden en que Make elige: explícita > static pattern > patrón > implícita | `debug.o: debug.c` anula `%.o: %.c` para ese target |
| `%.ext1: %.ext2` | Patrón que transforma archivos de una extensión a otra usando el mismo stem | `%.html: %.md` |
| Encadenamiento de patrones | Make aplica dos patrones en cadena cuando ninguno llega al prerrequisito final | `%.o` ← `%.c` ← `%.y` (generado por yacc) |
| `$(SRCS:.c=.o)` | Sustitución de sufijo para derivar la lista de objetos de la lista de fuentes | `OBJS := $(SRCS:.c=.o)` |
| `$(filter-out ...)` | Función que excluye elementos de una lista; útil para separar `main.c` de módulos | `LIB := $(filter-out main.c, $(SRCS))` |
| `$(wildcard ...)` | Función que expande un patrón glob al conjunto de archivos existentes | `SRCS := $(wildcard src/*.c)` |
| `No rule to make target` | Error de Make cuando ninguna regla (explícita, estática, patrón) produce el target pedido | Suele indicar stem incorrecto o prerrequisito inexistente |
| Target patrón | La parte izquierda de una regla de patrón; contiene exactamente un `%` | `build/%.o` en `build/%.o: src/%.c` |
| Prerrequisito patrón | La parte derecha de una regla de patrón; el `%` se reemplaza por el stem del target | `src/%.c` en `build/%.o: src/%.c` |
