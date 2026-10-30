# Rúbrica de Evaluación — Semana 09

> Condicionales, include y depuración. Se evalúan tres evidencias por
> separado, y hace falta **70% en cada una**: una librería de módulos que
> funciona desde un directorio no compensa no saber por qué falla desde otro.

---

## 📊 Distribución de Evidencias

| Evidencia | Peso | Instrumento |
|---|:--:|---|
| 🧠 Conocimiento | 30% | Las 10 preguntas de esta rúbrica, respondidas por escrito |
| 💪 Desempeño | 40% | Los 5 labs publicados, con sus criterios de éxito verificados en tu máquina |
| 📦 Producto | 30% | Librería de módulos Make: 60 pts de autograding + 40 pts de calidad |

**Mínimo 70% en cada evidencia.** No en el promedio.

| Calificación | Rango |
|---|:--:|
| Sobresaliente | 90-100% |
| Notable | 80-89% |
| Aprobado | 70-79% |
| No aprobado | < 70% |

---

## 🧠 Conocimiento (30%)

Diez preguntas, 3 puntos cada una. No se pide recordar directivas: se pide
explicar por qué Make se comporta así.

| # | Pregunta |
|:--:|---|
| 1 | Declaras `deploy-prod: ENV := production` y dentro de un `ifeq ($(ENV), production)` defines la receta de `deploy-prod`. Make ejecuta la rama `else`, aunque la receta imprime `ENV=production`. ¿Por qué? |
| 2 | `make CI= info` no entra en el bloque `ifdef CI`. ¿Por qué, si `CI` aparece en la línea de comandos? |
| 3 | Escribes `ENV := production # entorno` y `ifeq ($(ENV),production)` nunca es verdadero. ¿Por qué? |
| 4 | `api/Makefile` hace `include ../shared-mk/build.mk`. `make -C api build` funciona y `make -f api/Makefile build` desde la raíz no. ¿Por qué? |
| 5 | Con `include mk/config.mk` y el archivo ausente, Make imprime los `$(info)` del resto del Makefile antes de fallar. ¿Por qué no falla en la línea del `include`, y cuándo usarías `-include`? |
| 6 | Ejecutas `make -n debug-vars` y los `$(info ...)` de la receta se imprimen igualmente. ¿Por qué `-n` no los suprime? |
| 7 | Mueves la validación de `debug.mk` a nivel de archivo: `$(if $(VERSION),,$(error VERSION vacía))`. ¿Por qué ahora `make help` también falla con `VERSION=`? |
| 8 | El Makefile raíz define `ENV := ci` y llama a `$(MAKE) -C api deploy` sin pasar nada. El módulo despliega en `development`. ¿Por qué, si `make ENV=staging deploy` sí llega a los módulos? |
| 9 | Un typo `$(VERSON)` en `build.mk` imprime `Compilando api` sin versión y sin ningún error. ¿Por qué Make lo permite, y qué flag lo delata? |
| 10 | El Makefile raíz ya tiene `.SHELLFLAGS := -eu -o pipefail -c`, así que un `for m in $(MODULES); do $(MAKE) -C $$m; done` se detiene en el primer fallo. ¿Por qué se sigue prefiriendo un target por módulo? |

<details>
<summary><strong>Respuestas</strong></summary>

**1.** Los condicionales se evalúan al leer el Makefile, una sola vez y con el
valor global de la variable. Las variables específicas de target solo existen
cuando Make ejecuta ese target, mucho después. El `ifeq` vio
`ENV=development`, eligió la rama `else`, y al ejecutar la receta `$(ENV)` ya
valía `production`. Para decidir por target se usa `$(if ...)` dentro de la
receta, no `ifeq`.

**2.** `ifdef` no pregunta si la variable existe, sino si su valor (sin
expandir) está vacío. `CI=` define `CI` con valor vacío, y para `ifdef` eso es
falso. Si necesitas distinguir "vacía" de "no definida" usas
`$(origin CI)`, que devuelve `undefined` solo en el segundo caso.

**3.** Todo lo que hay entre el `=` y el `#` forma parte del valor, incluido
el espacio final: `ENV` vale `production ` y no es igual a `production`. Los
comentarios en la línea de una asignación arrastran ese espacio. Se escriben
en la línea anterior, o se compara con `$(strip $(ENV))`.

**4.** Las rutas de `include` se resuelven desde el directorio de trabajo de
Make, no desde el directorio del Makefile que las contiene. Con `-C api` Make
hace `cd api` primero y `../shared-mk/` existe; con `-f` sigue en la raíz y
`../shared-mk/` apunta fuera del proyecto. Por eso el Makefile raíz entra en
cada módulo con `-C`. Si un módulo debe funcionar desde cualquier sitio,
calcula su propio directorio con `$(dir $(lastword $(MAKEFILE_LIST)))`.

**5.** Make lee el Makefile entero antes de quejarse: un archivo incluido que
falta puede tener una regla que lo genere, y Make intenta crearlo antes de
rendirse. Solo cuando no lo consigue falla con `No rule to make target`.
`-include` es para archivos opcionales cuya ausencia es normal: un
`local.mk` con overrides personales o los `.d` del primer build.

**6.** `-n` evita ejecutar comandos de shell, pero para saber qué comandos
mostraría Make tiene que expandir la receta, y expandirla es lo que ejecuta
las funciones `$(info)`. Por eso `$(info)` sirve para depurar incluso en un
dry-run, y por eso nunca conviene poner efectos secundarios en funciones de
una receta.

**7.** Una función a nivel de archivo se ejecuta al leer el Makefile, sea
cual sea el target pedido. `$(error)` detiene Make antes de llegar a `help`.
Dentro de la receta de `validate`, en cambio, solo se evalúa cuando se pide
ese target.

**8.** Las variables de la línea de comandos viajan a los sub-makes dentro de
`MAKEFLAGS`; las definidas en un Makefile no viajan salvo que se exporten o se
pasen como argumento. El módulo no ve `ENV := ci` y aplica su propio
`ENV ?= development`. Por eso la regla de módulo pasa `ENV=$(ENV)`
explícitamente.

**9.** Para Make una variable sin definir es una variable vacía: no es un
error, es su comportamiento de serie. `--warn-undefined-variables` imprime
`warning: undefined variable 'VERSON'` en cada referencia; se pasa a los
sub-makes a través de `MAKEFLAGS`, así que basta con usarlo en el Makefile
raíz.

**10.** Con `-e` el bucle sí para, pero sigue siendo un único comando de
shell. Make no puede repartir los módulos entre trabajos con `-j`, `make -k`
no puede seguir con el resto de módulos tras un fallo, y el mensaje de error
señala una línea del bucle en lugar del módulo concreto (`api/build`). Con un
target por módulo Make conoce cada pieza del grafo y puede tratarla por
separado.

</details>

---

## 💪 Desempeño (40%)

Diez puntos por lab. El Desempeño es la suma sobre 50, llevada a porcentaje.
Cada criterio de éxito se comprueba ejecutando el comando en tu máquina.

> El lab 05 está pendiente de publicación. Cuando exista, el Desempeño pasará a
> sumarse sobre 60.

| Lab | Criterio | Puntos |
|---|---|:--:|
| [01 — Condicionales](2-practicas/lab-01-condicionales/README.md) | `make info` muestra los `BUILD_FLAGS` correctos para development, staging y production; `CI=true` activa el modo CI; `make deploy ENV=development` falla con su mensaje | 10 |
| [02 — Include modular](2-practicas/lab-02-include-modular/README.md) | `build`, `test` y `deploy` salen de sus módulos `.mk`; `make help` lista los targets de todos; `make info` funciona con y sin `mk/local.mk` | 10 |
| [03 — Depuración](2-practicas/lab-03-depuracion/README.md) | `debug-vars` imprime las variables con `$(info)`; `validate APP_NAME=` falla con mensaje claro; `make --debug=b build` muestra la decisión de reconstrucción | 10 |
| [04 — Scope de variables](2-practicas/lab-04-scope-variables/README.md) | El sub-make recibe `ENV` y `SHARED_VAR`, no hereda `SECRET_VAR` y respeta `VERSION=9.9.9` de la línea de comandos | 10 |
| [06 — Makefile roto](2-practicas/lab-06-makefile-roto/README.md) | Los 6 errores corregidos; `make ci` imprime `CI completo` sin aviso de dependencia circular; `make lint` imprime `Lint OK` | 10 |

Dentro de cada lab: 10 puntos si se cumplen todos los criterios y explicas con
tus palabras en qué fase (lectura o ejecución) actúa cada directiva que
usaste; 8 si se cumplen todos; 7 si falla uno; menos de 7 si fallan dos o más.

---

## 📦 Producto (30%)

### Verificable por el autograding — 60 puntos

Lo ejecuta `./scripts/verificar-semana.sh 09`. Es binario: pasa o no pasa.

| Comprobación | Puntos |
|---|:--:|
| `all-construye-tres` — `make all` desde la raíz construye api, worker y frontend | 6 |
| `test-tres` — `make test` desde la raíz ejecuta los tests de los tres módulos | 4 |
| `fallo-propaga` — si un módulo falla, `make all` desde la raíz sale con error | 5 |
| `env-llega-a-modulos` — `make ENV=staging deploy` despliega los tres módulos en staging | 5 |
| `deploy-production-confirmado` — deploy en production toma la rama `ifeq` que marca `CONFIRMADO` | 5 |
| `deploy-development-sin-confirmar` — deploy sin `ENV` usa development y no marca `CONFIRMADO` | 4 |
| `rollback-en-tres` — los tres módulos importan `deploy.mk` y ofrecen `rollback` | 4 |
| `debug-vars-app` — `make -C worker debug-vars` muestra `APP_NAME` con `$(info)` | 3 |
| `debug-vars-makefile-list` — `debug-vars` muestra los cuatro módulos en `MAKEFILE_LIST` | 3 |
| `validate-ok` — `make -C frontend validate` pasa con las variables definidas | 3 |
| `validate-version-vacia` — `validate` falla con mensaje claro si `VERSION` está vacía | 5 |
| `sin-variables-indefinidas` — `make all` no usa variables indefinidas | 4 |
| `shellflags-estrictas` — el Makefile raíz usa `bash -eu -o pipefail` | 3 |
| `delete-on-error` — el Makefile raíz declara `.DELETE_ON_ERROR` | 2 |
| `modulos-estrictos` — los Makefiles de api, worker y frontend también usan `bash -eu -o pipefail` | 4 |
| **Total** | **60** |

### Calidad — 40 puntos

Lo que el autograding no puede ver.

| Criterio | Excelente | Suficiente | Puntos |
|---|---|---|:--:|
| **Módulos reutilizables** | Cada `.mk` documenta en su cabecera las variables que necesita y no nombra ningún proyecto concreto | Alguna dependencia implícita sin documentar | 10 |
| **Makefiles de módulo mínimos** | `api`, `worker` y `frontend` solo definen variables e incluyen; cero lógica duplicada | Algún target repetido | 8 |
| **Recursión como targets** | Un target phony por módulo y meta; ningún bucle `for` con `$(MAKE)` | Targets por módulo, pero sin `.PHONY` | 6 |
| **`.PHONY` completo** | Todos los targets que no producen archivo, en raíz y en cada `.mk` | Falta uno | 6 |
| **Diagnóstico útil** | Los mensajes de `validate` nombran la variable y cómo arreglarla; `debug-vars` basta para depurar un módulo | Mensajes genéricos | 5 |
| **`help` útil** | `make` sin argumentos lista todos los targets con descripción, en la raíz y en cada módulo | Falta alguno | 5 |
| **Total** | | | **40** |

### Penalizaciones

| Situación | Deducción |
|---|:--:|
| `rm -rf` sobre una variable sin guarda de vacío | **−15 pts**. Un directorio vacío por un typo no puede borrar el árbol equivocado |
| Recursión con `for ... do $(MAKE) ...; done` | −10 pts |
| `export` sin argumentos | −10 pts. Envía todas las variables, secretos incluidos, a cada sub-make y receta |
| Lógica de build copiada en los Makefiles de módulo en lugar de incluida | −10 pts. Es justo el problema que resuelve el proyecto |
| `make` sin argumentos ejecuta algo en lugar de mostrar la ayuda | −5 pts |

---

## 📋 Checklist de entrega

- [ ] Los 5 labs publicados con sus criterios de éxito comprobados en tu máquina
- [ ] Las 10 preguntas de Conocimiento respondidas por escrito
- [ ] Ningún `TODO` en `3-proyecto/starter/` (Makefile raíz, módulos y `shared-mk/`)
- [ ] `./scripts/verificar-semana.sh 09` con las 15 comprobaciones en verde
- [ ] `git status` limpio tras ejecutar el autograding

---

[← Volver a la Semana 09](README.md)
