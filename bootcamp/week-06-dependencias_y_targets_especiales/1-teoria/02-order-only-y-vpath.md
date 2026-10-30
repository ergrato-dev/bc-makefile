# Order-only, `.SECONDEXPANSION` y `vpath`

## ¿Por qué importa esto?

Un directorio de salida es un prerrequisito raro: tiene que existir antes de
compilar, pero su fecha no significa nada. Cada vez que creas un archivo
dentro de `build/`, la fecha de `build/` cambia. Si los objetos dependen de
`build/` como de cualquier otro archivo, ese cambio los deja "viejos" y Make
los recompila todos sin motivo. Los prerrequisitos *order-only* existen para
esto.

## Order-only: `|`

Todo lo que va a la derecha de `|` solo se exige que **exista**. Su fecha
no se compara con la del target.

```makefile
SHELL       := bash
.SHELLFLAGS := -eu -o pipefail -c
.DELETE_ON_ERROR:
# Habilita $$(@D) en la lista de prerrequisitos
.SECONDEXPANSION:

.PHONY: all clean
.DEFAULT_GOAL := all

BUILD := build
FILES := $(BUILD)/a.txt $(BUILD)/informes/b.txt

all: $(FILES)

# Normal: Makefile. Order-only: el directorio del propio target
$(BUILD)/%.txt: Makefile | $$(@D)/
	echo "contenido de $@" > $@

# Una regla para cualquier directorio. Lo que crea una regla de patrón es
# "intermedio": .PRECIOUS evita que Make 4.3 intente borrarlo al terminar
%/:
	mkdir -p $@
.PRECIOUS: %/

clean:
	$(if $(BUILD),,$(error BUILD vacía: rm -rf no se ejecuta))
	rm -rf -- '$(BUILD)'
```

```bash
make                    # crea build/, build/informes/ y los dos .txt
touch build/otro.txt    # cambia la fecha de build/
make                    # make: Nothing to be done for 'all'.
```

Si quitas el `|`, el último `make` rehace `build/a.txt`: el directorio es
más nuevo que el archivo.

| Prerrequisito | ¿Debe existir? | ¿Su fecha cuenta? | ¿En `$^`? |
|---|:-:|:-:|:-:|
| Normal | Sí | Sí | Sí |
| Order-only (`\| dir`) | Sí | No | No (está en `$\|`) |

## `.SECONDEXPANSION`: prerrequisitos que dependen del target

Las variables automáticas no existen cuando Make lee la línea de
prerrequisitos. Con `.SECONDEXPANSION:` declarado, Make expande los
prerrequisitos **otra vez** justo antes de procesar cada target, y entonces
`$$(@D)` ya vale el directorio de ese target concreto. El `$$` sobrevive
a la primera lectura como `$` y se resuelve en la segunda.

Así una sola regla crea `build/` para `a.txt` y `build/informes/` para
`b.txt`, sin listar directorios a mano y sin `mkdir -p` en cada receta.

## `vpath`: dónde buscar prerrequisitos

Si los fuentes están repartidos en varias carpetas pero quieres una regla
`%.o: %.c`, `vpath` le dice a Make dónde buscar archivos por patrón:

```makefile
vpath %.c src/core src/util
vpath %.h include
```

Make busca `calc.c` en el directorio actual, luego en `src/core`, luego en
`src/util`. Lo que encuentra va a `$<` y `$^` **con la ruta completa**:
`src/core/calc.c`. Por eso las recetas usan siempre variables automáticas,
nunca el nombre escrito.

| Forma | Alcance |
|---|---|
| `VPATH := src:lib` | Todos los archivos, en esos directorios |
| `vpath %.c src` | Solo lo que casa con el patrón |
| `vpath %.c` | Borra las rutas de ese patrón |

Dos límites que conviene saber desde el primer día:

- `vpath` es para **fuentes**, no para targets. Si un objeto se encuentra en
  otro directorio por `vpath`, Make puede reconstruirlo en el directorio
  actual y dejar el viejo ahí.
- Dos fuentes con el mismo nombre en carpetas distintas chocan: Make usa el
  primero que encuentra. Con un árbol de salida que replica `src/`
  (`build/core/calc.o`) no hay ambigüedad; por eso el proyecto lo usa.

---

Listo. Ve al [lab-01](../2-practicas/lab-01-anatomia-del-d/README.md) y ponlo en práctica.
