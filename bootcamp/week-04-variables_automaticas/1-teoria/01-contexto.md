# Contexto — Variables automáticas

## ¿Por qué importa esto?

Sin variables automáticas, cada regla de compilación repite el nombre del target y de los archivos fuente. Cambias un nombre de archivo y rompes tres líneas de Makefile. Con variables automáticas, una sola regla de patrón `%.o: %.c` compila cualquier archivo C del proyecto: Make inyecta el nombre correcto en `$@` y `$<` en cada invocación, sin que lo escribas tú.

## Referencia rápida

| Variable | Significado | Cuándo usarla |
|----------|-------------|---------------|
| `$@` | Nombre del target actual | Siempre que la receta produce el target como archivo de salida |
| `$<` | Primer prerrequisito | Compiladores que toman un solo fuente (`gcc -c $<`) |
| `$^` | Todos los prerrequisitos (deduplicado) | Linkers que necesitan todos los objetos (`gcc $^ -o $@`) |
| `$?` | Solo los prerrequisitos más nuevos que el target | Targets reales (no phony) para builds incrementales |
| `$*` | Stem que coincidió con `%` | Solo en reglas de patrón, para derivar rutas desde el nombre base |
| `$(@D)` | Directorio de `$@` | Junto con `mkdir -p` cuando el dir de salida puede no existir |
| `$(@F)` | Nombre de archivo de `$@` | Para separar el nombre del path cuando el target tiene prefijo de ruta |

También existen `$(<D)` / `$(<F)` para las mismas partes de `$<`.

## Ejemplo funcional — pega y ejecuta

Crea antes dos fuentes mínimas:

```bash
printf 'void util(void) {}\n' > utils.c
printf 'void util(void);\nint main(void) { util(); return 0; }\n' > main.c
```

```makefile
SHELL       := bash
.SHELLFLAGS := -eu -o pipefail -c
.DELETE_ON_ERROR:

.PHONY: all clean help

.DEFAULT_GOAL := help

CC     := gcc
CFLAGS := -Wall -std=c11
BUILD  := build
SRCS   := main.c utils.c
OBJS   := $(SRCS:%.c=$(BUILD)/%.o)
APP    := $(BUILD)/programa

all: $(APP) ## compila el programa

$(APP): $(OBJS)
	$(CC) $^ -o $@

$(BUILD)/%.o: %.c
	@mkdir -p $(@D)
	$(CC) $(CFLAGS) -c $< -o $@

clean: ## elimina build/
	$(if $(BUILD),,$(error BUILD vacía: rm -rf no se ejecuta))
	@rm -rf -- '$(BUILD)'

help: ## muestra esta ayuda
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
		| awk 'BEGIN {FS = ":.*?## "}; {printf "  %-20s %s\n", $$1, $$2}'
```

Las tres primeras líneas son el preámbulo estricto y `clean` lleva la guarda de `rm -rf`, ambos de la semana 03. La regla `$(BUILD)/%.o: %.c` aplica a `main.c` y a `utils.c` con el mismo código. Make resuelve para cada uno:

- `build/main.o`: `$<` = `main.c`, `$@` = `build/main.o`, `$(@D)` = `build`
- `build/utils.o`: `$<` = `utils.c`, `$@` = `build/utils.o`, `$(@D)` = `build`

## Una trampa frecuente

`$@` solo tiene valor dentro de una receta. Si intentas usarlo en una asignación de variable al nivel del Makefile:

```makefile
# INCORRECTO: $@ es vacío aquí, fuera de cualquier receta
SALIDA := artefacto-$@.zip
```

`SALIDA` quedará como `artefacto-.zip`. Las variables automáticas no tienen valor fuera de las recetas.

## Headers: que Make los vea

`build/main.o: main.c` no sabe que `main.c` incluye `calc.h`. Si cambias el header, Make no recompila y el binario queda con código viejo. No escribas esas dependencias a mano: pídeselas al compilador.

```makefile
DEPS := $(OBJS:.o=.d)

$(BUILD)/%.o: %.c
	@mkdir -p $(@D)
	$(CC) $(CFLAGS) -MMD -MP -c $< -o $@

-include $(DEPS)
```

`-MMD` hace que gcc escriba `build/main.d` con los headers que incluye `main.c`; `-include` lo carga sin fallar la primera vez, cuando aún no existe. `-MP` añade una regla vacía por header, así borrar uno no rompe el build. La semana 06 profundiza en esto.

---

Listo. Ve al [lab-01](../2-practicas/lab-01-target-nombre/README.md) y ponlo en práctica.
