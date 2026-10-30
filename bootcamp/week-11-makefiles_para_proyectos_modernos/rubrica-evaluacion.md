# Rúbrica de Evaluación — Semana 11

> Makefiles para proyectos modernos. Se evalúan tres evidencias por separado, y
> hace falta **70% en cada una**: un `make test` que pasa no compensa no saber
> por qué `make install` reinstalaba en cada ejecución.

---

## 📊 Distribución de Evidencias

| Evidencia | Peso | Instrumento |
|---|:--:|---|
| 🧠 Conocimiento | 30% | Las 10 preguntas de esta rúbrica, respondidas por escrito |
| 💪 Desempeño | 40% | Los 6 labs, con sus criterios de éxito verificados en tu máquina |
| 📦 Producto | 30% | Makefile del microservicio: 60 pts de autograding + 40 pts de calidad |

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
por qué el Makefile está escrito así.

| # | Pregunta |
|:--:|---|
| 1 | El target de instalación es `.venv/.installed` y no `.venv`. ¿Qué sale mal si usas el directorio como target? Da los dos fallos posibles. |
| 2 | ¿Por qué el sentinel depende de `pyproject.toml` **y** de `uv.lock`, y qué pasaría en el equipo si dependiera solo de `pyproject.toml`? |
| 3 | ¿Qué diferencia hay entre `uv sync` y `uv sync --locked`, y por qué la segunda es la única aceptable en un Makefile que también corre en CI? |
| 4 | Los targets ejecutan las herramientas con `uv run --no-sync`. ¿Qué haría `uv run` sin ese flag y por qué eso choca con el sentinel de Make? |
| 5 | `install` usa `uv sync --locked --no-dev --inexact`. ¿Qué pasa si quitas `--inexact` y ejecutas `make install-dev`, luego `make run`, luego `make test`? |
| 6 | En Node.js el sentinel es `node_modules/.installed` y la receta usa `pnpm install --frozen-lockfile`. ¿Por qué ese flag, y por qué el sentinel debe depender de `pnpm-lock.yaml`? |
| 7 | El `Dockerfile` termina con `useradd` y `USER app`. ¿Qué riesgo concreto reduce no correr como root, y por qué esas líneas van después de `uv sync` y no antes? |
| 8 | ¿Por qué el Makefile usa `COMPOSE := docker compose` y no `docker-compose`, y qué ganas teniendo el comando en una variable? |
| 9 | Tu `.env` tiene `SMTP_PASS=ab$xyz#1`. ¿Qué valor recibe la app tras `-include .env` y `export SMTP_PASS`? ¿Por qué nunca escribes `export` a secas? |
| 10 | `BUILD_DATE` se define con `:=` y no con `=`. ¿Qué podría ocurrir con `=` en un `make deploy-prod` que construye, etiqueta y despliega? |

<details>
<summary><strong>Respuestas</strong></summary>

**1.** La fecha de un directorio cambia cada vez que se crea o borra algo dentro,
así que `.venv` "rejuvenece" con cualquier cosa que haga uv o pytest y Make deja
de ver cambios en `uv.lock`. Y si `uv sync` falla a mitad, `.venv/` ya existe:
Make lo da por construido y no vuelve a intentarlo. El sentinel solo se crea con
`touch $@` al final de una receta que terminó bien.

**2.** `pyproject.toml` dice qué quieres; `uv.lock` dice qué versiones exactas
instalas. Si un compañero hace `uv lock --upgrade` y commitea solo el lock, tu
`pyproject.toml` no cambió: con una única dependencia, Make no reinstalaría y
seguirías probando contra versiones distintas a las del resto del equipo.

**3.** `uv sync` resuelve de nuevo y reescribe `uv.lock` si no coincide con
`pyproject.toml`. `--locked` falla en ese caso. En CI eso es lo que quieres: un
lock desactualizado es un error del commit, no algo que se arregla en silencio
instalando versiones que nadie revisó.

**4.** `uv run` sincroniza el entorno antes de ejecutar: puede instalar el grupo
dev, desinstalar paquetes o tocar la red en cada `make run`. Make ya decidió con
el sentinel si había que instalar; si uv decide otra vez, hay dos fuentes de
verdad y el sentinel deja de describir lo que hay en `.venv/`.

**5.** `uv sync` es exacto por defecto: deja el entorno con lo pedido y nada más.
`make run` instalaría solo runtime y **desinstalaría** pytest y flake8, pero
`.venv/.installed-dev` sigue existiendo y es más nuevo que sus dependencias.
`make test` no reinstala y `uv run --no-sync pytest` falla porque pytest ya no
está. `--inexact` añade lo que falta sin quitar lo que sobra.

**6.** Sin el flag, pnpm puede actualizar el lockfile si no coincide con
`package.json` y cada máquina acaba con versiones distintas; con él, falla. El
sentinel depende del lock para reinstalar cuando alguien lo cambia en un pull,
aunque `package.json` siga igual.

**7.** Si la app tiene una vulnerabilidad, el atacante obtiene los permisos del
proceso: como root puede modificar el sistema de archivos de la imagen, instalar
herramientas o aprovechar una mala configuración del runtime para salir del
contenedor. Las líneas van después de `uv sync` porque instalar en `/app/.venv`
necesita permisos de escritura que el usuario `app` no tiene; el usuario se fija
para el `CMD`, que es lo que corre en producción.

**8.** `docker-compose` es Compose v1, sin mantenimiento desde 2023; Compose v2
es un plugin de Docker y se invoca como `docker compose`. Con el comando en una
variable hay un único sitio que cambiar (por ejemplo, `COMPOSE := podman
compose`) y se puede sobrescribir desde la línea de comandos sin tocar recetas.

**9.** Make lee `.env` como un Makefile: `$x` se expande como variable de Make
(vacía) y `#1` es un comentario. La app recibe `abyz`. Por eso los valores de
`.env` no llevan `$`, comillas ni `#`. `export` a secas manda **todas** las
variables de Make, incluidos los secretos que no hacían falta, al entorno de
cada comando, donde cualquier script o dependencia puede leerlos o volcarlos a
un log.

**10.** Con `=` la variable se expande cada vez que se usa, y `$(shell date)` se
ejecuta en cada expansión. El `--build-arg BUILD_DATE` y el mensaje de despliegue
podrían llevar segundos distintos, y la etiqueta que muestras no coincidiría con
la que inyectaste. `:=` evalúa una sola vez al leer el Makefile.

</details>

---

## 💪 Desempeño (40%)

Diez puntos por lab. El Desempeño es la suma sobre 60, llevada a porcentaje.
Cada criterio de éxito se comprueba ejecutando el comando en tu máquina.

| Lab | Criterio | Puntos |
|---|---|:--:|
| [01 — Python con uv](2-practicas/lab-01-python/README.md) | `make install` crea `.venv/` con `uv sync --locked`; la segunda ejecución dice `Nothing to be done`; `make test` y `make lint` pasan | 10 |
| [02 — Docker](2-practicas/lab-02-docker/README.md) | `make build VERSION=1.0.0` inyecta `VERSION` y `BUILD_DATE`; la imagen se etiqueta sin `latest`; `make info` muestra tamaño y fecha de creación | 10 |
| [03 — Node.js con pnpm](2-practicas/lab-03-nodejs/README.md) | `make install` usa `pnpm install --frozen-lockfile` con sentinel; segunda ejecución sin trabajo; `make test` y `make build` funcionan | 10 |
| [04 — Compose](2-practicas/lab-04-compose/README.md) | `make info` funciona sin Docker; `up`, `ps`, `restart SERVICE=web` y `down` usan `docker compose` | 10 |
| [05 — Multi-stack](2-practicas/lab-05-multi-stack/README.md) | Targets `backend-*` y `frontend-*` con su propio sentinel; `make test` corre los dos stacks | 10 |
| [06 — Targets rotos](2-practicas/lab-06-targets-rotos/README.md) | Los cinco bugs reproducidos y corregidos; `make demo` pasa sin errores | 10 |

Dentro de cada lab: 10 puntos si se cumplen todos los criterios y explicas con
tus palabras qué decide el sentinel o la variable que usaste; 8 si se cumplen
todos; 7 si falla uno; menos de 7 si fallan dos o más.

---

## 📦 Producto (30%)

### Verificable por el autograding — 60 puntos

Lo ejecuta `./scripts/verificar-semana.sh 11`. Es binario: pasa o no pasa. No
necesita red ni Docker: los targets de contenedores se comprueban con `make -n`.

| Comprobación | Puntos |
|---|:--:|
| `shellflags-estrictas` — las recetas corren con `bash -eu -o pipefail` | 3 |
| `delete-on-error` — el Makefile declara `.DELETE_ON_ERROR` | 3 |
| `install-runtime` — `make install` sincroniza solo runtime con `uv sync --locked --no-dev` | 4 |
| `install-dev-completo` — `make install-dev` sincroniza el grupo dev con `uv sync --locked` | 4 |
| `sentinel-incremental` — con el sentinel al día, `make install` no vuelve a ejecutar `uv sync` | 6 |
| `test-instala-dev` — `make test` instala antes el grupo dev si falta | 4 |
| `test-sin-sync` — `make test` ejecuta pytest con `uv run --no-sync` | 3 |
| `build-version` — `make build` pasa `VERSION` como `--build-arg` | 4 |
| `build-fecha` — `make build` pasa `BUILD_DATE` como `--build-arg` | 3 |
| `build-sin-latest` — la imagen se etiqueta con la versión y nunca con `latest` | 3 |
| `export-selectivo` — las recetas reciben `LOG_LEVEL` pero no variables que el Makefile no exporta | 5 |
| `info-imagen` — `make info` muestra la imagen con la versión | 3 |
| `compose-v2` — `make up` usa `docker compose` | 3 |
| `deploy-cancela` — responder `n` a `make deploy-prod` cancela sin llamar a docker | 5 |
| `clean-con-guarda` — `make clean` se niega a borrar si `VENV` está vacía | 4 |
| `clean-borra-venv` — `make clean` elimina el entorno virtual | 3 |
| **Total** | **60** |

### Calidad — 40 puntos

Lo que el autograding no puede ver.

| Criterio | Excelente | Suficiente | Puntos |
|---|---|---|:--:|
| **Una sola fuente de verdad** | Solo los sentinels deciden cuándo instalar; ningún target llama a `uv sync` o `uv run` sin `--no-sync` fuera de ellos | Un target instala por su cuenta | 10 |
| **`.env` tratado como Makefile** | `-include .env` con comentario que advierte de `$`, comillas y `#`; `export` con lista explícita | Lista explícita sin advertencia | 8 |
| **Comandos en variables** | `UV`, `COMPOSE`, `PYTEST`, `IMAGE` en variables; ninguna receta repite el nombre de la imagen | Algún literal repetido | 6 |
| **`.PHONY` completo** | Todos los targets que no producen archivo están declarados; los sentinels no | Falta uno | 6 |
| **Orden y secciones** | Preámbulo, configuración, entorno, instalación, calidad, Docker, Compose, despliegue, limpieza | Secciones mezcladas | 6 |
| **`help` útil** | `make` sin argumentos lista todos los targets con descripción | Falta alguno | 4 |
| **Total** | | | **40** |

### Penalizaciones

| Situación | Deducción |
|---|:--:|
| `rm -rf` sobre una variable sin guarda de vacío | **−15 pts**. Un `VENV` vacío por un typo no puede borrar el directorio equivocado |
| `export` a secas o `.env` comiteado | **−15 pts**. Los secretos acaban en cada subproceso o en el historial de git |
| `pip install` o `npm install` en cualquier receta | −10 pts. Python siempre con uv; Node.js siempre con pnpm |
| `.venv/`, `__pycache__/` o `.pytest_cache/` comiteados | −10 pts |
| Imagen etiquetada como `latest` o `Dockerfile` sin `USER` no root | −5 pts |

---

## 📋 Checklist de entrega

- [ ] Los 6 labs con sus criterios de éxito comprobados en tu máquina
- [ ] Las 10 preguntas de Conocimiento respondidas por escrito
- [ ] `3-proyecto/starter/Makefile` sin ningún `TODO`
- [ ] `./scripts/verificar-semana.sh 11` con las 16 comprobaciones en verde
- [ ] `make clean` deja el árbol de trabajo limpio (`git status` sin `.venv/` ni cachés)

---

[← Volver a la Semana 11](README.md)
