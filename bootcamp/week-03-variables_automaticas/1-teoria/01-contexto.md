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

```makefile
.PHONY: all clean help

.DEFAULT_GOAL := help

CC     := gcc
CFLAGS := -Wall -std=c11
BUILD  := build
SRCS   := main.c utils.c
OBJS   := $(SRCS:%.c=$(BUILD)/%.o)
APP    := $(BUILD)/programa

## all: compila el programa
all: $(APP)

$(APP): $(OBJS)
	$(CC) $^ -o $@

$(BUILD)/%.o: %.c
	@mkdir -p $(@D)
	$(CC) $(CFLAGS) -c $< -o $@

## clean: elimina build/
clean:
	@rm -rf $(BUILD)

## help: muestra esta ayuda
help:
	@grep -E '^## ' $(MAKEFILE_LIST) \
		| awk 'BEGIN {FS = ": "}; {printf "  %-20s %s\n", $$1, $$2}' \
		| sed 's/## //'
```

La regla `$(BUILD)/%.o: %.c` aplica a `main.c` y a `utils.c` con el mismo código. Make resuelve para cada uno:

- `build/main.o`: `$<` = `main.c`, `$@` = `build/main.o`, `$(@D)` = `build`
- `build/utils.o`: `$<` = `utils.c`, `$@` = `build/utils.o`, `$(@D)` = `build`

## Una trampa frecuente

`$@` solo tiene valor dentro de una receta. Si intentas usarlo en una asignación de variable al nivel del Makefile:

```makefile
# INCORRECTO: $@ es vacío aquí, fuera de cualquier receta
SALIDA := artefacto-$@.zip
```

`SALIDA` quedará como `artefacto-.zip`. Las variables automáticas no tienen valor fuera de las recetas.

---

Listo. Ve al [lab-01](../2-practicas/lab-01-target-nombre/README.md) y ponlo en práctica.
