# Reglas implícitas de serie y cómo elige Make

## ¿Por qué importa esto?

GNU Make trae de fábrica unas noventa reglas de patrón: `%.o: %.c`, `%: %.c`, `%: %.sh`, `%.c: %.y`… Se aplican aunque tú no las escribas. Cuando tu patrón no casa (un typo en el directorio, un `.c` que no está donde crees), Make no falla: busca otra regla, encuentra una de serie y compila **con otras flags y en otro directorio**. El build "funciona" y el bug aparece semanas después.

## Míralo con tus ojos — pega y ejecuta

En un directorio vacío:

```bash
printf '#!/bin/sh\necho "soy un script"\n' > deploy.sh
printf 'int main(void) { return 0; }\n' > hola.c
```

`Makefile`:

```makefile
SHELL       := bash
.SHELLFLAGS := -eu -o pipefail -c
.DELETE_ON_ERROR:

.PHONY: help
.DEFAULT_GOAL := help

help: ## Muestra los targets disponibles
	@echo "Targets disponibles:"
	@grep -hE '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
		| awk 'BEGIN {FS = ":.*?## "}; {printf "  %-20s %s\n", $$1, $$2}'
```

```bash
make hola        # cc     hola.c   -o hola          ← regla %: %.c de serie
make deploy      # cat deploy.sh >deploy; chmod a+x deploy   ← regla %: %.sh
make -p -f /dev/null 2>/dev/null | grep -A2 '^%: %.sh'   # ahí está, con su receta
rm -f hola deploy
```

El Makefile no menciona `hola` ni `deploy`, y aun así Make construyó los dos. Ahora añade una línea justo después del preámbulo y repite:

```makefile
MAKEFLAGS += -r
```

```bash
make hola        # make: *** No rule to make target 'hola'.  Stop.
```

## `-r` y `-R`

| Opción | Efecto |
|--------|--------|
| `make -r` / `--no-builtin-rules` | Elimina las reglas implícitas de serie y la lista de sufijos (`.c.o:`, `.SUFFIXES`) |
| `make -R` / `--no-builtin-variables` | Elimina también variables como `CC`, `CFLAGS`, `COMPILE.c`; implica `-r` |
| `MAKEFLAGS += -r` | Lo mismo que `-r`, pero escrito en el Makefile: nadie tiene que acordarse de pasarlo |

Tus propias reglas de patrón siguen funcionando con `-r`; solo desaparecen las de serie. Con `-R` tienes que definir tú `CC` (si no, `$(CC)` queda vacío).

Las **reglas de sufijo** (`.c.o:`) son la sintaxis antigua de lo mismo: `.c.o:` equivale a `%.o: %.c`. Las verás en Makefiles viejos y en `make -p`.

## Cómo elige Make una regla

Para cada target que necesita, Make decide así (manual de GNU Make, *How Patterns Match* e *Implicit Rule Search*):

1. **¿Tiene receta en una regla explícita?** Se usa esa. Una static pattern rule cuenta como explícita: genera una regla normal por target. Si dos reglas explícitas dan receta al mismo target, gana **la última** con el aviso `warning: overriding recipe`.
2. **¿Solo tiene prerrequisitos (`main.o: config.h`)?** Eso no es una receta: Make sigue buscando una regla de patrón y añade `config.h` a sus prerrequisitos.
3. **Reglas de patrón candidatas:** las que casan con el nombre **y** cuyos prerrequisitos existen o se pueden construir. Las tuyas tienen precedencia sobre las de serie.
4. **Entre varias candidatas gana la de stem más corto** (la más específica). Con `test_%.o: test_%.c` y `%.o: %.c`, para `test_math.o` gana la primera (stem `math` frente a `test_math`), esté escrita antes o después. Con stems iguales, gana la primera del Makefile.
5. **Ninguna:** `No rule to make target`.

Redefinir un patrón con los mismos target y prerrequisito (`%.o: %.c`) **reemplaza** al anterior, incluido el de serie: por eso tu `%.o: %.c` anula al de Make.

```bash
make -p -q 2>/dev/null | grep -B1 -A3 '^debug.o:'   # qué regla internalizó Make
make --debug=i debug.o                               # trazas de la búsqueda implícita
```

---

Ve al [lab-01](../2-practicas/lab-01-patron-basico/README.md); el [lab-05](../2-practicas/lab-05-prioridad/README.md) pone a prueba cada punto de esta lista.
