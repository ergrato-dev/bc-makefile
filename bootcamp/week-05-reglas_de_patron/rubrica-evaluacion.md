# Rúbrica de Evaluación — Semana 05

> Reglas de patrón. Se evalúan tres evidencias por separado, y hace falta
> **70% en cada una**: un build que compila no compensa no saber por qué Make
> dice `No rule to make target` cuando el problema es un `.c` que no existe.

---

## 📊 Distribución de Evidencias

| Evidencia | Peso | Instrumento |
|---|:--:|---|
| 🧠 Conocimiento | 30% | Las 10 preguntas de esta rúbrica, respondidas por escrito |
| 💪 Desempeño | 40% | Los 6 labs, con sus criterios de éxito verificados en tu máquina |
| 📦 Producto | 30% | Compilador genérico C del proyecto: 60 pts de autograding + 40 pts de calidad |

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
explicar por qué Make elige, o no elige, cada regla.

| # | Pregunta |
|:--:|---|
| 1 | Un Makefile con solo `%.o: %.c` no compila nada al ejecutar `make`. ¿Por qué una regla de patrón no se ejecuta por sí misma, y qué hace que se aplique a `main.o`? |
| 2 | Pides `make build/obj/nope.o` y no existe `src/nope.c`. Make responde `No rule to make target 'build/obj/nope.o'` en lugar de quejarse del `.c`. ¿Por qué? |
| 3 | Con la static pattern rule `$(TEST_OBJS): build/test/%.o: tests/%.c`, si falta el `.c` el error es `No rule to make target 'tests/x.c', needed by 'build/test/x.o'`. ¿Por qué el mensaje es más útil que el de la pregunta 2? |
| 4 | En `$(OBJ_DIR)/%.o: $(SRC_DIR)/%.c`, ¿cuánto vale el stem para `build/obj/net/http.o`, y por qué la misma regla sirve para subdirectorios sin tocarla? |
| 5 | En el lab 05, `debug.o: debug.c` con receta anula la regla de patrón. ¿Por qué `normal.o: config.h` **sin** receta no la anula? |
| 6 | Borras tu `%.o: %.c` y `make main.o` sigue compilando con `cc -c -o main.o main.c`. ¿De dónde sale esa regla, y por qué `make -r` la hace desaparecer? |
| 7 | Si un Makefile tiene `%.o: %.c` y `build/%.o: src/%.c`, y existen `build/a.c` y `src/a.c`, Make usa la segunda para `build/a.o` aunque esté escrita después. ¿Por qué? |
| 8 | `LIB_OBJS` excluye `main.o`, y tanto `build/app` como `build/test_runner` se enlazan con `LIB_OBJS`. ¿Qué pasaría si `main.o` estuviera en esa lista? |
| 9 | Tocas `include/math_ops.h` y `make all` recompila `main.o` y `math_ops.o`, pero no `test_runner.o`, aunque también incluye ese header. ¿Es un fallo? ¿Por qué no? |
| 10 | El runner de tests imprime `[FAIL]` pero `make test` termina en verde. ¿Por qué Make no se entera, y qué tiene que hacer el runner? |

<details>
<summary><strong>Respuestas</strong></summary>

**1.** Una regla de patrón es una plantilla: Make solo la consulta cuando
necesita construir un target concreto y no tiene receta para él. `make` sin
argumentos construye el primer target normal o `.DEFAULT_GOAL`, y si ninguno
pide un `.o`, la plantilla nunca se usa. Aplica a `main.o` cuando algo lo
necesita, por ejemplo `app: main.o`; entonces el `%` casa con `main` y Make
busca `main.c`.

**2.** Una regla de patrón solo es candidata si sus prerrequisitos existen o se
pueden construir. Sin `src/nope.c` la regla se descarta en silencio, Make se
queda sin candidatas y lo único que puede decir es que no tiene regla para el
target.

**3.** En una static pattern rule los targets están listados de forma
explícita: Make no busca si la regla aplica, sabe que aplica. Si falta el
prerrequisito, el error dice exactamente cuál falta y quién lo necesita.

**4.** El stem es `net/http`: es lo que casa con `%`, barras incluidas. El
prerrequisito pasa a ser `src/net/http.c`, y `mkdir -p $(@D)` crea
`build/obj/net/`. Lo que no lo encuentra solo es `$(wildcard $(SRC_DIR)/*.c)`,
que no baja a subdirectorios.

**5.** Make busca una regla implícita para todo target que no tenga receta.
`normal.o: config.h` solo añade un prerrequisito; el target sigue sin receta y
la regla de patrón se aplica igual, ahora con `config.h` como prerrequisito
extra. Una regla explícita con receta deja a Make sin nada que buscar.

**6.** Es una de las reglas implícitas de serie de GNU Make
(`$(CC) $(CFLAGS) $(CPPFLAGS) -c`), que se usa cuando ninguna regla tuya
aplica. `-r` (`--no-builtin-rules`) las desactiva; así un error en tu patrón
falla con `No rule to make target` en lugar de compilar a escondidas con otras
flags y en otro directorio.

**7.** Cuando varias reglas de patrón aplican, GNU Make (desde 3.82) prefiere
la de stem más corto, porque es la más específica. Con `build/%.o` el stem es
`a`; con `%.o` es `build/a`. El orden del archivo solo desempata reglas con el
mismo stem.

**8.** `test_runner.c` tiene su propio `main`. Si `main.o` entrara en
`LIB_OBJS`, el enlace del runner tendría dos definiciones de `main` y fallaría
con `multiple definition of 'main'`.

**9.** No es un fallo: `make all` solo trabaja sobre lo que necesita
`build/app`, y `test_runner.o` no forma parte de ese grafo. Su `.d` sí registra
el header, así que el próximo `make test` lo recompila.

**10.** Make solo mira el código de salida de cada comando. Un runner que
imprime `[FAIL]` y devuelve 0 es, para Make, un éxito. El runner tiene que
devolver un código distinto de 0 si algún test falla; el del proyecto cuenta
los fallos y sale con 1.

</details>

---

## 💪 Desempeño (40%)

Diez puntos por lab. El Desempeño es la suma sobre 60, llevada a porcentaje.
Cada criterio de éxito se comprueba ejecutando el comando en tu máquina.

| Lab | Criterio | Puntos |
|---|---|:--:|
| [01 — `%.o: %.c`](2-practicas/lab-01-patron-basico/README.md) | `make all` compila los tres módulos con una sola regla de patrón; `touch math.c` recompila un solo objeto; `make extra.o` sin `extra.c` falla con `No rule to make target` | 10 |
| [02 — Directorio de salida](2-practicas/lab-02-directorio-salida/README.md) | `make all` crea `build/main.o`, `build/utils.o` y `build/app`; `make build/net/ping.o` muestra `stem=net/ping`; `clean` con guarda | 10 |
| [03 — Múltiples patrones](2-practicas/lab-03-multiples-patrones/README.md) | `process` y `backup` con dos reglas de patrón; `delta.processed` usa la regla `.txt`; `make zeta.summary` encadena y borra el intermedio | 10 |
| [04 — Static pattern](2-practicas/lab-04-static-pattern/README.md) | Objetos en `build/lib/` (con `-fPIC`) y `build/main/`; `build/libops.a` enlazada; `make build/lib/main.o` falla | 10 |
| [05 — Prioridad](2-practicas/lab-05-prioridad/README.md) | Receta explícita para `debug.o`; `normal.o: config.h` sin receta; `test_%.o` gana por stem más corto; `MAKEFLAGS += -r` hace fallar `make main` | 10 |
| [06 — Patrones rotos](2-practicas/lab-06-patrones-rotos/README.md) | Los seis bugs corregidos con su causa por escrito; `make clean && make all-bugs` sin avisos ni archivo `bug-5` | 10 |

Dentro de cada lab: 10 puntos si se cumplen todos los criterios y explicas con
tus palabras qué regla eligió Make y por qué; 8 si se cumplen todos; 7 si falla
uno; menos de 7 si fallan dos o más.

---

## 📦 Producto (30%)

### Verificable por el autograding — 60 puntos

Lo ejecuta `./scripts/verificar-semana.sh 05`. Es binario: pasa o no pasa.

| Comprobación | Puntos |
|---|:--:|
| `binario-funciona` — `make all` desde cero produce `build/app` y el binario imprime el resultado correcto | 5 |
| `objetos-en-build-obj` — cada `src/*.c` produce su objeto en `build/obj/` | 4 |
| `modulo-nuevo-sin-tocar-makefile` — un `.c` nuevo en `src/` se compila sin tocar el Makefile | 5 |
| `segunda-pasada-sin-trabajo` — una segunda ejecución de `make all` no rehace nada | 4 |
| `incremental-un-objeto` — tocar un `.c` recompila solo ese objeto | 4 |
| `header-recompila` — tocar `include/math_ops.h` recompila exactamente los dos objetos de la app que lo incluyen | 5 |
| `test-pasa` — `make test` compila el runner y los tests pasan | 4 |
| `test-objeto-en-build-test` — el objeto del runner se genera en `build/test/` | 3 |
| `asm-por-modulo` — `make asm` genera un `.s` por cada `src/*.c` en `build/asm/` | 4 |
| `sin-reglas-implicitas` — las reglas implícitas de serie están desactivadas: un `.c` suelto no se compila solo | 4 |
| `cc-desde-cli` — `CC` se puede cambiar desde la línea de comandos | 3 |
| `clean-borra-build` — `make clean` elimina `build/` por completo | 3 |
| `clean-con-guarda` — `make clean` se niega a borrar si `BUILD` está vacía | 4 |
| `shellflags-estrictas` — las recetas corren con `bash -eu -o pipefail` | 4 |
| `delete-on-error` — el Makefile declara `.DELETE_ON_ERROR` | 4 |
| **Total** | **60** |

### Calidad — 40 puntos

Lo que el autograding no puede ver.

| Criterio | Excelente | Suficiente | Puntos |
|---|---|---|:--:|
| **Cero nombres de módulo en reglas** | Ninguna regla menciona `math_ops`, `string_ops` ni `io`; solo `main.c` aparece, en `APP_SRCS` | Un nombre de módulo en una lista de variables | 10 |
| **Static pattern solo donde aporta** | `TEST_OBJS` con static pattern rule; los módulos de `src/` con la regla de patrón genérica | Static pattern también para `src/` sin motivo | 8 |
| **Reglas explícitas solo para binarios** | `build/app` y `build/test_runner` son las únicas reglas explícitas, con `$^` y `$@` | Alguna ruta escrita a mano en una receta | 6 |
| **`.PHONY` completo** | `all`, `test`, `asm`, `clean` y `help` declarados | Falta uno | 6 |
| **Orden y secciones** | Preámbulo, compilador, directorios, fuentes, objetos, binarios, reglas, utilidades | Variables dispersas | 6 |
| **`help` útil** | `make` sin argumentos lista todos los targets con descripción (`target: ## …` y el `grep`/`awk` estándar) | Falta alguno | 4 |
| **Total** | | | **40** |

### Penalizaciones

| Situación | Deducción |
|---|:--:|
| `rm -rf` sobre una variable sin guarda de vacío | **−15 pts**. Un `BUILD` vacío por un typo no puede borrar el directorio equivocado |
| Una regla explícita por cada `.o` en lugar de la regla de patrón | −10 pts. Es justo lo que la semana elimina |
| `build/`, objetos o binarios comiteados | −10 pts |
| `make` sin argumentos compila en lugar de mostrar la ayuda | −5 pts |

---

## 📋 Checklist de entrega

- [ ] Los 6 labs con sus criterios de éxito comprobados en tu máquina
- [ ] Las 10 preguntas de Conocimiento respondidas por escrito
- [ ] `3-proyecto/starter/Makefile` sin ningún `TODO`
- [ ] `./scripts/verificar-semana.sh 05` con las 15 comprobaciones en verde
- [ ] `make clean` deja el árbol de trabajo limpio (`git status` sin `build/`)

---

[← Volver a la Semana 05](README.md)
