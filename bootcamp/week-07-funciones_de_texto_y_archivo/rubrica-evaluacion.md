# Rúbrica de Evaluación — Semana 07

> Funciones de texto y archivo. Se evalúan tres evidencias por separado, y hace
> falta **70% en cada una**: un Makefile que compila hoy no compensa no saber
> por qué mañana se traga el `.c` que acabas de añadir.

---

## 📊 Distribución de Evidencias

| Evidencia | Peso | Instrumento |
|---|:--:|---|
| 🧠 Conocimiento | 30% | Las 10 preguntas de esta rúbrica, respondidas por escrito |
| 💪 Desempeño | 40% | Los 6 labs, con sus criterios de éxito verificados en tu máquina |
| 📦 Producto | 30% | Build multi-módulo del proyecto: 60 pts de autograding + 40 pts de calidad |

**Mínimo 70% en cada evidencia.** No en el promedio.

| Calificación | Rango |
|---|:--:|
| Sobresaliente | 90-100% |
| Notable | 80-89% |
| Aprobado | 70-79% |
| No aprobado | < 70% |

---

## 🧠 Conocimiento (30%)

Diez preguntas, 3 puntos cada una. No se pide recordar la firma de cada
función: se pide explicar por qué se comportan así.

| # | Pregunta |
|:--:|---|
| 1 | Escribes `SRCS := src/*.c` sin `$(wildcard)` y luego `OBJS := $(SRCS:.c=.o)`. ¿Qué vale `OBJS`, por qué, y qué termina haciendo Make con él? |
| 2 | Una regla genera `gen/tabla.c` durante el build, pero `$(wildcard gen/*.c)` no la incluye en la misma ejecución. ¿Por qué? |
| 3 | `$(subst .c,.o,lib.core/main.c)` devuelve `lib.oore/main.o`. ¿Por qué `$(patsubst %.c,%.o,...)` no tiene ese problema? |
| 4 | `$(filter .c,main.c util.h)` devuelve cadena vacía. ¿Por qué, si `main.c` termina en `.c`? |
| 5 | `$(filter-out docs,$(FILES))` no quita `docs/README.md` de la lista. ¿Por qué, y qué patrón sí lo quita? |
| 6 | El proyecto compila `modules/auth/auth.c` a `build/modules/auth/auth.o` y no a `build/auth.o`. ¿Qué se rompe si aplanas las rutas con `$(notdir)`? |
| 7 | ¿Por qué `MODULE_DIRS` se calcula con `$(sort $(dir ...))` y no solo con `$(dir ...)`? Da el caso concreto que lo exige. |
| 8 | `$(subst a, b,xax)` devuelve `x bx`, con un espacio. ¿Por qué, y por qué en una lista de archivos este error puede pasar inadvertido? |
| 9 | ¿Por qué se escribe `SRCS := $(wildcard src/*.c)` y no `SRCS = $(wildcard src/*.c)`? ¿Qué cambia en cada referencia a `$(SRCS)`? |
| 10 | Añades `modules/net/net.c` y se compila solo; añades `modules/net/tls/tls.c` y no. ¿Por qué, si no tocaste el Makefile en ningún caso? |

<details>
<summary><strong>Respuestas</strong></summary>

**1.** `OBJS` vale `src/*.o`, literal. Make no expande comodines en una
asignación: la cadena viaja tal cual y la sustitución opera sobre texto. Al
usarla como prerrequisito Make intenta casar `src/*.o` con archivos; como no
hay ninguno, la deja literal y busca cómo construir un archivo que se llama
`src/*.o`. Con la regla implícita de C acaba ejecutando
`cc -c -o src/*.o src/a.c`: un archivo con un asterisco en el nombre. Solo
`$(wildcard)` convierte el patrón en la lista real de archivos.

**2.** `$(wildcard)` en una asignación `:=` se evalúa al leer el Makefile,
antes de ejecutar una sola receta. En ese momento `gen/tabla.c` todavía no
existe. Además Make guarda en caché el contenido de los directorios que ya
leyó, así que ni siquiera un `$(wildcard)` dentro de la receta lo ve
siempre. Los archivos generados se listan explícitamente, no se descubren.

**3.** `subst` reemplaza cada aparición del texto, esté donde esté: el `.c` de
`.core` también cuenta. `patsubst` trabaja por palabras y el patrón `%.c` solo
casa si la palabra termina en `.c`; el `%` absorbe todo lo anterior, puntos
incluidos. Para cambiar extensiones, siempre `patsubst` (o `$(VAR:.c=.o)`,
que es lo mismo).

**4.** Sin `%`, un patrón de `filter` es una palabra literal: solo casa con
una palabra que sea exactamente `.c`. El `%` es lo que significa "cualquier
cosa"; `%.c` sí devuelve `main.c`.

**5.** Por la misma razón: `docs` sin `%` solo elimina la palabra `docs`
exacta. `docs/README.md` es otra palabra. El patrón correcto es `docs/%`, que
casa con todo lo que empieza por `docs/`.

**6.** Dos módulos con un archivo del mismo nombre (`auth/util.c` y
`config/util.c`) producirían el mismo `build/util.o`. Make tendría dos reglas
para un mismo target, una compilación pisaría a la otra y el enlace fallaría
con símbolos duplicados o, peor, faltantes. Conservar la estructura hace que
cada fuente tenga un objeto único.

**7.** `$(dir)` devuelve un directorio por cada palabra, con repeticiones. En
cuanto un módulo tiene dos `.c` (`logger.c` y `metrics.c`), `-Imodules/logger/`
aparece dos veces. `$(sort)` ordena y elimina duplicados, y además hace el
resultado estable aunque cambie el orden de los archivos en disco.

**8.** Make solo recorta espacios en algunos argumentos; en `subst` el espacio
tras la coma forma parte del texto de reemplazo. En una lista de archivos el
espacio extra suele parecer inofensivo porque separa palabras, hasta que cae
en mitad de una ruta y parte un nombre en dos. Por eso se escribe sin espacios
tras las comas: `$(subst a,b,xax)`.

**9.** Con `=` la variable es recursiva: cada vez que se usa `$(SRCS)` se
vuelve a ejecutar `$(wildcard)` y se vuelve a leer el disco. Además, dos
referencias pueden dar resultados distintos si algo cambió entre medias. Con
`:=` se evalúa una vez, al leer esa línea, y todas las referencias ven la misma
lista.

**10.** `modules/*/*.c` tiene exactamente un nivel de directorio entre
`modules/` y el `.c`. `modules/net/net.c` encaja; `modules/net/tls/tls.c`
tiene dos niveles y no. `$(wildcard)` no es recursivo: para otro nivel hay que
añadir `modules/*/*/*.c` o descubrir los archivos con `$(shell find ...)`.

</details>

---

## 💪 Desempeño (40%)

Diez puntos por lab. El Desempeño es la suma sobre 60, llevada a porcentaje.
Cada criterio de éxito se comprueba ejecutando el comando en tu máquina.

| Lab | Criterio | Puntos |
|---|---|:--:|
| [01 — `wildcard`](2-practicas/lab-01-wildcard/README.md) | `make list-sources` descubre 3 fuentes ordenadas y `Logger = ausente`; con `SRC_DIR=vacio` falla con la guarda; tras crear `src/logger.c` muestra 4 y `presente` sin editar el Makefile | 10 |
| [02 — `patsubst`](2-practicas/lab-02-patsubst/README.md) | `make demo` imprime `OBJS`, `TEST_BINS`, `RELEASE_SRCS` y `OBJS_REF` como en el README; `make trampas` muestra `release/releasemap.c` frente a `release/srcmap.c` | 10 |
| [03 — `filter`](2-practicas/lab-03-filter/README.md) | Los 5 subconjuntos de `make demo` coinciden; `make pick DIR=include` lista 2 cabeceras y `make pick DIR=lib` falla listando los directorios | 10 |
| [04 — Rutas](2-practicas/lab-04-rutas/README.md) | Las líneas de `make demo` coinciden; `make modules` da `auth tls logger`; las 4 líneas de `make edge` coinciden y sabes explicarlas | 10 |
| [05 — Combinadas](2-practicas/lab-05-combinadas/README.md) | `make info` muestra las 5 variables; `./build/pipeline` ejecuta los tres módulos; `src/net/http.c` se compila en `build/net/` con `OBJ_DIRS` como prerrequisito order-only | 10 |
| [06 — Funciones rotas](2-practicas/lab-06-funciones-rotas/README.md) | Los 6 bugs corregidos; `make demo` produce la salida esperada, también con `OUT_DIR='  out  '` | 10 |

Dentro de cada lab: 10 puntos si se cumplen todos los criterios y explicas con
tus palabras qué devuelve cada función que usaste; 8 si se cumplen todos; 7 si
falla uno; menos de 7 si fallan dos o más.

---

## 📦 Producto (30%)

### Verificable por el autograding — 60 puntos

Lo ejecuta `./scripts/verificar-semana.sh 07`. Es binario: pasa o no pasa.

| Comprobación | Puntos |
|---|:--:|
| `binario-funciona` — `make all` desde cero produce `build/sistema` y el binario inicia los tres módulos | 6 |
| `objetos-espejo` — los objetos conservan la estructura de directorios de las fuentes dentro de `build/` | 4 |
| `include-por-modulo` — cada directorio de módulo llega al compilador como flag `-I` | 4 |
| `modulo-nuevo-sin-editar` — un `.c` nuevo en `modules/logger/` se compila sin editar el Makefile | 6 |
| `segunda-pasada-sin-trabajo` — una segunda ejecución de `make all` no rehace nada | 3 |
| `report-core` — `make report` cuenta las fuentes core y las lista sin directorio | 3 |
| `report-directorios` — `make report` muestra los directorios de módulo ordenados y sin repetir | 3 |
| `report-objetos` — `make report` cuenta 5 objetos con `$(words)` | 2 |
| `manifest-una-por-linea` — `make manifest` escribe las 5 fuentes, una por línea | 4 |
| `report-modulos` — `make report` lista los nombres de módulo sin directorio ni barra final | 3 |
| `objs-de-modulo` — `make objs MODULE=logger` lista solo los objetos de ese módulo | 4 |
| `objs-modulo-con-espacios` — `make objs` normaliza con `$(strip)` los espacios alrededor de `MODULE` | 3 |
| `objs-modulo-inexistente` — `make objs` con un módulo inexistente falla listando los disponibles | 3 |
| `clean-borra-build` — `make clean` elimina `build/` por completo | 3 |
| `clean-con-guarda` — `make clean` se niega a borrar si `BUILD` está vacío | 5 |
| `shellflags-estrictas` — las recetas corren con `bash -eu -o pipefail` | 2 |
| `delete-on-error` — el Makefile declara `.DELETE_ON_ERROR` | 2 |
| **Total** | **60** |

### Calidad — 40 puntos

Lo que el autograding no puede ver.

| Criterio | Excelente | Suficiente | Puntos |
|---|---|---|:--:|
| **Cero listas a mano** | Ninguna fuente, objeto ni directorio escrito literalmente: todo sale de `$(wildcard)` y funciones | Un nombre literal en un mensaje `@echo` | 10 |
| **La función adecuada** | `patsubst` para extensiones, `sort` para deduplicar, `notdir` solo para mostrar, `strip` sobre valores que llegan de fuera | Algún `subst` donde iba `patsubst` | 8 |
| **`.PHONY` completo** | Todos los targets que no producen archivo están declarados | Falta uno | 6 |
| **`help` útil** | `make` sin argumentos lista todos los targets con descripción | Falta alguno | 6 |
| **Variables comentadas** | Cada variable derivada indica con un ejemplo qué valor produce | Comentarios genéricos | 5 |
| **Orden y secciones** | Preámbulo, variables de descubrimiento, derivadas, reglas, utilidades | Variables dispersas | 5 |
| **Total** | | | **40** |

### Penalizaciones

| Situación | Deducción |
|---|:--:|
| `rm -rf` sobre una variable sin guarda de vacío | **−15 pts**. Un `BUILD` vacío por un typo no puede borrar el directorio equivocado |
| Lista de fuentes u objetos escrita a mano | −10 pts. Es justo el problema que resuelve la semana |
| `build/`, objetos o el binario comiteados | −10 pts |
| `make` sin argumentos compila en lugar de mostrar la ayuda | −5 pts |

---

## 📋 Checklist de entrega

- [ ] Los 6 labs con sus criterios de éxito comprobados en tu máquina
- [ ] Las 10 preguntas de Conocimiento respondidas por escrito
- [ ] `3-proyecto/starter/Makefile` sin ningún `TODO`
- [ ] `./scripts/verificar-semana.sh 07` con las 17 comprobaciones en verde
- [ ] `make clean` deja el árbol de trabajo limpio (`git status` sin `build/`)

---

[← Volver a la Semana 07](README.md)
