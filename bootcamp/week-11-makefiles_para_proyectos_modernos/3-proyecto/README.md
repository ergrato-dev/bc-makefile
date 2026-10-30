# Proyecto — Makefile de Microservicio Listo para Producción

**Duración estimada:** 2h 30min

**Requisitos:** Python 3.14, Docker Engine 27+ con Compose v2

## Contexto

Tu equipo acaba de decidir estandarizar todos los microservicios bajo la misma interfaz Make. El servicio `notificador` es el primero: un servidor Python que en producción corre en Docker, pero en desarrollo se ejecuta directamente con `python3`.

El objetivo no es solo que funcione — cualquier script bash puede hacer eso. El objetivo es que sea **idempotente** (ejecutar `make install` dos veces no falla), **auto-documentado** (`make help` explica todo) y **CI-compatible** (`make test` funciona igual en tu máquina y en GitHub Actions).

## Árbol de archivos del starter

```
starter/
├── Makefile              ← implementar los TODOs
├── src/
│   └── main.py           ← servicio Python (no modificar)
├── tests/
│   └── test_main.py      ← tests (no modificar)
├── pyproject.toml        ← dependencias (runtime + grupo dev: pytest, flake8)
├── uv.lock               ← versiones exactas, generado por uv (commitear)
├── Dockerfile            ← imagen del servicio (no modificar)
├── docker-compose.yml    ← stack local (no modificar)
└── .env.example          ← variables de entorno de referencia
```

## Entregables

1. `Makefile` con los siguientes targets funcionales:
   - `make install` — `uv sync --locked --no-dev --inexact`, solo runtime (sentinel file)
   - `make install-dev` — `uv sync --locked`, runtime + grupo dev (sentinel file)
   - `make test` — pytest, depende de `install-dev`
   - `make lint` — flake8, depende de `install-dev`
   - `make run` — ejecuta `src/main.py` con `uv run`
   - `make build` — `docker build` con `VERSION` y `BUILD_DATE` como `--build-arg`
   - `make docker-run` — `docker run` con variables de `.env`
   - `make up` — `docker compose up -d`
   - `make down` — `docker compose down`
   - `make info` — muestra versión, imagen, fecha, entorno activo
   - `make deploy-prod` — pide confirmación antes de ejecutar
   - `make clean` — elimina `.venv/` y cachés Python, con guarda si `VENV` está vacía

2. Preámbulo estricto (`SHELL := bash`, `.SHELLFLAGS := -eu -o pipefail -c`, `.DELETE_ON_ERROR:`) y `-include .env` con `export` solo de las variables que lee la app (nunca `export` a secas)

3. `make help` documentado con `##` en todos los targets

## Verificación

```bash
cd starter

# Instalar y testear
make install-dev
make test
make lint

# Ver información del proyecto
make info

# Construir imagen Docker
make build

# Verificar que help muestra todos los targets
make help
```

Outputs esperados:

```
$ make install-dev
uv sync --locked --no-dev --inexact
[...]
uv sync --locked
[...]
Dependencias de desarrollo instaladas.

$ make test
uv run --no-sync pytest tests/ -v
...
tests/test_main.py::test_notificar PASSED
tests/test_main.py::test_notificar_vacio PASSED
2 passed in 0.XXs

$ make info
=== notificador ===
Versión:    0.0.0  (o tag git)
Imagen:     notificador:0.0.0
Fecha:      2026-06-04T...
Entorno:    dev

$ make build
docker build --build-arg VERSION=0.0.0 ...
...
 => => naming to docker.io/library/notificador:0.0.0
```

```
$ make deploy-prod
¿Desplegar notificador:0.0.0 en PRODUCCIÓN? [y/N] n
make: *** [Makefile:XX: deploy-prod] Error 1
(correcto — canceló sin desplegar)
```

## ✅ Requisitos verificables

Los comprueba `./scripts/verificar-semana.sh 11` desde la raíz del repositorio
(60 de los 100 puntos del Producto). Los otros 40 son de calidad: ver la
[rúbrica](../rubrica-evaluacion.md#-producto-30). Ninguna comprobación necesita
red ni Docker: los targets de Docker y Compose se verifican con `make -n`.

- [ ] El Makefile ejecuta las recetas con bash -eu -o pipefail
- [ ] El Makefile declara .DELETE_ON_ERROR
- [ ] make install sincroniza solo las dependencias de runtime con uv sync --locked --no-dev
- [ ] make install-dev sincroniza el grupo dev con uv sync --locked
- [ ] make install no vuelve a ejecutar uv sync si el sentinel es más nuevo que pyproject.toml y uv.lock
- [ ] make test instala antes el grupo dev si falta
- [ ] make test ejecuta pytest con uv run --no-sync
- [ ] make build pasa VERSION a docker build como --build-arg
- [ ] make build pasa BUILD_DATE a docker build como --build-arg
- [ ] La imagen se etiqueta con la versión y nunca con latest
- [ ] Las recetas reciben LOG_LEVEL pero no variables que el Makefile no exporta
- [ ] make info muestra la imagen con la versión
- [ ] make up usa Compose v2 (docker compose, no docker-compose)
- [ ] Responder n a make deploy-prod cancela el despliegue sin llamar a docker
- [ ] make clean se niega a borrar si VENV está vacía
- [ ] make clean elimina el directorio del entorno virtual

## Entrega

Commit con el mensaje:
```
feat(week-11): proyecto - makefile microservicio produccion
```
