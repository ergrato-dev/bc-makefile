# Rúbrica de Evaluación — Semana 04

> Variables automáticas. Se evalúan tres evidencias por separado, y hace falta
> **70% en cada una**: un build que compila no compensa no saber por qué
> cambiar un header no recompilaba nada.

---

## 📊 Distribución de Evidencias

| Evidencia | Peso | Instrumento |
|---|:--:|---|
| 🧠 Conocimiento | 30% | Las 10 preguntas de esta rúbrica, respondidas por escrito |
| 💪 Desempeño | 40% | Los 6 labs, con sus criterios de éxito verificados en tu máquina |
| 📦 Producto | 30% | Build system C del proyecto: 60 pts de autograding + 40 pts de calidad |

**Mínimo 70% en cada evidencia.** No en el promedio.

| Calificación | Rango |
|---|:--:|
| Sobresaliente | 90-100% |
| Notable | 80-89% |
| Aprobado | 70-79% |
| No aprobado | < 70% |

---

## 🧠 Conocimiento (30%)

Diez preguntas, 3 puntos cada una. No se pide recordar qué símbolo es cuál: se
pide explicar por qué funcionan así.

| # | Pregunta |
|:--:|---|
| 1 | La regla de compilación usa `$<` y la de enlace usa `$^`. ¿Qué pasa exactamente si los intercambias, y por qué uno de los dos errores es mucho más difícil de detectar que el otro? |
| 2 | ¿Por qué `$@` vale cadena vacía en `SALIDA := app-$@.zip` a nivel de Makefile, y en qué momento le da Make un valor? |
| 3 | `$?` lista los prerrequisitos más nuevos que el target. ¿Por qué en un target `.PHONY` siempre contiene todos? |
| 4 | En la regla `build/%.o: src/%.c`, ¿cuánto vale `$*` para `build/net/http.o`, y por qué no conviene usar `$*` fuera de una regla de patrón? |
| 5 | ¿Qué ganas escribiendo `mkdir -p $(@D)` en la receta en vez de `mkdir -p build`? Da un caso concreto en el que la segunda versión se rompe. |
| 6 | Sin `-MMD`, cambias `calc.h` y ejecutas `make all`. ¿Qué hace Make, por qué, y qué riesgo real tiene el binario resultante? |
| 7 | ¿Qué problema resuelve `-MP`? Describe qué pasa al borrar un header de un proyecto que usa `-MMD` sin `-MP`. |
| 8 | ¿Por qué se escribe `-include $(DEPS)` con guion, y qué pasaría en el primer build si lo quitas? |
| 9 | Escribes `CC ?= gcc` y `make -p` muestra que `CC` vale `cc`. ¿Por qué `?=` no tuvo efecto? Usa `$(origin CC)` en tu respuesta. |
| 10 | Tocas `src/greet.c` y Make recompila `greet.o` y además vuelve a enlazar `build/app`. ¿Por qué el enlace es correcto y no un trabajo de más? |

<details>
<summary><strong>Respuestas</strong></summary>

**1.** Con `$^` en la compilación, `gcc -c` recibe todos los prerrequisitos;
si solo hay un `.c` no notas nada, y el día que añades un header como
prerrequisito gcc intenta compilarlo o falla con un mensaje raro. Con `$<` en el
enlace, el linker recibe solo el primer objeto y falla con `undefined
reference`: es ruidoso y se detecta al momento. El primer error es el difícil,
porque funciona hasta que cambia la lista de prerrequisitos.

**2.** Porque las variables automáticas solo existen mientras Make ejecuta una
receta concreta: es entonces cuando sabe qué target está construyendo. Una
asignación con `:=` se expande al leer el Makefile, antes de que haya ningún
target en curso, así que `$@` está vacía.

**3.** Un target phony no es un archivo, así que no tiene fecha. Make lo
considera siempre más viejo que cualquier prerrequisito, y por tanto todos son
"más nuevos". `$?` solo tiene sentido en targets que existen en disco.

**4.** `$*` vale `net/http`: es lo que coincidió con `%`. Fuera de una regla de
patrón Make intenta deducir el stem quitando un sufijo conocido, y el resultado
depende de la lista de sufijos; puede salir vacío o distinto de lo que esperas.

**5.** `$(@D)` se adapta al target: la misma regla crea `build/`, `build/net/`
o cualquier subdirectorio. Con `mkdir -p build` fija, en cuanto un fuente está
en `src/net/http.c` el objeto va a `build/net/http.o`, el directorio no existe
y gcc falla con `No such file or directory`.

**6.** No hace nada: `build/main.o` solo depende de `src/main.c`, y ese archivo
no cambió. El binario queda con objetos compilados contra la versión vieja del
header: si cambió una firma o el tamaño de un struct, el programa enlaza bien y
falla en ejecución, o calcula mal sin avisar.

**7.** Con `-MMD`, `build/main.d` dice que `main.o` depende de `calc.h`. Si
borras `calc.h`, Make lee esa regla, busca cómo crear `calc.h`, no lo encuentra
y para con `No rule to make target 'include/calc.h'`, aunque el `.c` ya no lo
incluya. `-MP` añade una regla vacía por header; así Make da el header por
resuelto, recompila y el `.d` nuevo ya no lo menciona.

**8.** En el primer build todavía no hay ningún `.d`: los crea la propia
compilación. `include` sin guion fallaría con `No such file or directory` antes
de compilar nada. El guion dice "si existe, cárgalo; si no, sigue".

**9.** `CC` ya tiene valor antes de leer el Makefile: es una variable implícita
de Make con valor `cc`. `$(origin CC)` devuelve `default`, y `?=` solo asigna si
la variable no está definida. Para fijar un valor por defecto que se pueda
sobrescribir desde la línea de comandos basta `CC := gcc`: lo que pasas como
`make CC=clang` tiene prioridad igualmente.

**10.** `build/app` depende de todos los objetos. `greet.o` acaba de cambiar,
así que es más nuevo que `build/app`, y el binario contiene el código viejo de
`greet`. Hay que enlazar otra vez; lo que no hace falta es recompilar `main.o`
y `calc.o`, y Make no lo hace.

</details>

---

## 💪 Desempeño (40%)

Diez puntos por lab. El Desempeño es la suma sobre 60, llevada a porcentaje.
Cada criterio de éxito se comprueba ejecutando el comando en tu máquina.

| Lab | Criterio | Puntos |
|---|---|:--:|
| [01 — `$@`](2-practicas/lab-01-target-nombre/README.md) | Los tres `reporte-*` imprimen su propio nombre y extensión; ninguna receta lleva el nombre escrito | 10 |
| [02 — `$<`](2-practicas/lab-02-primer-prerrequisito/README.md) | `compilar-*` usa solo el primer prerrequisito; `enlazar` muestra la diferencia con `$^`; comentario sobre el linker | 10 |
| [03 — `$^` y `$?`](2-practicas/lab-03-todos-prerrequisitos/README.md) | `$^` sin duplicados; tras `touch seccion-b.txt`, `$?` muestra solo ese archivo | 10 |
| [04 — `$*`](2-practicas/lab-04-stem-en-patrones/README.md) | Cada `.resultado` imprime su stem; modificar `beta.entrada` reconstruye solo `beta.resultado` | 10 |
| [05 — `$(@D)` y `$(@F)`](2-practicas/lab-05-rutas-dinamicas/README.md) | `make all` crea los tres archivos en sus subdirectorios; cambiar `DIST` mueve todo sin tocar recetas | 10 |
| [06 — Variables rotas](2-practicas/lab-06-variables-rotas/README.md) | Los cinco bugs corregidos, cada uno con su comentario `# FIX:` | 10 |

Dentro de cada lab: 10 puntos si se cumplen todos los criterios y explicas con
tus palabras qué hace cada variable automática que usaste; 8 si se cumplen
todos; 7 si falla uno; menos de 7 si fallan dos o más.

---

## 📦 Producto (30%)

### Verificable por el autograding — 60 puntos

Lo ejecuta `./scripts/verificar-semana.sh 04`. Es binario: pasa o no pasa.

| Comprobación | Puntos |
|---|:--:|
| `binario-funciona` — `make all` desde cero produce `build/app` y el binario imprime el resultado correcto | 8 |
| `objetos-en-build` — cada `src/*.c` produce su objeto en `build/` | 4 |
| `segunda-pasada-sin-trabajo` — una segunda ejecución de `make all` no rehace nada | 6 |
| `incremental-un-objeto` — tocar un `.c` recompila solo ese objeto | 6 |
| `deps-generadas` — el build genera un `.d` por objeto | 5 |
| `header-recompila` — tocar `include/calc.h` recompila exactamente los dos objetos que lo incluyen | 7 |
| `cc-desde-cli` — `CC` se puede cambiar desde la línea de comandos | 4 |
| `clean-borra-build` — `make clean` elimina `build/` por completo | 5 |
| `clean-con-guarda` — `make clean` se niega a borrar si `BUILD_DIR` está vacío | 6 |
| `shellflags-estrictas` — las recetas corren con `bash -eu -o pipefail` | 5 |
| `delete-on-error` — el Makefile declara `.DELETE_ON_ERROR` | 4 |
| **Total** | **60** |

### Calidad — 40 puntos

Lo que el autograding no puede ver.

| Criterio | Excelente | Suficiente | Puntos |
|---|---|---|:--:|
| **Cero nombres en recetas** | Ninguna receta contiene `main`, `greet`, `calc` ni rutas fijas: todo sale de variables automáticas | Uno o dos literales en mensajes `@echo` | 10 |
| **Variables automáticas comentadas** | Cada regla explica qué vale `$@`, `$<`, `$^` y `$(@D)` en ella | Comentarios genéricos | 8 |
| **Flags en variables** | `CFLAGS`, `LDFLAGS` y `-I$(INC_DIR)` en variables; ninguna flag fija en una receta | Alguna flag fija | 6 |
| **`.PHONY` completo** | Todos los targets que no producen archivo están declarados | Falta uno | 6 |
| **Orden y secciones** | Preámbulo, variables agrupadas con comentario de sección, reglas, utilidades | Variables dispersas | 6 |
| **`help` útil** | `make` sin argumentos lista todos los targets con descripción | Falta alguno | 4 |
| **Total** | | | **40** |

### Penalizaciones

| Situación | Deducción |
|---|:--:|
| `rm -rf` sobre una variable sin guarda de vacío | **−15 pts**. Un `BUILD_DIR` vacío por un typo no puede borrar el directorio equivocado |
| `build/`, objetos o el binario comiteados | −10 pts |
| Dependencias de headers escritas a mano en lugar de `-MMD -MP` | −10 pts. Se desactualizan en el primer refactor |
| `make` sin argumentos compila en lugar de mostrar la ayuda | −5 pts |

---

## 📋 Checklist de entrega

- [ ] Los 6 labs con sus criterios de éxito comprobados en tu máquina
- [ ] Las 10 preguntas de Conocimiento respondidas por escrito
- [ ] `3-proyecto/starter/Makefile` sin ningún `TODO`
- [ ] `./scripts/verificar-semana.sh 04` con las 11 comprobaciones en verde
- [ ] `make clean` deja el árbol de trabajo limpio (`git status` sin `build/`)

---

[← Volver a la Semana 04](README.md)
