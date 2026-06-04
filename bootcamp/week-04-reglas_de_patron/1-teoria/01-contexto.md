# Contexto — Reglas de patrón

## ¿Por qué importa esto?

Sin reglas de patrón, cada `.o` necesita su propia regla. Cinco módulos C = cinco reglas casi idénticas. Con `%.o: %.c`, una sola línea compila todos. Agregas un módulo nuevo: no tocas el Makefile. El `%` captura el stem (nombre sin extensión) y Make instancia la regla una vez por cada target que necesite construirse.

## Referencia rápida

| Sintaxis | Nombre | Cuándo usarla |
|----------|--------|---------------|
| `%.o: %.c` | Regla de patrón | Aplica a todos los `.o` del proyecto |
| `build/%.o: src/%.c` | Patrón con prefijo de directorio | Target y prerrequisito en dirs distintos |
| `$(OBJS): %.o: %.c` | Static pattern rule | Aplicar patrón solo a targets específicos |
| `%` en prerrequisito | Expansión del stem | El stem del target se copia al prerrequisito |

## Ejemplo funcional — pega y ejecuta

```makefile
.PHONY: all clean help

.DEFAULT_GOAL := help

CC     := gcc
CFLAGS := -Wall -std=c11
BUILD  := build
SRCS   := main.c math.c greet.c
OBJS   := $(SRCS:.c=.o)
APP    := $(BUILD)/app

## all: compila la aplicación
all: $(APP)

$(APP): $(OBJS)
	@mkdir -p $(BUILD)
	$(CC) $^ -o $@

# Regla de patrón: compila cualquier .c a .o
%.o: %.c
	$(CC) $(CFLAGS) -c $< -o $@

## clean: elimina objetos y el binario
clean:
	@rm -f $(OBJS) $(APP)

## help: muestra esta ayuda
help:
	@grep -E '^## ' $(MAKEFILE_LIST) \
		| awk 'BEGIN {FS = ": "}; {printf "  %-20s %s\n", $$1, $$2}' \
		| sed 's/## //'
```

Make ve que necesita `main.o`. Busca una regla que produzca `main.o`. La regla `%.o: %.c` coincide con stem `main`. Busca el prerrequisito `main.c`. Si existe, ejecuta la receta con `$< = main.c` y `$@ = main.o`.

## Static pattern rule — cuándo usarla

```makefile
LIB_OBJS := build/math.o build/string_ops.o
APP_OBJS := build/main.o

# Solo compila LIB_OBJS con este patrón
$(LIB_OBJS): build/%.o: src/%.c
	$(CC) $(CFLAGS) -c $< -o $@

# APP_OBJS usa otra ruta o regla distinta
$(APP_OBJS): build/%.o: app/%.c
	$(CC) $(CFLAGS) -c $< -o $@
```

La static pattern rule es útil cuando tienes grupos de archivos en directorios distintos que deben compilarse con patrones diferentes, pero quieres evitar solapamientos.

## Una trampa frecuente

```makefile
# INCORRECTO: el directorio build/ puede no existir
build/%.o: src/%.c
	$(CC) $(CFLAGS) -c $< -o $@
```

```makefile
# CORRECTO: crea el directorio antes de compilar
build/%.o: src/%.c
	@mkdir -p $(@D)
	$(CC) $(CFLAGS) -c $< -o $@
```

`$(@D)` es el directorio del target. Si el target es `build/sub/calc.o`, `$(@D)` = `build/sub`. Así el `mkdir -p` funciona para cualquier profundidad.

---

Listo. Ve al [lab-01](../2-practicas/lab-01-patron-basico/README.md) y ponlo en práctica.
