# Contexto — Reglas de patrón

## ¿Por qué importa esto?

Sin reglas de patrón, cada `.o` necesita su propia regla. Cinco módulos C = cinco reglas casi idénticas. Con `%.o: %.c`, una sola regla compila todos. Agregas un módulo nuevo: no tocas el Makefile. El `%` captura el stem (la parte variable del nombre) y Make instancia la regla una vez por cada target que necesite construirse.

## Referencia rápida

| Sintaxis | Nombre | Cuándo usarla |
|----------|--------|---------------|
| `%.o: %.c` | Regla de patrón | Plantilla para cualquier `.o` que alguien pida |
| `build/%.o: src/%.c` | Patrón con prefijo de directorio | Target y prerrequisito en directorios distintos |
| `$(OBJS): %.o: %.c` | Static pattern rule | Aplicar el patrón solo a una lista concreta de targets |
| `$*` | Stem | Lo que casó con `%` (`main`, `net/http`) |

Una regla de patrón es una **plantilla**: nunca se ejecuta por sí misma. Solo se usa cuando Make necesita un target concreto, no tiene receta para él, y el prerrequisito (`main.c`) existe o se puede construir. Si el prerrequisito no existe, la regla se descarta en silencio y el error es `No rule to make target 'main.o'`.

## Ejemplo funcional — pega y ejecuta

En un directorio vacío, crea tres fuentes de prueba:

```bash
printf 'int add(int a, int b) { return a + b; }\n' > math.c
printf '#include <stdio.h>\nvoid greet(void) { puts("Hola desde Make!"); }\n' > greet.c
printf '#include <stdio.h>\nint add(int, int); void greet(void);\nint main(void) { printf("add(3, 4) = %%d\\n", add(3, 4)); greet(); return 0; }\n' > main.c
```

Guarda esto como `Makefile`:

```makefile
SHELL       := bash
.SHELLFLAGS := -eu -o pipefail -c
.DELETE_ON_ERROR:

.PHONY: all clean help
.DEFAULT_GOAL := help

CC     := gcc
CFLAGS := -Wall -std=c11
BUILD  := build
SRCS   := main.c math.c greet.c
OBJS   := $(SRCS:%.c=$(BUILD)/%.o)
APP    := $(BUILD)/app

all: $(APP) ## Compila la aplicación

$(APP): $(OBJS)
	$(CC) $^ -o $@

# Regla de patrón: cualquier build/X.o a partir de X.c
$(BUILD)/%.o: %.c
	@mkdir -p $(@D)
	$(CC) $(CFLAGS) -c $< -o $@

clean: ## Elimina build/
	$(if $(BUILD),,$(error BUILD vacía: rm -rf no se ejecuta))
	rm -rf -- '$(BUILD)'

help: ## Muestra los targets disponibles
	@echo "Targets disponibles:"
	@grep -hE '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
		| awk 'BEGIN {FS = ":.*?## "}; {printf "  %-20s %s\n", $$1, $$2}'
```

```bash
make all && ./build/app     # compila 3 objetos, enlaza, imprime add(3, 4) = 7
make all                    # make: Nothing to be done for 'all'.
touch math.c && make all    # recompila solo build/math.o y reenlaza
```

Make necesita `build/main.o`. Busca una regla que lo produzca. `$(BUILD)/%.o` casa con stem `main`. Sustituye el stem en el prerrequisito: `main.c`. Existe, así que ejecuta la receta con `$< = main.c` y `$@ = build/main.o`. La segunda ejecución no hace nada porque cada `.o` es más nuevo que su `.c`.

## Static pattern rule — cuándo usarla

```makefile
LIB_OBJS := build/lib/math.o build/lib/greet.o

# El patrón solo aplica a los targets de LIB_OBJS
$(LIB_OBJS): build/lib/%.o: %.c
	@mkdir -p $(@D)
	$(CC) $(CFLAGS) -DLIB -c $< -o $@
```

La static pattern rule fija **la lista de targets** a los que aplica. No es una plantilla que Make consulta para cualquier nombre: son reglas explícitas, una por target, escritas con la sintaxis del patrón. Por eso, si falta `greet.c`, el error dice exactamente qué falta y quién lo necesita, y `make build/lib/main.o` falla aunque exista `main.c`.

## Una trampa frecuente

```makefile
# INCORRECTO: build/ puede no existir → "No such file or directory"
build/%.o: src/%.c
	$(CC) $(CFLAGS) -c $< -o $@
```

```makefile
# CORRECTO: crea el directorio del target antes de compilar
build/%.o: src/%.c
	@mkdir -p $(@D)
	$(CC) $(CFLAGS) -c $< -o $@
```

El stem puede incluir barras: para `build/net/http.o` el stem es `net/http` y `$(@D)` es `build/net`. El mismo `mkdir -p` sirve para cualquier profundidad.

---

Sigue con [02-reglas-implicitas.md](02-reglas-implicitas.md) o ve directo al [lab-01](../2-practicas/lab-01-patron-basico/README.md).
