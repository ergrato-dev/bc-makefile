# Glosario — Semana 07: Funciones de Texto y Archivo

| Término | Definición en una línea | Ejemplo en Makefile |
|---------|------------------------|---------------------|
| `$(wildcard pat)` | Lista los archivos existentes en disco que coinciden con el patrón glob | `SRCS := $(wildcard src/*.c)` |
| `$(patsubst from,to,text)` | Transforma cada palabra de `text` que coincide con `from` (con comodín `%`) aplicando `to` | `OBJS := $(patsubst src/%.c,build/%.o,$(SRCS))` |
| `$(subst from,to,text)` | Sustituye todas las apariciones literales de `from` por `to`, incluso a mitad de una palabra | `$(subst -,_,a-b c-d)` → `a_b c_d` |
| `$(filter pat,text)` | Conserva solo las palabras de `text` que coinciden con al menos uno de los patrones | `$(filter %.c,a.c b.h c.c)` → `a.c c.c` |
| `$(filter-out pat,text)` | Elimina las palabras de `text` que coinciden con el patrón; conserva el resto | `$(filter-out %.h,a.c b.h)` → `a.c` |
| `$(dir names)` | Extrae la parte de directorio de cada ruta (incluye el `/` final) | `$(dir src/main.c)` → `src/` |
| `$(notdir names)` | Extrae el nombre de archivo sin la parte de directorio | `$(notdir src/main.c)` → `main.c` |
| `$(basename names)` | Elimina la extensión de cada nombre (conserva el directorio) | `$(basename src/main.c)` → `src/main` |
| `$(suffix names)` | Extrae solo la extensión (con el `.`) de cada nombre | `$(suffix src/main.c)` → `.c` |
| `$(addprefix pre,names)` | Agrega `pre` al inicio de cada palabra de la lista | `$(addprefix -I,src include)` → `-Isrc -Iinclude` |
| `$(addsuffix suf,names)` | Agrega `suf` al final de cada palabra de la lista | `$(addsuffix /,src include)` → `src/ include/` |
| `$(sort list)` | Ordena la lista alfabéticamente y elimina duplicados | `$(sort b a a c)` → `a b c` |
| `$(words list)` / `$(word n,list)` | Cuenta las palabras de la lista / devuelve la palabra número `n` (desde 1) | `$(words a b c)` → `3`; `$(word 2,a b c)` → `b` |
| `$(strip text)` | Quita los espacios de los extremos y deja uno solo entre palabras | `MOD := $(strip $(MODULE))` |
| Referencia de sustitución | Atajo de `patsubst` aplicado a una variable | `OBJS := $(SRCS:src/%.c=build/%.o)` |
