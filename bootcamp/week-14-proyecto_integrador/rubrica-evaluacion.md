# Rúbrica de Evaluación — Semana 14

> Proyecto integrador. Se evalúan tres evidencias por separado, y hace falta
> **70% en cada una**: un `make ci` en verde no compensa no saber por qué un
> bucle `for` lo dejaba en verde con un servicio roto.

---

## 📊 Distribución de Evidencias

| Evidencia | Peso | Instrumento |
|---|:--:|---|
| 🧠 Conocimiento | 30% | Las 10 preguntas de esta rúbrica, respondidas por escrito |
| 💪 Desempeño | 40% | Los 6 labs, con sus criterios de éxito verificados en tu máquina |
| 📦 Producto | 30% | Build system multi-servicio: 60 pts de autograding + 40 pts de calidad |

**Mínimo 70% en cada evidencia.** No en el promedio.

| Calificación | Rango |
|---|:--:|
| Sobresaliente | 90-100% |
| Notable | 80-89% |
| Aprobado | 70-79% |
| No aprobado | < 70% |

---

## 🧠 Conocimiento (30%)

Diez preguntas, 3 puntos cada una. No hay conceptos nuevos esta semana: se pide
explicar por qué las piezas encajan así.

| # | Pregunta |
|:--:|---|
| 1 | Con `ci: ; for s in backend frontend infra; do $(MAKE) -C $$s ci; done` y el shell por defecto, `make ci FAIL=backend` sale con 0. ¿Por qué? |
| 2 | Con `.SHELLFLAGS := -eu -o pipefail -c` ese bucle sí se detiene en el primer fallo. Da dos razones por las que un target phony por servicio (`backend/ci`) sigue siendo mejor. |
| 3 | La receta recursiva usa `$(MAKE)` y no `make`. ¿Qué se rompe con `make -j3 all` si escribes `make`, y qué pasa con `make -n all`? |
| 4 | `make ci FAIL=backend` en la raíz llega a `backend/Makefile` aunque la receta solo pasa `ENV` y `CONFIRM`. ¿Por qué? ¿Llegaría una variable definida con `:=` dentro del Makefile raíz? |
| 5 | En `shared-mk/build.mk`, `VERSION ?= 1.0.0`. `service-b` define `VERSION := 2.3.1` antes del `include`. ¿Qué imprime `make build` si el módulo usara `:=`, y por qué el orden del `include` importa? |
| 6 | El `$(error)` de producción vive dentro de la receta de `deploy`, bajo `ifeq`, y no a nivel de módulo. ¿Qué dejaría de funcionar si lo movieras fuera de la receta? |
| 7 | `push` exige `CI=true`. Si cualquiera puede escribir `make push CI=true`, ¿qué protege exactamente esa guarda y dónde está el control real? |
| 8 | ¿Por qué `.stamps/deps` es un archivo que depende de `pyproject.toml uv.lock` y no un target phony `deps`, y por qué `.stamps/` va como prerrequisito *order-only* (`\| .stamps/`)? |
| 9 | `ci: lint test build`. En modo serie el orden se respeta; ¿y con `make -j4 ci`? ¿Cómo garantizas que `build` nunca empieza antes de que `test` termine? |
| 10 | Con `make -j3 all` la salida de los tres servicios sale mezclada línea a línea. ¿Por qué, y qué opción de Make lo resuelve sin perder el paralelismo? |

<details>
<summary><strong>Respuestas</strong></summary>

**1.** La receta es un único comando de shell; su código de salida es el del
último comando ejecutado, es decir, el `$(MAKE)` de `infra`. Sin `-e`, el shell
no se detiene cuando falla `backend`: imprime el error, sigue con `frontend` e
`infra`, y si `infra` pasa, Make recibe 0 y `ci` queda en verde.

**2.** Con targets por servicio Make conoce el grafo: `make -j3 ci` los ejecuta
en paralelo y `make -k ci` sigue con los demás servicios y aun así sale con
error. Además cada uno es invocable por separado (`make infra/test`) y aparece
en `make -n`. El bucle es una caja negra para Make: ni paraleliza, ni `-k`
funciona por servicio, ni se puede pedir uno solo.

**3.** `$(MAKE)` marca la línea como recursiva: el hijo recibe el jobserver y
reparte los `-j3` con el padre. Con `make` a secas el hijo no tiene acceso al
jobserver, avisa con `jobserver unavailable: using -j1` y construye en serie.
Con `-n`, las líneas con `$(MAKE)` se ejecutan igualmente para que el hijo
muestre su plan; con `make`, el padre solo imprime la línea y no ves qué haría
cada servicio. Además `$(MAKE)` es el mismo binario (`gmake` en macOS).

**4.** Las variables de la línea de comandos viajan en `MAKEFLAGS` y todos los
sub-makes las reciben como si se las hubieras pasado a ellos. Una variable
definida dentro del Makefile raíz no viaja: el hijo no la ve salvo que la
exportes o la pases explícitamente en la receta, como se hace con `ENV` y
`CONFIRM` para no depender de cómo llegó el valor a la raíz.

**5.** Con `:=` en el módulo, la línea del `include` reasignaría `VERSION` a
`1.0.0` después de que `service-b` la fijara: imprimiría `Build 1.0.0`. El
`include` inserta el texto en ese punto, así que lo que viene después pisa lo
de antes. `?=` solo asigna si la variable no existe: el servicio define y el
módulo aporta el valor por defecto.

**6.** Fuera de la receta, el `$(error)` se evaluaría al leer el Makefile: con
`ENV=production` sin `CONFIRM`, fallarían también `make help`, `make test` o
`make clean`, que no despliegan nada. Dentro de la receta solo se expande
cuando Make va a ejecutar `deploy`.

**7.** Protege de un accidente: alguien que escribe `make push` en su portátil
por costumbre. No es control de acceso, porque es una variable que cualquiera
fija. El control real es que solo el runner de CI tenga credenciales para el
registry y que la rama esté protegida.

**8.** Un phony está siempre desactualizado: `uv sync` correría en cada `make
test`. El stamp tiene fecha, así que Make solo reinstala cuando
`pyproject.toml` o `uv.lock` son más nuevos. El directorio va como order-only
porque su fecha cambia cada vez que se escribe un stamp dentro; como
prerrequisito normal haría que los demás stamps parecieran viejos y se
rehicieran sin motivo. Order-only significa "tiene que existir", sin comparar
fechas.

**9.** Con `-j`, los prerrequisitos de `ci` que no dependen entre sí se lanzan a
la vez; el orden de la lista solo se respeta en modo serie. La forma correcta es
declarar la dependencia real (`build: test`, `test: lint`). Como alternativas,
`.WAIT` entre prerrequisitos (Make 4.4+) o, en 4.3, `.NOTPARALLEL: ci`, que
serializa solo ese target.

**10.** Los tres sub-makes escriben en la misma terminal a la vez, y cada línea
sale cuando se produce. `-O` (`--output-sync`) hace que Make guarde la salida de
cada target y la imprima de una vez al terminar: la ejecución sigue siendo
paralela, pero el log se lee por bloques.

</details>

---

## 💪 Desempeño (40%)

Diez puntos por lab. El Desempeño es la suma sobre 60, llevada a porcentaje.
Cada criterio de éxito se comprueba ejecutando el comando en tu máquina.

| Lab | Criterio | Puntos |
|---|---|:--:|
| [01 — Build C completo](2-practicas/lab-01-build-c-completo/README.md) | `make all` sin trabajo la segunda vez; tocar un `.c` recompila solo su objeto; tocar `config.h` recompila los que lo incluyen | 10 |
| [02 — Pipeline Python + Docker](2-practicas/lab-02-pipeline-python-docker/README.md) | `make ci` encadena lint, test y build-image; un error de estilo lo detiene en lint; `make push` sin `CI=true` se niega | 10 |
| [03 — CI local](2-practicas/lab-03-ci-local/README.md) | `hooks-install` fija `core.hooksPath`; un `make check` roto aborta el commit; `hooks-uninstall` lo quita | 10 |
| [04 — Módulos compartidos](2-practicas/lab-04-modulos-compartidos/README.md) | `service-a` y `service-b` construyen con los mismos módulos y cada uno conserva su `VERSION`; los módulos no imprimen nada al importarse | 10 |
| [05 — Optimización paralela](2-practicas/lab-05-optimizacion-paralela/README.md) | Segunda ejecución sin trabajo; tocar un manifiesto reinstala solo ese stack; `make -j2 all` da el mismo resultado que `make all` | 10 |
| [06 — Debug en producción](2-practicas/lab-06-debug-produccion/README.md) | Los cinco errores corregidos con `# FIX:`; `make -j2 ci` da el mismo resultado que `make ci` | 10 |

Dentro de cada lab: 10 puntos si se cumplen todos los criterios y explicas con
tus palabras qué técnica de semanas anteriores aplicaste; 8 si se cumplen
todos; 7 si falla uno; menos de 7 si fallan dos o más.

---

## 📦 Producto (30%)

### Verificable por el autograding — 60 puntos

Lo ejecuta `./scripts/verificar-semana.sh 14`. Es binario: pasa o no pasa. No
necesita red ni Docker.

| Comprobación | Puntos |
|---|:--:|
| `shellflags-estrictas` — el Makefile raíz corre las recetas con `bash -eu -o pipefail` | 3 |
| `delete-on-error` — el Makefile raíz declara `.DELETE_ON_ERROR` | 2 |
| `all-tres-servicios` — `make all` construye backend, frontend e infra | 4 |
| `ci-servicio-orden` — `make ci` en un servicio ejecuta lint, test y build en ese orden | 4 |
| `ci-raiz-tres-servicios` — `make ci` desde la raíz termina bien y construye los tres servicios | 4 |
| `fallo-propaga` — si los tests del primer servicio fallan, `make ci` sale con error | 6 |
| `fallo-detiene-resto` — tras el fallo de backend, `make ci` no sigue con los demás | 3 |
| `target-por-servicio` — `make infra/test` ejecuta solo los tests de infra | 4 |
| `deploy-prod-sin-confirm` — `make deploy ENV=production` sin `CONFIRM=yes` falla con un error claro | 5 |
| `deploy-prod-confirm` — con `CONFIRM=yes` despliega los tres servicios | 3 |
| `push-requiere-ci` — `make push` se niega a publicar si `CI` no es `true` | 5 |
| `push-con-ci` — con `CI=true`, `push` publica `IMAGE_NAME:VERSION` | 3 |
| `build-image-tag` — `make build-image` etiqueta la imagen como `IMAGE_NAME:VERSION` | 3 |
| `hooks-path` — `make hooks-install` apunta `core.hooksPath` a `hooks/` | 4 |
| `check-lint` — `make check` ejecuta el lint de los tres servicios | 3 |
| `jobserver-compartido` — `make -j3 all` reparte el jobserver con los sub-makes | 4 |
| **Total** | **60** |

### Calidad — 40 puntos

Lo que el autograding no puede ver.

| Criterio | Excelente | Suficiente | Puntos |
|---|---|---|:--:|
| **Servicios mínimos** | Cada `backend/`, `frontend/`, `infra/Makefile` solo define variables e incluye módulos; ninguna receta duplicada | Una receta duplicada | 10 |
| **Módulos reutilizables** | Variables con `?=`, sin `$(info)` ni `$(shell)` al importarse, cada módulo documenta qué variables requiere | Falta la documentación | 8 |
| **Recursión legible** | `SERVICE_TARGETS` generado con `$(foreach)`; una sola regla con `$(@D)` y `$(@F)` | Reglas por servicio escritas a mano | 6 |
| **`.PHONY` completo** | Todos los targets que no producen archivo, incluidos los `servicio/meta`, están declarados | Falta uno | 6 |
| **Orden y secciones** | Preámbulo, variables, recursión, metas agregadas, hooks, ayuda | Secciones mezcladas | 6 |
| **`help` útil** | `make` sin argumentos lista los targets en la raíz y en cada servicio | Falta en algún Makefile | 4 |
| **Total** | | | **40** |

### Penalizaciones

| Situación | Deducción |
|---|:--:|
| Recursión con bucle `for ... $(MAKE) ...` | **−15 pts**. Un servicio roto puede dejar el pipeline en verde |
| `make` literal en lugar de `$(MAKE)` en una receta recursiva | −10 pts. Rompe el jobserver y `make -n` |
| `rm -rf` sobre una variable sin guarda de vacío | −10 pts |
| `pip` o `npm` en cualquier receta o Dockerfile | −10 pts. Python siempre con uv; Node.js siempre con pnpm |
| `push` sin guarda o con credenciales en el Makefile | −10 pts |

---

## 📋 Checklist de entrega

- [ ] Los 6 labs con sus criterios de éxito comprobados en tu máquina
- [ ] Las 10 preguntas de Conocimiento respondidas por escrito
- [ ] Ningún `TODO` en `3-proyecto/starter/` (Makefile raíz, servicios y `shared-mk/`)
- [ ] `./scripts/verificar-semana.sh 14` con las 16 comprobaciones en verde
- [ ] `make ci FAIL=backend; echo $?` imprime un código distinto de 0

---

[← Volver a la Semana 14](README.md)
