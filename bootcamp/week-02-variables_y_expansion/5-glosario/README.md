# Glosario — Semana 02: Variables y Expansión en Make

| Término | Definición en una línea | Ejemplo en Makefile |
|---------|------------------------|---------------------|
| Variable recursiva | Variable definida con `=`; su valor se expande cada vez que se usa | `MSG = Hola $(NAME)` |
| Variable simple (simply expanded) | Variable definida con `:=`; su valor se captura una sola vez al asignar | `DATE := $(shell date +%F)` |
| Variable condicional | Variable definida con `?=`; solo asigna si la variable no tiene valor previo | `ENV ?= dev` |
| Append (`+=`) | Agrega texto al valor existente de una variable, separado por un espacio | `FLAGS += -Wextra` |
| Expansión diferida (lazy) | El valor de una variable `=` no se evalúa hasta que se usa en una receta | `TAG = $(VER)-$(ENV)` |
| Expansión inmediata (eager) | El valor de una variable `:=` se evalúa en el momento de la asignación | `HASH := $(shell git rev-parse --short HEAD)` |
| Forward reference | Referenciar una variable que se define más adelante en el archivo; solo funciona con `=` | `A = $(B)` seguido de `B = hola` |
| Recursión infinita | Error producido cuando una variable `=` se referencia a sí misma | `X = $(X)-extra` → error de Make |
| Override (CLI) | Argumento pasado a make en la línea de comandos que sobreescribe variables del Makefile | `make ENV=prod VERSION=2.0` |
| `override` (keyword) | Declaración en el Makefile que impone un valor sin importar lo que venga del CLI | `override SAFETY := on` |
| Variable de entorno | Variable exportada en el shell que Make hereda automáticamente | `export DB_HOST=prod-db` → disponible en el Makefile |
| `$(MAKE)` | Variable especial de Make que referencia el ejecutable de make actual; preserva flags | `$(MAKE) -C subdir` |
| Precedencia de variables | Jerarquía que determina qué valor gana: `override` > CLI > entorno > asignación normal > `?=` | `make VAR=x` gana a `VAR ?= y` |
| `MAKEFILE_LIST` | Variable automática con la lista de Makefiles cargados; útil para el patrón `help` | `grep -E ... $(MAKEFILE_LIST)` |
