# Condicionales, include y depuración

## ¿Por qué importa esto?

Un Makefile que solo funciona en tu máquina, en un entorno y en un proyecto no
escala. Los profesionales se adaptan al entorno con condicionales, reparten la
lógica en módulos con `include`, comprueban la versión de Make antes de
empezar y, cuando algo falla, saben preguntarle a Make qué está haciendo.

## Dos fases: leer y ejecutar

Todo lo de esta semana se entiende con una idea. Make trabaja en dos fases:

1. **Lectura.** Lee el Makefile de arriba abajo: asigna variables, evalúa
   `ifeq`/`ifdef`, procesa `include` y expande las funciones que están fuera
   de las recetas.
2. **Ejecución.** Decide qué targets rehacer y, para cada uno, expande su
   receta y la ejecuta.

Un `ifeq` decide en la fase 1, con el valor global de la variable: no ve
variables de target ni la salida de ninguna receta. Un `$(error)` a nivel de
archivo detiene cualquier `make`, incluido `make help`; dentro de una receta,
solo el target que lo contiene.

## Condicionales

```makefile
ENV ?= development

ifeq ($(filter $(ENV),development staging production),)
  $(error ENV='$(ENV)' no es válido)
endif

ifeq ($(ENV),production)
  FLAGS := --release
else
  FLAGS := --debug
endif

# ifdef: ¿tiene valor no vacío? Con CI= es falso.
ifdef CI
  FLAGS += --ci
endif

show:
	@echo "ENV=$(ENV) FLAGS=$(FLAGS)"
```

Pruébalo con `make show ENV=staging`, `CI=1 make show` y `make show ENV=prod`.

Cuidado con los comentarios en la línea de una asignación:
`ENV := production # entorno` guarda `production ` con espacio final, y el
`ifeq` deja de ser verdadero.

## Include y módulos

`include archivo` inserta el texto en ese punto: el orden importa. `-include`
no falla si el archivo falta, y sirve para overrides locales. Si un incluido
tiene regla, Make lo rehace y vuelve a leer todo:

```makefile
include version.mk

version.mk: VERSION
	@echo "VERSION := $$(cat $<)" > $@

show:
	@echo "versión $(VERSION)"
```

Con `echo 1.4.0 > VERSION`, `make show` genera `version.mk` y muestra la
versión. Las rutas de `include` son relativas al directorio donde corre Make;
por eso a los módulos se entra con `-C`.

> [!WARNING]
> `include .env` parsea el archivo **como Makefile**: comillas, `$` y `#` no
> significan lo mismo que en shell. Si lo usas, que sea con valores simples.

## Recursión

```makefile
MODULES := api worker
ENV     ?= development

all: $(addsuffix /build,$(MODULES))

$(addsuffix /build,$(MODULES)):
	$(MAKE) -C $(@D) build ENV=$(ENV)

.PHONY: all $(addsuffix /build,$(MODULES))
```

Necesita `api/Makefile` y `worker/Makefile` con un target `build`. Cada
módulo es un target: si uno falla, Make se detiene. Al sub-make llegan
solo las variables de la línea de comandos (vía `MAKEFLAGS`), las del entorno
y las exportadas por nombre (`export VAR`). Lo que el padre define en su
Makefile hay que pasarlo explícitamente, como `ENV=$(ENV)`. Paralelismo y
recursión a fondo: Semana 10.

## Depuración y portabilidad

| Herramienta | Qué te dice |
|---|---|
| `$(info x)` / `$(warning x)` / `$(error x)` | Imprime / avisa con archivo:línea / detiene |
| `make -n` | Comandos sin ejecutarlos (las funciones sí se expanden) |
| `make --debug=b` | Qué targets rehace y qué prerrequisito es más nuevo |
| `make --trace` | Línea del Makefile que rehace cada target y por qué |
| `make --warn-undefined-variables` | Cada `$(VAR)` que no existe: typos silenciosos |
| `make -p` | Base de datos completa, con el origen de cada variable |
| `$(MAKECMDGOALS)` | Targets pedidos: validar solo lo necesario |

La versión importa: macOS trae la 3.81 y este bootcamp exige 4.3. Una guarda
sin `$(shell)` (`$(sort)` ordena como texto; vale mientras no exista una 4.10):

```makefile
MIN_MAKE_VERSION := 4.3
ifneq ($(MIN_MAKE_VERSION),$(firstword $(sort $(MAKE_VERSION) $(MIN_MAKE_VERSION))))
  $(error Requiere GNU Make >= $(MIN_MAKE_VERSION); tienes $(MAKE_VERSION))
endif

ifeq ($(filter grouped-target,$(.FEATURES)),)
  $(error Tu Make no soporta grouped targets (&:))
endif

doctor:
	$(info MAKE_VERSION = $(MAKE_VERSION))
	$(info MAKECMDGOALS = $(MAKECMDGOALS))
	@echo "OK"
```

Simula una versión vieja con `make doctor MAKE_VERSION=3.81`.

> [!NOTE]
> **Make 4.4+.** `$(intcmp)` compara enteros y no se confunde con 4.10. En 4.3
> no existe y expande a vacío: usa la guarda con `$(sort)`.

---

Listo. Ve al [lab-01](../2-practicas/lab-01-condicionales/README.md) y ponlo en práctica.
