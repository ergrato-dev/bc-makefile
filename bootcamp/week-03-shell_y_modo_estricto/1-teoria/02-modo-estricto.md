# Modo estricto

## ¿Por qué importa esto?

Por defecto, Make solo se entera de un fallo si el **último** comando de una línea sale con error. Una tubería `cut | sort` con un `cut` que falla, una variable de shell mal escrita o un archivo a medio escribir pasan como éxito. El modo estricto convierte esos fallos silenciosos en errores ruidosos, y las guardas impiden que un `clean` con una variable vacía borre lo que no debe. A partir de la Semana 04, todos los Makefiles del bootcamp empiezan así.

## Preámbulo estricto

```makefile
SHELL       := bash
.SHELLFLAGS := -eu -o pipefail -c
.DELETE_ON_ERROR:
```

Make ejecuta cada línea de receta como `$(SHELL) $(.SHELLFLAGS) "línea"`.

| Pieza | Sin ella | Con ella |
|---|---|---|
| `SHELL := bash` | `/bin/sh`, que en Debian/Ubuntu es dash: sin `pipefail` ni `[[ ]]` | bash en todas las máquinas |
| `-e` | `false; echo ok` termina con éxito | Para en el primer comando que falla |
| `-u` | `$$DEST_DIR` sin definir vale `""` | `DEST_DIR: unbound variable` |
| `-o pipefail` | `false \| true` termina con éxito | La tubería falla si falla cualquier etapa |
| `-c` | — | Obligatorio y al final: el valor por defecto de `.SHELLFLAGS` es `-c`, y si lo reemplazas sin él, bash toma la receta por un nombre de archivo |
| `.DELETE_ON_ERROR:` | Un `> $@` interrumpido deja un archivo nuevo y roto que Make da por bueno | Make borra el target si su receta falla |

`pipefail` destapa dos casos que no son errores: `grep` sale con 1 si no encuentra nada, y `head` cierra la tubería y el productor muere con SIGPIPE (141). Tolera solo lo que debes, con `{ grep x f || test $$? -eq 1; }`, y usa `awk 'NR <= 3'` en vez de `head -n 3`. No apagues `pipefail`.

`-u` afecta a variables de **shell**. Para variables de shell opcionales: `$${VAR:-valor}`.

## Guardas de rm -rf

Una variable de Make vacía no da error: se expande a nada. `rm -rf $(BUILD_DIR)/*` con un typo en el nombre es `rm -rf /*`. La guarda va en Make, como primera línea de la receta:

```makefile
BUILD_DIR := build

clean:
	$(if $(BUILD_DIR),,$(error BUILD_DIR vacía: rm -rf no se ejecuta))
	rm -rf -- '$(BUILD_DIR)'
```

- `$(if cond,entonces,si-no)`: con `BUILD_DIR` no vacía la línea se expande a nada y Make la salta; vacía, `$(error)` detiene Make **antes de ejecutar ninguna línea**, también con `make -n`.
- Comillas simples: una ruta con espacios es un solo argumento.
- `--`: una ruta que empiece por `-` no se lee como opción.
- Nada de `@` ni `-` delante del `rm`: quieres verlo en el log y saber si falló.

Nunca escribas `$(error ...)` en un comentario indentado con TAB dentro de una receta: para Make es una línea de receta, la expande y la guarda salta siempre. Las pistas, en columna 0.

En el lab-05 añadirás una segunda guarda que rechaza rutas fuera del proyecto (`/`, `..`, `$HOME`).

## Ejemplo completo — pega y ejecuta

```makefile
SHELL       := bash
.SHELLFLAGS := -eu -o pipefail -c
.DELETE_ON_ERROR:

.PHONY: all clean help
.DEFAULT_GOAL := help

BUILD_DIR := build

all: $(BUILD_DIR)/words.txt ## Cuenta palabras de este Makefile

$(BUILD_DIR)/words.txt: Makefile
	mkdir -p $(BUILD_DIR)
	tr -s ' ' '\n' < Makefile | sort | uniq -c | sort -rn > $@
	@echo "listo: $@"

clean: ## Borra build/
	$(if $(BUILD_DIR),,$(error BUILD_DIR vacía: rm -rf no se ejecuta))
	rm -rf -- '$(BUILD_DIR)'

help: ## Muestra los targets disponibles
	@echo "Targets disponibles:"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
		| awk 'BEGIN {FS = ":.*?## "}; {printf "  %-20s %s\n", $$1, $$2}'
```

Pruébalo:

```bash
make all
make clean BUILD_DIR=       # *** BUILD_DIR vacía: rm -rf no se ejecuta.  Stop.
make -n clean               # rm -rf -- 'build', sin borrar nada
make clean
```

Listo. Ve al [lab-01](../2-practicas/lab-01-cada-linea-un-shell/README.md) y ponlo en práctica.
