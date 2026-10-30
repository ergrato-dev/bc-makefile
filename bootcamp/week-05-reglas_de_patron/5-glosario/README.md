# Glosario — Semana 05: Reglas de patrón

| Término | Definición en una línea | Ejemplo en Makefile |
|---------|------------------------|---------------------|
| Regla de patrón | Regla cuyo target contiene un `%`; es una plantilla que Make instancia para cada target que casa | `%.o: %.c` |
| Stem | La parte del nombre que casa con `%`; puede contener barras | Para `build/net/ping.o` en `build/%.o`, el stem es `net/ping` |
| `$*` | Variable automática con el stem de la regla que se está ejecutando | `@echo "stem=$*"` |
| Prefijo de directorio | Texto fijo antes del `%` en el target o el prerrequisito de un patrón | `build/%.o: src/%.c` |
| Static pattern rule | Regla con lista explícita de targets y un patrón; genera una regla explícita por target | `$(LIB_OBJS): build/lib/%.o: src/%.c` |
| Sustitución con patrón | Referencia que transforma cada palabra de una lista usando `%` | `OBJS := $(SRCS:src/%.c=build/%.o)` |
| Regla implícita de serie | Regla de patrón que GNU Make trae de fábrica y aplica sin que la escribas | `%: %.c` compila `hola` desde `hola.c` |
| Regla de sufijo | Sintaxis antigua de una regla de patrón, basada en `.SUFFIXES` | `.c.o:` equivale a `%.o: %.c` |
| `-r` / `--no-builtin-rules` | Opción que elimina las reglas implícitas de serie y los sufijos | `make -r all` |
| `-R` / `--no-builtin-variables` | Opción que elimina además variables como `CC` y `CFLAGS`; implica `-r` | `make -R all CC=gcc` |
| `MAKEFLAGS += -r` | Activa `-r` desde el propio Makefile, sin depender de quien lo ejecute | `MAKEFLAGS += -r` tras el preámbulo |
| `make -p` | Vuelca la base de datos de Make: variables, reglas propias y de serie | `make -p -f /dev/null \| grep -A2 '^%: %.sh'` |
| Stem más corto | Criterio de desempate entre reglas de patrón aplicables: gana la más específica | `test_%.o` gana a `%.o` para `test_normal.o` |
| Encadenamiento | Make aplica dos reglas de patrón seguidas cuando falta un archivo intermedio | `.raw → .processed → .summary` |
| Archivo intermedio | Archivo creado por un encadenamiento que el Makefile no menciona; Make lo borra al terminar | `rm zeta.processed` tras `make zeta.summary` |
