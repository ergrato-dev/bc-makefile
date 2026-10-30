# Rúbrica de Evaluación — Semana 12

> Make como orquestador DevOps. Se evalúan tres evidencias por separado, y hace
> falta **70% en cada una**: un `make ci` en verde no compensa no saber por qué
> un `VERSION` manipulado podía ejecutar código al pedir la ayuda.

---

## 📊 Distribución de Evidencias

| Evidencia | Peso | Instrumento |
|---|:--:|---|
| 🧠 Conocimiento | 30% | Las 10 preguntas de esta rúbrica, respondidas por escrito |
| 💪 Desempeño | 40% | Los 6 labs, con sus criterios de éxito verificados en tu máquina |
| 📦 Producto | 30% | Pipeline local del proyecto: 60 pts de autograding + 40 pts de calidad |

**Mínimo 70% en cada evidencia.** No en el promedio.

| Calificación | Rango |
|---|:--:|
| Sobresaliente | 90-100% |
| Notable | 80-89% |
| Aprobado | 70-79% |
| No aprobado | < 70% |

---

## 🧠 Conocimiento (30%)

Diez preguntas, 3 puntos cada una. No se pide recordar comandos de git: se pide
explicar por qué el pipeline está construido así.

| # | Pregunta |
|:--:|---|
| 1 | `guard-%` comprueba la variable con `$(if $($*),:,$(error ...))` y no con `test -n '$($*)'` en la receta. Da dos razones concretas, una de confidencialidad y otra de seguridad. |
| 2 | Tu `.env` tiene `SECRET_KEY="ab$cd#9"`. ¿Qué valor llega a la app tras `-include .env`, y por qué? |
| 3 | ¿Qué hace `export` sin argumentos y por qué es un riesgo aunque ninguna receta imprima las variables? |
| 4 | ¿Por qué se usa `-include .env` con guion y no `include .env`, pensando en el runner de CI? |
| 5 | ¿Por qué `core.hooksPath` apuntando a `scripts/hooks/` es mejor que copiar los hooks a `.git/hooks/`? |
| 6 | Un compañero puede saltarse el pre-commit con `git commit --no-verify`. Entonces, ¿para qué sirven los hooks y dónde tiene que estar el control que no se puede saltar? |
| 7 | Un PR cambia `VERSION` a `1.0.0';touch PWNED;'`. Si el Makefile hace `MAJOR := $(shell echo '$(VERSION)' \| cut -d. -f1)`, ¿qué pasa al ejecutar `make help`, y por qué ocurre aunque `help` no use `MAJOR`? |
| 8 | La validación de `VERSION` está a nivel de Makefile (`ifneq ... $(error)`) y la de `SECRET_KEY` dentro de `guard-%`. ¿Por qué cada una está en un sitio distinto? |
| 9 | `ci: env-check lint test build report`. Con `make ci` el orden se respeta; con `make -j4 ci`, ¿se garantiza que `lint` termina antes de `build`? ¿Cómo lo harías explícito? |
| 10 | ¿Por qué `make ci` debe ser exactamente lo que ejecuta el runner de CI, en lugar de que el workflow de GitHub Actions repita los comandos de lint y test? |

<details>
<summary><strong>Respuestas</strong></summary>

**1.** Confidencialidad: Make imprime cada línea de receta antes de ejecutarla
(con `-n`, siempre), así que el valor del secreto acaba en la terminal o en el
log de CI. Seguridad: el valor se pega dentro de un comando de shell; un secreto
con `'` cierra la comilla y lo que sigue se ejecuta. `$(if)` se evalúa dentro de
Make y el valor nunca llega al shell.

**2.** Make lee `.env` como un Makefile: las comillas son parte del valor, `$c`
se expande como variable de Make (vacía) y `#9"` es un comentario, comilla de
cierre incluida. La app recibe `"abd`, con una comilla suelta delante. Por eso
los valores de `.env` van sin comillas, sin `$` y sin `#`.

**3.** Exporta todas las variables de Make al entorno de cada comando. Cualquier
proceso que lance una receta (un test, un script de terceros, un `npx` o un
`uv run`) puede leer `SECRET_KEY` aunque no la necesite, y basta un volcado de
entorno en un error para que acabe en un log. `export` con lista limita la
exposición a lo imprescindible.

**4.** En CI no hay `.env`: las variables las inyecta el runner como variables
de entorno. `include .env` haría fallar el Makefile entero; `-include` lo
carga si existe y, si no, sigue con lo que haya en el entorno.

**5.** `scripts/hooks/` está versionado: todos usan la misma versión del hook y
un cambio llega con un `git pull`. `.git/hooks/` no se versiona; copiar exige
volver a instalar tras cada cambio y cada clon puede tener una versión distinta
o ninguna. Además `make hooks-uninstall` es solo quitar una línea de config.

**6.** Los hooks son una ayuda: detectan errores pronto, en la máquina del
desarrollador, antes de que lleguen al remoto. No son un control de seguridad
porque viven en el cliente y se desactivan con un flag. El control obligatorio
está en CI y en la protección de ramas: `make ci` en el runner, sin el cual no
se puede fusionar.

**7.** `$(shell ...)` con `:=` se ejecuta al leer el Makefile, antes de decidir
qué target construir. La comilla del valor cierra la del `echo` y `touch
PWNED` se ejecuta: basta abrir el proyecto y pedir la ayuda. Por eso `VERSION`
se lee con `$(file <)`, que no lanza un shell, y se valida antes de usarla.

**8.** `VERSION` se usa en muchas recetas y en variables derivadas; si es
maliciosa, ningún target es seguro, así que el Makefile entero se niega a
cargar. `SECRET_KEY` solo hace falta para algunos targets: si la exigieras a
nivel de Makefile, `make help` o `make clean` fallarían sin `.env`.

**9.** No. Con `-j` Make lanza los prerrequisitos que no dependen entre sí en
paralelo; el orden de la lista solo se respeta en modo serie. Para garantizarlo
hay que declarar la dependencia real (`build: test`, `test: lint`), usar
`.WAIT` entre prerrequisitos (Make 4.4+) o, en 4.3, `.NOTPARALLEL: ci`.

**10.** Si el workflow repite los comandos, hay dos pipelines que divergen: un
flag cambia en el Makefile y no en el YAML, y "en local pasa" deja de significar
"en CI pasa". Con `make ci` en ambos lados, reproducir un fallo de CI es
ejecutar el mismo comando en tu máquina.

</details>

---

## 💪 Desempeño (40%)

Diez puntos por lab. El Desempeño es la suma sobre 60, llevada a porcentaje.
Cada criterio de éxito se comprueba ejecutando el comando en tu máquina.

| Lab | Criterio | Puntos |
|---|---|:--:|
| [01 — `.env` y secretos](2-practicas/lab-01-env-secrets/README.md) | `make env-check` nombra la variable que falta y sale con error; `env-show` enmascara secretos y no ejecuta un valor hostil; sin `export` a secas | 10 |
| [02 — Git hooks](2-practicas/lab-02-git-hooks/README.md) | `hooks-install` fija `core.hooksPath`; `hooks-uninstall` lo quita; un commit con `.env.prod` aborta y uno con `.env.example` pasa | 10 |
| [03 — CI local](2-practicas/lab-03-ci-local/README.md) | `make ci` encadena lint, test, build y report; con un error de lint aborta sin ejecutar `test` | 10 |
| [04 — Lint y calidad](2-practicas/lab-04-lint-calidad/README.md) | `make lint` ejecuta los tres análisis; una herramienta ausente avisa sin abortar; `check-tools` muestra la tabla | 10 |
| [05 — Release](2-practicas/lab-05-release/README.md) | `bump-patch`, `bump-minor` y `bump-major` correctos; `release-patch` desde `0.1.0` crea `v0.1.1` | 10 |
| [06 — Pipeline roto](2-practicas/lab-06-pipeline-roto/README.md) | Los cinco errores corregidos, cada uno con su síntoma documentado; `make ci` completo dos veces seguidas; `make` a secas muestra la ayuda | 10 |

Dentro de cada lab: 10 puntos si se cumplen todos los criterios y explicas con
tus palabras qué protege cada target; 8 si se cumplen todos; 7 si falla uno;
menos de 7 si fallan dos o más.

---

## 📦 Producto (30%)

### Verificable por el autograding — 60 puntos

Lo ejecuta `./scripts/verificar-semana.sh 12`. Es binario: pasa o no pasa. No
toca la red ni la configuración git de tu repositorio.

| Comprobación | Puntos |
|---|:--:|
| `version-rechaza-inyeccion` — una `VERSION` con código de shell hace fallar a Make antes de ejecutar nada | 5 |
| `version-rechaza-formato` — una `VERSION` sin tres componentes numéricos se rechaza | 3 |
| `bump-patch` — `make bump-patch` convierte `1.2.9` en `1.2.10` | 4 |
| `guard-falla` — `guard-VAR` falla con un mensaje que nombra la variable | 5 |
| `env-check-secret-key` — `make env-check` falla si `SECRET_KEY` está vacía | 4 |
| `export-selectivo` — las recetas reciben `DB_URL` pero no variables que el Makefile no exporta | 5 |
| `hooks-path` — `make hooks-install` apunta `core.hooksPath` a `scripts/hooks` con ruta absoluta | 5 |
| `hooks-uninstall` — `make hooks-uninstall` deja `core.hooksPath` sin configurar | 3 |
| `pre-commit-bloquea-env` — con los hooks instalados, un commit que incluye `.env` se rechaza | 5 |
| `install-locked` — `make install` sincroniza con `uv sync --locked` | 3 |
| `sentinel-incremental` — con el sentinel al día, `make install` no vuelve a ejecutar `uv sync` | 4 |
| `lint-flake8` — `make lint` ejecuta flake8 con `uv run --no-sync` | 2 |
| `test-cobertura` — `make test` ejecuta pytest con cobertura | 3 |
| `build-artefacto` — `make build` crea `dist/mi-api-VERSION.tar.gz` con `src/` | 4 |
| `ci-orden` — `make ci` encadena lint, test y build en ese orden | 3 |
| `ci-valida-entorno-primero` — `make ci` se detiene en `env-check`, antes del lint, si falta `SECRET_KEY` | 2 |
| **Total** | **60** |

### Calidad — 40 puntos

Lo que el autograding no puede ver.

| Criterio | Excelente | Suficiente | Puntos |
|---|---|---|:--:|
| **Secretos fuera del shell** | Ningún secreto aparece en una línea de receta; validaciones con `$(if)`; `.env.example` sin valores reales | Un secreto se valida en shell pero con `@` | 10 |
| **`.env` tratado como Makefile** | Comentario que advierte de `$`, comillas y `#`; `.gitignore` con `.env*` y `!.env.example` | Falta la advertencia | 8 |
| **Hooks como ayuda, no como control** | Los hooks llaman a targets de Make (`make lint`), no duplican lógica; README o comentario explica que `--no-verify` los salta | Lógica duplicada en el hook | 6 |
| **`.PHONY` completo** | Todos los targets que no producen archivo están declarados; el sentinel no | Falta uno | 6 |
| **Orden y secciones** | Preámbulo, variables, entorno, guardas, instalación, hooks, pipeline, release, limpieza | Secciones mezcladas | 6 |
| **`help` útil** | `make` sin argumentos lista todos los targets con descripción | Falta alguno | 4 |
| **Total** | | | **40** |

### Penalizaciones

| Situación | Deducción |
|---|:--:|
| `.env` o cualquier secreto comiteado | **−20 pts**. Un secreto en el historial de git está filtrado aunque borres el archivo después |
| `export` a secas | **−15 pts**. Todos los secretos llegan a todos los subprocesos |
| `VERSION` pasada por `$(shell ...)` o usada sin validar | **−15 pts**. Un PR puede ejecutar código en la máquina de quien abre el proyecto |
| `rm -rf` sobre una variable sin guarda de vacío | −10 pts |
| `pip install` en cualquier receta o hook | −10 pts. Python siempre con uv |

---

## 📋 Checklist de entrega

- [ ] Los 6 labs con sus criterios de éxito comprobados en tu máquina
- [ ] Las 10 preguntas de Conocimiento respondidas por escrito
- [ ] `3-proyecto/starter/Makefile` sin ningún `TODO`
- [ ] `./scripts/verificar-semana.sh 12` con las 16 comprobaciones en verde
- [ ] `git status` sin `.env`, `.venv/` ni `dist/`

---

[← Volver a la Semana 12](README.md)
