# Rúbrica de Evaluación — Semana 02

> Variables y expansión. Se evalúan tres evidencias por separado, y hace falta
> **70% en cada una**: un Makefile que imprime bien la configuración no
> compensa no saber por qué `ENV=prod make` seguía desplegando en `dev`.

---

## 📊 Distribución de Evidencias

| Evidencia | Peso | Instrumento |
|---|:--:|---|
| 🧠 Conocimiento | 30% | Las 10 preguntas de esta rúbrica, respondidas por escrito |
| 💪 Desempeño | 40% | Los 6 labs, con sus criterios de éxito verificados en tu máquina |
| 📦 Producto | 30% | Makefile multi-entorno del proyecto: 60 pts de autograding + 40 pts de calidad |

**Mínimo 70% en cada evidencia.** No en el promedio.

| Calificación | Rango |
|---|:--:|
| Sobresaliente | 90-100% |
| Notable | 80-89% |
| Aprobado | 70-79% |
| No aprobado | < 70% |

---

## 🧠 Conocimiento (30%)

Diez preguntas, 3 puntos cada una. No se pide recordar qué operador es cuál: se
pide explicar por qué se comportan así.

| # | Pregunta |
|:--:|---|
| 1 | En el lab 02, `SALUDO_LAZY` imprime `Hola, Mundo!` y `SALUDO_EAGER` imprime `Hola, !`, con las dos variables definidas en el mismo orden. ¿Por qué? |
| 2 | `VERSION = $(VERSION)-snapshot` detiene Make con `Recursive variable 'VERSION' references itself`, pero `VERSION := $(VERSION)-snapshot` funciona. ¿Por qué uno es un bucle y el otro no? |
| 3 | `VERSION ?= $(shell git describe ...)` parece un default inocente. ¿Por qué ejecuta `git` cada vez que se usa `VERSION`, y cómo lo evita el proyecto? |
| 4 | Con `ENV := dev`, `make config ENV=prod` muestra `prod` pero `ENV=prod make config` muestra `dev`. ¿Por qué la línea de comandos gana y la variable de entorno no? ¿Qué cambia con `?=`? |
| 5 | `make config ENV=` muestra un entorno vacío en lugar de `dev`, aunque `ENV ?= dev`. ¿Por qué `?=` no aplicó el default? |
| 6 | Si `ENV ?= dev` va antes, `IMAGE_TAG := ...$(ENV)` también recoge `make config ENV=prod`. Entonces, ¿por qué el proyecto define `IMAGE_TAG` con `=`? Da un caso en el que `:=` daría un valor equivocado. |
| 7 | En el lab 01, `LIBS := -lm` seguido de `LIBS += -lpthread` deja `LIBS` como variable simple. ¿Por qué `+=` conserva el tipo original, y qué cambia si la primera asignación usa `=`? |
| 8 | En el lab 06, `FLAGS := -Wall` seguido de `FLAGS = -Wextra` pierde `-Wall` y Make no avisa. ¿Por qué no es un error, y qué le pasa además al tipo de `FLAGS`? |
| 9 | ¿Por qué `override` gana a la línea de comandos, y en qué caso real tiene sentido usarlo con `+=`? |
| 10 | `make -p` muestra `IMAGE_TAG = $(REGISTRY)/$(APP_NAME):...` pero `BUILD_DATE := 2026-01-15`. Y en el lab 03, `PRECIO_BANG != echo 'cuesta $$5'` pierde el `$5` mientras `PRECIO_SHELL := $(shell echo 'cuesta $$5')` lo conserva. ¿Qué explica las dos cosas a la vez? |

<details>
<summary><strong>Respuestas</strong></summary>

**1.** `=` guarda el texto `Hola, $(DESTINATARIO_LAZY)!` y lo expande al
usarse, en la receta; para entonces Make ya leyó todo el archivo y
`DESTINATARIO_LAZY` vale `Mundo`. `:=` expande en el momento de la asignación,
cuando `DESTINATARIO_EAGER` todavía no existe y vale cadena vacía.

**2.** Con `=`, expandir `VERSION` exige expandir `VERSION`, que exige expandir
`VERSION`... sin fin; Make lo detecta y se detiene. Con `:=`, el lado derecho
se expande una sola vez con el valor anterior de `VERSION` y el resultado se
guarda; no queda ninguna referencia pendiente.

**3.** `?=` crea una variable recursiva, igual que `=`: guarda el texto
`$(shell ...)` y lo expande en cada uso, así que cada aparición de `VERSION`
(directa o a través de `IMAGE_TAG`) lanza otro proceso. El proyecto calcula
`GIT_VERSION := $(shell ...)` una vez y deja `VERSION ?= $(GIT_VERSION)`, que
sigue siendo sobreescribible pero ya no ejecuta nada.

**4.** Precedencia: la línea de comandos está por encima de cualquier
asignación del Makefile; las variables de entorno están por debajo. `ENV := dev`
pisa el valor que vino del entorno. `?=` solo asigna si la variable no está
definida, y una variable de entorno cuenta como definida, así que con
`ENV ?= dev` el valor del entorno sobrevive. `$(origin ENV)` lo confirma: `file`
con `:=`, `environment` con `?=`.

**5.** `?=` comprueba si la variable está *definida*, no si está vacía.
`ENV=` en la línea de comandos la define con valor vacío, y `?=` no la toca.

**6.** Con `=` el valor se calcula al usarse, con lo que valga `ENV` en ese
momento. Si `ENV` cambia después de la línea de `IMAGE_TAG`, por ejemplo con
una variable específica de target (`deploy-prod: ENV := prod`), `:=` ya
congeló `...-dev` y el target despliega la imagen equivocada; `=` da `...-prod`.

**7.** `+=` añade texto respetando cómo se definió la variable: si era simple,
expande lo añadido en el momento; si era recursiva, lo guarda sin expandir.
Con `LIBS = -lm`, `LIBS += $(EXTRA)` funcionaría aunque `EXTRA` se defina más
abajo, porque se expande al usarse.

**8.** Make permite redefinir una variable cuantas veces quieras: la última
asignación gana, sin aviso. `FLAGS = -Wextra` reemplaza el valor entero, no lo
amplía. Además el tipo pasa a ser el de la última asignación: `FLAGS` deja de
ser simple y se vuelve recursiva.

**9.** Una asignación normal se ignora si la variable llegó por línea de
comandos; `override` le pide a Make que la aplique igualmente. Con `+=` sirve
para flags obligatorias: `override CFLAGS += -Wall` respeta el `make CFLAGS=-O2`
del usuario y añade `-Wall`, que dejaría de estar si el usuario sobreescribiera
`CFLAGS` sin `override`.

**10.** El tipo de variable. Una recursiva (`=`) guarda texto y lo expande en
cada uso; una simple (`:=`) se expandió al asignarse y guarda el resultado
final. `make -p` lo enseña tal cual. `!=` ejecuta el comando una sola vez, pero
guarda su salida como texto de una variable **recursiva** (`$(flavor
PRECIO_BANG)` dice `recursive`): al usarla, Make expande `$5` como variable y
queda vacía. `:= $(shell ...)` guarda la salida como valor final y el `$`
sobrevive.

</details>

---

## 💪 Desempeño (40%)

Diez puntos por lab. El Desempeño es la suma sobre 60, llevada a porcentaje.
Cada criterio de éxito se comprueba ejecutando el comando en tu máquina.

| Lab | Criterio | Puntos |
|---|---|:--:|
| [01 — Variables básicas](2-practicas/lab-01-variables-basicas/README.md) | `info-compilador`, `info-entorno` e `info-libs` imprimen los valores esperados; `make info-entorno ENV=prod` muestra `prod`; `make tipos` muestra el `flavor` correcto de cada variable | 10 |
| [02 — Expansión recursiva](2-practicas/lab-02-expansion-recursiva/README.md) | `make lazy` imprime `Hola, Mundo!` y `make eager` imprime `Hola, !`; `make peligro` falla por recursión y `make corregido` imprime `v1.0-snapshot` | 10 |
| [03 — Expansión inmediata](2-practicas/lab-03-expansion-inmediata/README.md) | Las dos lecturas de `TIMESTAMP_EAGER` son idénticas; `make git-info` muestra hash y versión, o `no-git`; `make asignar-shell` muestra la diferencia entre `!=` y `:= $(shell ...)` | 10 |
| [04 — Variables condicionales](2-practicas/lab-04-variables-condicionales/README.md) | `make config` muestra los defaults; `SERVER_PORT` cambia desde CLI y `SERVER_HOST` desde el entorno; `make origen` distingue `file`, `environment` y `command line` | 10 |
| [05 — Override desde CLI](2-practicas/lab-05-override-cli/README.md) | `make info ENV=prod VERSION=1.5.0` muestra `registry.local/myapp:1.5.0-prod`; `deploy` ejecuta `build` primero; `make build BUILD_FLAGS=--no-cache` conserva `--pull` | 10 |
| [06 — Variables rotas](2-practicas/lab-06-variables-rotas/README.md) | Los cuatro `check-*` imprimen el valor correcto; usas `make diagnostico` y `make -p` para explicar la causa de cada bug | 10 |

Dentro de cada lab: 10 puntos si se cumplen todos los criterios y explicas con
tus palabras por qué cada operador se comporta así; 8 si se cumplen todos; 7 si
falla uno; menos de 7 si fallan dos o más.

---

## 📦 Producto (30%)

### Verificable por el autograding — 60 puntos

Lo ejecuta `./scripts/verificar-semana.sh 02`. Es binario: pasa o no pasa.

| Comprobación | Puntos |
|---|:--:|
| `env-por-defecto` — sin `ENV`, `make config` muestra el entorno `dev` | 4 |
| `env-desde-cli` — `make config ENV=staging` muestra el entorno `staging` | 4 |
| `env-desde-entorno` — `ENV` exportada en la shell cambia el entorno sin tocar el Makefile | 5 |
| `version-por-defecto` — sin `VERSION`, la imagen lleva una versión no vacía | 4 |
| `imagen-sigue-cli` — `ENV` y `VERSION` desde la línea de comandos llegan a la imagen | 4 |
| `db-url-sigue-env` — la URL de base de datos incluye el entorno activo | 4 |
| `db-host-cli` — `DB_HOST` se puede cambiar desde la línea de comandos | 4 |
| `origen-cli` — `make config ENV=staging` informa de que `ENV` viene de la línea de comandos | 4 |
| `origen-entorno` — con `ENV` exportada, `make config` informa de que viene del entorno | 4 |
| `build-args-obligatorio` — `make build BUILD_ARGS=--no-cache` conserva el flag obligatorio `--pull` | 5 |
| `image-tag-recursiva` — `IMAGE_TAG` se define con `=` y referencia a `ENV` | 5 |
| `build-date-inmediata` — `BUILD_DATE` se define con `:=` y guarda una fecha | 5 |
| `deploy-orden` — `make deploy` ejecuta `build` y `test` antes de desplegar | 4 |
| `clean-sin-dist` — `make clean` no falla aunque `dist/` no exista | 4 |
| **Total** | **60** |

### Calidad — 40 puntos

Lo que el autograding no puede ver.

| Criterio | Excelente | Suficiente | Puntos |
|---|---|---|:--:|
| **Operador correcto en cada variable** | `?=` para todo lo configurable, `:=` para todo `$(shell ...)`, `=` solo para valores derivados | Un operador mal elegido | 10 |
| **Cero valores de entorno en recetas** | Ninguna receta escribe `dev`, `staging`, `prod`, hosts ni el registry: todo sale de variables | Un literal en un mensaje | 8 |
| **`$(shell ...)` una sola vez** | `git describe` y `date` se ejecutan una vez por invocación de Make | Una variable recursiva con `$(shell ...)` usada una sola vez | 6 |
| **`.PHONY` completo** | Todos los targets declarados | Falta uno | 6 |
| **Orden y secciones** | Variables agrupadas con comentario de sección, y cada `=` explica por qué no es `:=` | Variables dispersas | 6 |
| **`help` útil** | Muestra la línea de uso con `ENV` y `VERSION`, y todos los targets con descripción | Falta alguno | 4 |
| **Total** | | | **40** |

### Penalizaciones

| Situación | Deducción |
|---|:--:|
| Un valor de producción escrito a mano en una receta | −10 pts. El Makefile deja de ser multi-entorno |
| `ENV := dev` u otro default con `:=` que ignora el entorno exportado | −5 pts |
| `make` sin argumentos ejecuta `deploy` o `build` en lugar de mostrar la ayuda | −5 pts |

---

## 📋 Checklist de entrega

- [ ] Los 6 labs con sus criterios de éxito comprobados en tu máquina
- [ ] Las 10 preguntas de Conocimiento respondidas por escrito
- [ ] `3-proyecto/starter/Makefile` sin ningún `TODO`
- [ ] `./scripts/verificar-semana.sh 02` con las 14 comprobaciones en verde
- [ ] `make config`, `make config ENV=staging` y `ENV=prod make config` muestran tres entornos distintos

---

[← Volver a la Semana 02](README.md)
