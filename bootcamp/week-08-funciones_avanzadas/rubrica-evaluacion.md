# Rúbrica de Evaluación — Semana 08

> Funciones avanzadas. Se evalúan tres evidencias por separado, y hace falta
> **70% en cada una**: un `$(eval)` que funciona por casualidad no compensa no
> saber cuántas veces se expande cada `$`.

---

## 📊 Distribución de Evidencias

| Evidencia | Peso | Instrumento |
|---|:--:|---|
| 🧠 Conocimiento | 30% | Las 10 preguntas de esta rúbrica, respondidas por escrito |
| 💪 Desempeño | 40% | Los 6 labs, con sus criterios de éxito verificados en tu máquina |
| 📦 Producto | 30% | Orquestador de microservicios: 60 pts de autograding + 40 pts de calidad |

**Mínimo 70% en cada evidencia.** No en el promedio.

| Calificación | Rango |
|---|:--:|
| Sobresaliente | 90-100% |
| Notable | 80-89% |
| Aprobado | 70-79% |
| No aprobado | < 70% |

---

## 🧠 Conocimiento (30%)

Diez preguntas, 3 puntos cada una. No se pide recordar la sintaxis: se pide
explicar por qué Make se comporta así.

| # | Pregunta |
|:--:|---|
| 1 | Dentro de un `define` que se usa con `$(eval $(call ...))`, la receta `@echo $<` imprime vacío y `@echo $$<` imprime el prerrequisito. ¿Por qué? |
| 2 | Escribes `$(call SERVICE_RULE,api)` sin `$(eval)` a nivel de Makefile y Make falla con `target pattern contains no '%'`. ¿Por qué no basta con `$(call)`? |
| 3 | En la plantilla, `$(CC) $(CFLAGS)` va con un solo `$`. Si `CFLAGS` se define *después* de la línea del `$(foreach ... $(eval ...))`, las recetas compilan sin flags. ¿Por qué? |
| 4 | `$(call SERVICE_RULE, api)` (con espacio tras la coma) genera la ruta `services/ api/main.c`. ¿Por qué, si en otras funciones el espacio no importa? |
| 5 | `X := $(shell false)` no detiene el build: `X` queda vacía y Make sigue. ¿Por qué, y qué protege el `\|\| echo sin-git` de `GIT_HASH`? |
| 6 | ¿Por qué `BUILD_DATE` se define con `:=` y no con `=`? Describe qué verías en el manifest si usaras `=`. |
| 7 | `$(shell printf 'a\nb\n')` devuelve `a b`. ¿Qué hace `$(shell)` con los saltos de línea, y qué consecuencia tiene si quieres leer un archivo línea por línea? |
| 8 | En `@$(foreach svc,$(SERVICES),echo $(svc);)`, ¿por qué hace falta el `;` final dentro del `foreach`? ¿Qué imprime sin él? |
| 9 | La lista de servicios sale de `find ... \| sort`. ¿Por qué el `sort`, si `find` ya devuelve los directorios? |
| 10 | La plantilla declara `.PHONY: $(1)` para cada servicio. ¿Qué pasa con `make api` si alguien crea un archivo llamado `api` en la raíz del proyecto y la plantilla no lo declara? |

<details>
<summary><strong>Respuestas</strong></summary>

**1.** El texto se expande dos veces. `$(call)` hace la primera pasada: `$<`
no tiene valor fuera de una receta en ejecución y se convierte en cadena vacía
antes de que `$(eval)` vea nada. `$$<` sobrevive a esa pasada como `$<`, y
`$(eval)` lo deja en la receta, donde Make lo resuelve al ejecutar. Regla: lo
que debe resolverse al ejecutar lleva `$$`; lo que debe resolverse al generar
(como `$(1)`) lleva un solo `$`.

**2.** El resultado de expandir una función a nivel de Makefile se parsea
como una sola línea lógica: los saltos de línea del `define` no separan
reglas. Make ve algo como `.PHONY: api api: build/api build/api: ...` en una
sola línea, con varios `:`, y lo interpreta como una regla de patrón estático
sin `%`. `$(eval)` es lo que parsea el texto como Makefile real, con sus
líneas y sus tabuladores.

**3.** Porque `$(call)` expande `$(CFLAGS)` en el momento de la llamada, y en
ese momento la variable todavía no existe. La receta generada ya lleva el
texto vacío; definir `CFLAGS` después no la cambia. Si se escribe `$$(CFLAGS)`,
la referencia llega intacta a la receta y se resuelve al ejecutar, con el
valor final. Por eso las variables van antes del `foreach` que instancia las
plantillas.

**4.** `$(call)` pasa cada argumento tal cual, con sus espacios: `$(1)` vale
` api`. En una lista de palabras un espacio de más es inofensivo, pero dentro
de una ruta parte la palabra en dos. Los argumentos de `call` se escriben
pegados a la coma.

**5.** `$(shell)` captura la salida del comando, no su código de salida: un
fallo devuelve cadena vacía y Make lo registra solo en `.SHELLSTATUS`. Sin
el `|| echo sin-git`, fuera de un repositorio `GIT_HASH` quedaría vacía y el
manifest tendría `GIT_HASH :=` sin avisar. El respaldo hace visible el caso.

**6.** Con `=` la variable es recursiva y `$(shell date ...)` se ejecuta en
cada referencia. Si el build tarda, el `info`, el nombre del artefacto y el
manifest pueden llevar horas distintas en el mismo build: dos referencias
seguidas a `$(shell date +%N)` ya dan valores diferentes. Con `:=` se ejecuta
una vez, al leer el Makefile.

**7.** Quita el salto de línea final y convierte los demás en espacios. La
salida se vuelve una lista de palabras: sirve para nombres sin espacios, pero
cualquier línea con espacios queda mezclada con las demás. Para trabajar
línea a línea se hace en la receta (con `while read`) o con `$(file <...)`.

**8.** `foreach` une los resultados con espacios en una sola línea de shell.
Sin el `;` sale `echo api echo monitor echo worker`, un único `echo` que
imprime `api echo monitor echo worker`. Con el `;` son tres comandos
separados.

**9.** `find` devuelve las entradas en el orden en que el sistema de archivos
las guarda, que no es alfabético ni igual entre máquinas. Sin `sort`, el
orden de compilación, la salida de `info` y el `BUILT_SERVICES` del manifest
cambiarían de un equipo a otro, y un manifest que cambia sin cambios reales
genera ruido en cada diff.

**10.** Sin `.PHONY`, `api` es un target de archivo. Si existe un archivo
`api` más nuevo que `build/api`, Make lo da por actualizado y responde
`'api' is up to date` sin compilar nada. Con `.PHONY: api` Make no busca
ningún archivo con ese nombre y siempre evalúa sus prerrequisitos.

</details>

---

## 💪 Desempeño (40%)

Diez puntos por lab. El Desempeño es la suma sobre 60, llevada a porcentaje.
Cada criterio de éxito se comprueba ejecutando el comando en tu máquina.

| Lab | Criterio | Puntos |
|---|---|:--:|
| [01 — `foreach`](2-practicas/lab-01-foreach/README.md) | `make demo` imprime las 9 combinaciones de `DEPLOY_MATRIX`; `make dirs` crea los tres directorios; `make report` lista los 3 entornos | 10 |
| [02 — `call`](2-practicas/lab-02-call/README.md) | `make demo` muestra URL y ruta de build por servicio; `make check-services` imprime 3 `OK`; la lógica está en bloques `define` sin repetición | 10 |
| [03 — `eval`](2-practicas/lab-03-eval/README.md) | `make all` ejecuta las 4 suites y `reports/` contiene los 4 reportes; `make demo` lista los `run-*` generados | 10 |
| [04 — `shell`](2-practicas/lab-04-shell/README.md) | `make info` muestra hash, fecha, OS, CPUs y versión de Make sin ningún `UNKNOWN`; `make version` genera `build/version.txt` | 10 |
| [05 — Combinadas](2-practicas/lab-05-combinadas/README.md) | `make info` descubre los 3 plugins; `make all` compila los tres objetos con reglas generadas | 10 |
| [06 — Funciones rotas](2-practicas/lab-06-funciones-rotas/README.md) | Los 4 bugs corregidos; `make demo` produce exactamente la salida esperada con un hash corto no vacío | 10 |

Dentro de cada lab: 10 puntos si se cumplen todos los criterios y explicas con
tus palabras cuándo se expande cada función que usaste; 8 si se cumplen todos;
7 si falla uno; menos de 7 si fallan dos o más.

---

## 📦 Producto (30%)

### Verificable por el autograding — 60 puntos

Lo ejecuta `./scripts/verificar-semana.sh 08`. Es binario: pasa o no pasa.

| Comprobación | Puntos |
|---|:--:|
| `servicios-descubiertos` — `make info` lista los servicios de `services/`, ordenados | 5 |
| `binarios-foreach` — `make info` muestra un binario en `build/` por servicio | 4 |
| `metadato-os` — `make info` muestra el sistema operativo obtenido con `$(shell)` | 3 |
| `metadato-git` — `make info` muestra el hash corto de git o `sin-git` | 3 |
| `all-compila-todos` — `make all` desde cero compila los tres servicios y cada binario arranca | 7 |
| `target-por-servicio` — `make api` compila solo `build/api`, con un target generado por `$(eval)` | 5 |
| `servicio-nuevo-sin-editar` — un directorio nuevo en `services/` se compila sin editar el Makefile | 7 |
| `segunda-pasada-sin-trabajo` — una segunda ejecución de `make all` no recompila ningún servicio | 4 |
| `manifest-servicios` — `make generate` escribe `BUILT_SERVICES` con los tres servicios | 4 |
| `manifest-incluible` — `build/manifest.mk` es un Makefile válido que define `OS_NAME` | 4 |
| `clean-borra-build` — `make clean` elimina `build/` por completo | 4 |
| `clean-con-guarda` — `make clean` se niega a borrar si `BUILD` está vacío | 5 |
| `shellflags-estrictas` — las recetas corren con `bash -eu -o pipefail` | 3 |
| `delete-on-error` — el Makefile declara `.DELETE_ON_ERROR` | 2 |
| **Total** | **60** |

### Calidad — 40 puntos

Lo que el autograding no puede ver.

| Criterio | Excelente | Suficiente | Puntos |
|---|---|---|:--:|
| **Una sola plantilla** | Toda la lógica por servicio vive en `SERVICE_RULE`; ninguna regla escrita a mano para un servicio concreto | Algún target auxiliar repetido | 10 |
| **`$` frente a `$$` justificado** | Un comentario en la plantilla explica qué se expande en `call` y qué en la receta | Uso correcto sin explicar | 8 |
| **`$(shell)` con respaldo** | Cada `$(shell)` que puede fallar tiene un valor de respaldo visible y se evalúa con `:=` | Alguno sin respaldo | 6 |
| **`.PHONY` completo** | Todos los targets que no producen archivo, incluidos los generados, están declarados | Falta uno | 6 |
| **`help` útil** | `make` sin argumentos lista todos los targets con descripción | Falta alguno | 5 |
| **Orden y secciones** | Preámbulo, descubrimiento, metadatos, plantillas, instanciación, targets | Variables dispersas | 5 |
| **Total** | | | **40** |

### Penalizaciones

| Situación | Deducción |
|---|:--:|
| `rm -rf` sobre una variable sin guarda de vacío | **−15 pts**. Un `BUILD` vacío por un typo no puede borrar el directorio equivocado |
| Servicios listados a mano en el Makefile | −10 pts. Es justo el problema que resuelve el proyecto |
| `build/`, binarios o `manifest.mk` comiteados | −10 pts |
| `make` sin argumentos compila en lugar de mostrar la ayuda | −5 pts |

---

## 📋 Checklist de entrega

- [ ] Los 6 labs con sus criterios de éxito comprobados en tu máquina
- [ ] Las 10 preguntas de Conocimiento respondidas por escrito
- [ ] `3-proyecto/starter/Makefile` sin ningún `TODO`
- [ ] `./scripts/verificar-semana.sh 08` con las 14 comprobaciones en verde
- [ ] `make clean` deja el árbol de trabajo limpio (`git status` sin `build/`)

---

[← Volver a la Semana 08](README.md)
