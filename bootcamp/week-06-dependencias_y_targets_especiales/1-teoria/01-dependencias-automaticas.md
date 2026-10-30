# Dependencias automáticas: el `.d` por dentro

## ¿Por qué importa esto?

Un build incremental en el que no confías es peor que no tenerlo: acabas
ejecutando `make clean all` "por si acaso" y pierdes todo lo que Make te
ofrece. La desconfianza casi siempre viene de lo mismo: Make no sabe que
`main.o` depende de `calc.h`, de las flags con las que se compiló o del
propio Makefile. En la semana 04 viste `-MMD -MP` en una línea; aquí verás
qué escriben exactamente y cómo cubrir lo que el compilador no puede ver.

## Qué contiene un `.d`

Crea un proyecto mínimo:

```bash
mkdir -p demo06/src demo06/include && cd demo06
printf '#include "calc.h"\nint main(void) { return suma(1, 2) - 3; }\n' > src/main.c
printf '#include "calc.h"\nint suma(int a, int b) { return a + b; }\n' > src/calc.c
printf 'int suma(int a, int b);\n' > include/calc.h
```

Y este `Makefile` (pégalo con TABs):

```makefile
SHELL       := bash
.SHELLFLAGS := -eu -o pipefail -c
.DELETE_ON_ERROR:

.PHONY: all clean FORCE
.DEFAULT_GOAL := all

CC       := gcc
CPPFLAGS := -Iinclude
CFLAGS   := -Wall -Wextra -std=c11
DEPFLAGS := -MMD -MP
BUILD    := build
OBJS     := $(BUILD)/main.o $(BUILD)/calc.o
STAMP    := $(BUILD)/compile-flags.txt

all: $(BUILD)/app

$(BUILD)/app: $(OBJS)
	$(CC) $^ -o $@

$(BUILD)/%.o: src/%.c $(STAMP)
	@mkdir -p $(@D)
	$(CC) $(DEPFLAGS) $(CPPFLAGS) $(CFLAGS) -c $< -o $@

# Solo se reescribe si las flags cambiaron
$(STAMP): FORCE
	@mkdir -p $(@D)
	@echo '$(CC) $(CPPFLAGS) $(CFLAGS)' | cmp -s - $@ \
		|| echo '$(CC) $(CPPFLAGS) $(CFLAGS)' > $@

-include $(OBJS:.o=.d)

clean:
	$(if $(BUILD),,$(error BUILD vacía: rm -rf no se ejecuta))
	rm -rf -- '$(BUILD)'
```

Tras `make`, mira `build/main.d`:

```makefile
build/main.o: src/main.c include/calc.h
include/calc.h:
```

Es Makefile puro, sin receta. La primera línea es lo que hace `-MMD`: añade
los headers como prerrequisitos de `main.o`. La segunda es `-MP`: una regla
vacía por header. Sin ella, si borras `calc.h` y dejas de incluirlo, Make
lee el `.d` viejo, no sabe crear `include/calc.h` y para con
`No rule to make target`. Con la regla vacía, el header ausente se da por
resuelto, el `.o` se recompila y el `.d` nuevo ya no lo menciona.

| Flag | Qué hace |
|------|----------|
| `-MMD` | Escribe `x.d` junto a `x.o` mientras compila; omite headers del sistema |
| `-MD` | Igual, pero incluye `<stdio.h>` y compañía (casi nunca lo quieres) |
| `-MP` | Añade `header:` vacío por cada header listado |
| `-MF archivo` | Cambia el nombre del `.d` (por defecto, el del `.o` con `.d`) |

El `.d` se genera **en la misma compilación** que el `.o`: si el `.o` está
al día, su `.d` también. Por eso no hace falta una regla para crearlos.

## `CPPFLAGS` frente a `CFLAGS`

Las reglas implícitas de Make usan `CPPFLAGS` para el preprocesador
(`-I`, `-D`) y `CFLAGS` para el compilador (`-O2`, `-Wall`). Separarlas
permite que alguien cambie `CFLAGS` desde la línea de comandos sin perder
los `-I`. `DEPFLAGS` no es estándar, pero es la convención habitual para
no mezclar las flags de dependencias con las demás.

## Lo que el compilador no ve: flags y Makefile

`make CFLAGS=-O2` no recompila nada: ningún archivo cambió. El stamp lo
resuelve: `FORCE` hace que su receta se ejecute siempre, pero solo reescribe
el archivo si el contenido es distinto. Si su fecha no cambia, nadie se
recompila; si cambia, se recompilan todos los objetos.

Para el propio Makefile, Make 4.3 trae `.EXTRA_PREREQS`: prerrequisitos que
cuentan para decidir si rehacer, pero no aparecen en `$^` ni en `$<`.

```makefile
# Cualquier cambio en el Makefile recompila los objetos
$(OBJS): .EXTRA_PREREQS := Makefile
```

Compruébalo:

```bash
make                       # compila todo
touch include/calc.h; make # recompila main.o y calc.o
make CFLAGS=-O2            # recompila todo: cambió el stamp
make CFLAGS=-O2            # no hace nada
```

---

Listo. Ve al [lab-01](../2-practicas/lab-01-anatomia-del-d/README.md) y ponlo en práctica.
