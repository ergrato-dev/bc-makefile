# Rúbrica de Evaluación — Semana 03

> Shell en recetas y modo estricto. Se evalúan tres evidencias por separado, y
> hace falta **70% en cada una**: un Makefile que genera los reportes no
> compensa no saber por qué una tubería rota terminaba en verde.

---

## 📊 Distribución de Evidencias

| Evidencia | Peso | Instrumento |
|---|:--:|---|
| 🧠 Conocimiento | 30% | Las 10 preguntas de esta rúbrica, respondidas por escrito |
| 💪 Desempeño | 40% | Los 6 labs, con sus criterios de éxito verificados en tu máquina |
| 📦 Producto | 30% | Reportes de accesos del proyecto: 60 pts de autograding + 40 pts de calidad |

**Mínimo 70% en cada evidencia.** No en el promedio.

| Calificación | Rango |
|---|:--:|
| Sobresaliente | 90-100% |
| Notable | 80-89% |
| Aprobado | 70-79% |
| No aprobado | < 70% |

---

## 🧠 Conocimiento (30%)

Diez preguntas, 3 puntos cada una. No se pide recordar flags: se pide explicar
por qué el comportamiento es el que es.

| # | Pregunta |
|:--:|---|
| 1 | Una receta tiene `cd build` en una línea y `tar -czf r.tar.gz *.txt` en la siguiente. ¿Por qué falla, y por qué la corrección es `cd build && tar ...` y no `cd build; tar ...`? |
| 2 | `echo "$HOME"` en una receta imprime `OME`. ¿Qué ha pasado exactamente? ¿Cuándo escribirías `$(HOME)` y cuándo `$$HOME`, si las dos imprimen lo mismo? |
| 3 | Tu Makefile usa `[[ ]]` y funciona en tu Mac, pero en el runner de CI (Ubuntu) imprime `[[: not found`. ¿Por qué? ¿Por qué no lo arregla poner `SHELL=/bin/bash` en las variables de entorno del runner? |
| 4 | Escribes `.SHELLFLAGS := -eu -o pipefail` y todas las recetas fallan con `No such file or directory`. ¿Qué hace Make con `.SHELLFLAGS` para que esto ocurra? |
| 5 | Make ya se detiene cuando una línea de receta falla. ¿Para qué sirve entonces `-e`? Da un ejemplo de una línea que falla sin que Make se entere. |
| 6 | `awk ... data.csv \| sort > build/out.txt`: `awk` sale con 1 a mitad del archivo. ¿Por qué, sin `pipefail`, Make da el build por bueno? Y con `pipefail` pero sin `.DELETE_ON_ERROR`, ¿qué pasa en la **segunda** ejecución? |
| 7 | Con `pipefail`, `grep ',5[0-9][0-9]$$' log \| wc -l` rompe el build los días sin errores. ¿Por qué? ¿Por qué `\|\| test $$? -eq 1` es correcto y `\|\| true` no lo es? |
| 8 | Activas `.ONESHELL` para que el `cd` persista entre líneas. ¿Qué pasa con un `false` en mitad de la receta si no tienes `-e`, y por qué un `-` en la tercera línea ya no ignora solo esa línea? |
| 9 | ¿Por qué la guarda de `rm -rf` se escribe con `$(if ...)` y `$(error ...)` en vez de con `[ -n "$$BUILD_DIR" ] \|\| exit 1` en el shell? Da dos razones. |
| 10 | El prefijo `-`, `make -k` y `make -i` permiten seguir tras un error. ¿Cuál es aceptable en CI y por qué los otros dos anulan `.DELETE_ON_ERROR`? |

<details>
<summary><strong>Respuestas</strong></summary>

**1.** Make lanza un shell distinto por cada línea de receta. El `cd` cambia el
directorio de su shell, que termina al acabar la línea; el `tar` corre en un
shell nuevo, en el directorio del Makefile, donde no hay `*.txt`. `&&` mete los
dos comandos en el mismo shell **y** no ejecuta el `tar` si el `cd` falla; con
`;`, si `build/` no existe, el `tar` se ejecuta igualmente en el directorio
equivocado.

**2.** Make expande `$` antes de pasar la línea al shell. `$H` es la variable de
Make `H` (vacía), seguida del texto `OME`. `$(HOME)` lo expande Make con el
valor que tenía el entorno al arrancar; `$$HOME` llega al shell como `$HOME` y
lo expande el shell al ejecutar. La diferencia importa con variables que solo
existen en el shell: la de un `for` o una asignada en la misma línea. Esas solo
se pueden leer con `$$`.

**3.** Sin `SHELL` en el Makefile, Make usa `/bin/sh`. En macOS `/bin/sh` es
bash en modo POSIX y entiende `[[`; en Ubuntu es dash, que no lo tiene. Make
ignora a propósito la variable `SHELL` del entorno (es tu shell interactivo, no
el de las recetas), así que exportarla en el runner no cambia nada. Hay que
fijarla en el Makefile: `SHELL := bash`.

**4.** Make ejecuta cada línea como `$(SHELL) $(.SHELLFLAGS) "línea"`. El valor
por defecto de `.SHELLFLAGS` es `-c`; al reemplazarlo sin `-c`, bash recibe la
línea de receta como si fuera el nombre de un script y busca un archivo que se
llama, literalmente, `echo hola`.

**5.** Make mira el código de salida de la línea entera, que es el del último
comando. `test -f config.ini; echo "config OK"` sale con 0 aunque `test` falle.
Lo mismo con varias líneas unidas con `\` o con `.ONESHELL`. `-e` hace que el
shell pare en el primer comando que falla, sea el último o no.

**6.** El código de salida de una tubería es el de su última etapa. `sort`
termina bien, así que la línea sale con 0 y Make sigue. Con `pipefail` la línea
falla, pero la redirección ya creó `build/out.txt` con lo que `awk` llegó a
escribir. Ese archivo es más nuevo que `data.csv`: en la segunda ejecución Make
dice `Nothing to be done` y sale con 0. `.DELETE_ON_ERROR` borra el target
cuando su receta falla, y la segunda ejecución vuelve a intentarlo y vuelve a
fallar.

**7.** `grep` sale con 1 cuando no encuentra nada, y `pipefail` hace que la
tubería entera devuelva ese 1. `grep` reserva el 2 para errores reales: archivo
ilegible, expresión inválida. `|| test $$? -eq 1` convierte solo el 1 en éxito;
`|| true` convierte también el 2, y un log que no existe pasaría por un día sin
errores.

**8.** Con `.ONESHELL` toda la receta va a un único shell y Make solo ve el
código de salida del último comando: sin `-e`, el `false` no detiene nada y la
receta termina en verde. Además, Make solo interpreta los prefijos `@`, `-` y
`+` en la primera línea; en las demás los quita y no les da efecto. El `-` de
la tercera línea no ignora nada: con `-e`, ese fallo para la receta entera.

**9.** Primera: `$(if)` y `$(error)` se expanden cuando Make prepara la receta,
antes de ejecutar ninguna de sus líneas; la guarda de shell solo actúa cuando le
toca su turno. Segunda: también se expanden con `make -n`, así que la
previsualización ya avisa del problema; la guarda de shell no se ejecuta con
`-n`. Además, la de shell comprueba una variable de shell, no la de Make que usa
el `rm`.

**10.** `make -k`: sigue solo con los targets que no dependen del que falló, la
receta que falló sigue contando como error (y `.DELETE_ON_ERROR` borra su
target), y `make` termina con código 2. El prefijo `-` y `make -i` convierten el
error en "ignorado": para Make no hubo fallo, así que no borra nada, el archivo
a medias sobrevive y el código de salida es 0.

</details>

---

## 💪 Desempeño (40%)

Diez puntos por lab. El Desempeño es la suma sobre 60, llevada a porcentaje.
Cada criterio de éxito se comprueba ejecutando el comando en tu máquina.

| Lab | Criterio | Puntos |
|---|---|:--:|
| [01 — Cada línea, un shell](2-practicas/lab-01-cada-linea-un-shell/README.md) | `where`, `package`, `greet`, `home` y `count` corregidos; `oneshell.mk deploy` termina con error | 10 |
| [02 — bash frente a sh](2-practicas/lab-02-bash-vs-sh/README.md) | `mode ENV=prod`, `dirs` y `pipe` funcionan; `check-config` y `publish` sin `DEST_DIR` fallan; preámbulo comentado | 10 |
| [03 — pipefail](2-practicas/lab-03-pipefail/README.md) | `countries` falla con datos corruptos; `amounts COUNTRY=PT` pasa y `DATA=no-existe.csv` falla; `sigpipe-demo` y `top3` sin `head` | 10 |
| [04 — `.DELETE_ON_ERROR`](2-practicas/lab-04-delete-on-error/README.md) | El catálogo a medias se borra en cada fallo; `make -k` construye `stock.txt` y termina con código 2 | 10 |
| [05 — Guardas de rm -rf](2-practicas/lab-05-guardas-rm/README.md) | Las dos guardas paran con `-n`; `clean BUILD_DIR="mi build"` borra solo esa carpeta; `make -n reset` no borra nada | 10 |
| [06 — Shell roto](2-practicas/lab-06-shell-roto/README.md) | Los siete bugs corregidos, cada uno con su `# FIX:` en columna 0 | 10 |

Dentro de cada lab: 10 puntos si se cumplen todos los criterios y explicas con
tus palabras por qué fallaba cada receta; 8 si se cumplen todos; 7 si falla uno;
menos de 7 si fallan dos o más.

---

## 📦 Producto (30%)

### Verificable por el autograding — 60 puntos

Lo ejecuta `./scripts/verificar-semana.sh 03`. Es binario: pasa o no pasa.

| Comprobación | Puntos |
|---|:--:|
| `help-por-defecto` — `make` sin argumentos muestra la ayuda | 2 |
| `bash-como-shell` — las recetas se ejecutan con bash, no con `/bin/sh` | 4 |
| `shellflags-estrictas` — las recetas corren con `bash -eu -o pipefail` | 4 |
| `delete-on-error` — el Makefile declara `.DELETE_ON_ERROR` | 3 |
| `reporte-total` — `make report` genera `build/summary.txt` con el total del log | 5 |
| `status-por-codigo` — `build/status.txt` cuenta las peticiones por código HTTP | 4 |
| `errores-5xx` — `build/errors.csv` contiene exactamente las peticiones 5xx | 4 |
| `segunda-pasada-sin-trabajo` — una segunda ejecución de `make report` no rehace nada | 3 |
| `paquete-sin-prefijo` — `make package` empaqueta los reportes sin el prefijo `build/` | 4 |
| `log-sin-errores` — un log sin peticiones 5xx no rompe el build | 5 |
| `pipefail-detiene` — una línea corrupta en mitad de la tubería detiene el build | 5 |
| `parcial-borrado` — si la tubería falla, el reporte a medio escribir se borra | 5 |
| `dry-run-no-borra` — `make -n clean` no borra nada | 3 |
| `clean-con-guarda` — `make clean` se niega a borrar si `BUILD_DIR` está vacío | 4 |
| `clean-rechaza-fuera` — `make clean` se niega a borrar un `BUILD_DIR` fuera del proyecto | 3 |
| `clean-borra-build` — `make clean` elimina `build/` por completo | 2 |
| **Total** | **60** |

### Calidad — 40 puntos

Lo que el autograding no puede ver.

| Criterio | Excelente | Suficiente | Puntos |
|---|---|---|:--:|
| **Ningún error tragado** | Sin `-` en recetas, sin `\|\| true`, sin `2>/dev/null` que oculte un fallo; la única tolerancia es la de `grep` (`test $$? -eq 1`) | Un `2>/dev/null` innecesario | 10 |
| **Excepciones explicadas** | Un comentario junto a cada excepción a `pipefail` (`grep`, `awk 'NR <= 3'`) dice por qué existe | Comentarios genéricos | 8 |
| **Nada a mano** | Rutas y comandos salen de variables (`$(BUILD_DIR)`, `$(LOG)`, `$(AWK)`); los números del resumen salen de los datos | Alguna ruta fija en una receta | 8 |
| **`.PHONY` y `help`** | Todos los targets que no producen archivo están en `.PHONY`; `help` los lista todos | Falta uno | 6 |
| **Destructivo y visible** | Ningún `@` ni `+` delante de `rm`; `clean` muestra lo que borra | — | 4 |
| **Orden y legibilidad** | Preámbulo, variables, reportes, paquete, limpieza, ayuda; tuberías largas partidas con `\` | Secciones mezcladas | 4 |
| **Total** | | | **40** |

### Penalizaciones

| Situación | Deducción |
|---|:--:|
| `rm -rf` sobre una variable sin guarda de vacío | **−15 pts**. Un `BUILD_DIR` vacío por un typo no puede borrar el directorio equivocado |
| `+` delante de un comando destructivo | −10 pts. Convierte `make -n` en una ejecución real |
| `pipefail` desactivado (o `set +o pipefail` en una receta) para que un target pase | −10 pts |
| `build/` o `reportes.tar.gz` comiteados | −10 pts |
| `make` sin argumentos genera reportes en lugar de mostrar la ayuda | −5 pts |

---

## 📋 Checklist de entrega

- [ ] Los 6 labs con sus criterios de éxito comprobados en tu máquina
- [ ] Las 10 preguntas de Conocimiento respondidas por escrito
- [ ] `3-proyecto/starter/Makefile` sin ningún `TODO`
- [ ] `./scripts/verificar-semana.sh 03` con las 16 comprobaciones en verde
- [ ] `make clean` deja el árbol de trabajo limpio (`git status` sin `build/`)

---

[← Volver a la Semana 03](README.md)
