# Proyecto — Makefile de Microservicio Listo para Producción

**Duración estimada:** 2h 30min

**Requisitos:** Python 3.10+, Docker 24+

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
├── requirements.txt      ← dependencias de runtime
├── requirements-dev.txt  ← dependencias de desarrollo (pytest, flake8)
├── Dockerfile            ← imagen del servicio (no modificar)
├── docker-compose.yml    ← stack local (no modificar)
└── .env.example          ← variables de entorno de referencia
```

## Entregables

1. `Makefile` con los siguientes targets funcionales:
   - `make install` — venv + `requirements.txt` (sentinel file)
   - `make install-dev` — venv + `requirements.txt` + `requirements-dev.txt` (sentinel file)
   - `make test` — pytest, depende de `install-dev`
   - `make lint` — flake8, depende de `install-dev`
   - `make run` — ejecuta `src/main.py` con el venv local
   - `make build` — `docker build` con `VERSION` y `BUILD_DATE` como `--build-arg`
   - `make docker-run` — `docker run` con variables de `.env`
   - `make up` — `docker-compose up -d`
   - `make down` — `docker-compose down`
   - `make info` — muestra versión, imagen, fecha, entorno activo
   - `make deploy-prod` — pide confirmación antes de ejecutar
   - `make clean` — elimina `.venv/` y cachés Python

2. `-include .env` con `export` al inicio del Makefile

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
python3 -m venv .venv
[...]
Dependencias de desarrollo instaladas.

$ make test
.venv/bin/pytest tests/ -v
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
Successfully built XXXXXXXXXX
```

```
$ make deploy-prod
¿Desplegar notificador:0.0.0 en PRODUCCIÓN? [y/N] n
make: *** [Makefile:XX: deploy-prod] Error 1
(correcto — canceló sin desplegar)
```

## Rúbrica del proyecto (30 pts)

| Criterio | Pts |
|----------|-----|
| `make install` usa sentinel file — no reinstala sin cambios en `requirements.txt` | 6 |
| `make test` y `make lint` pasan sin errores | 6 |
| `make build` inyecta `VERSION` y `BUILD_DATE` como build args | 6 |
| `make info` muestra versión, imagen, fecha y entorno en formato legible | 6 |
| `make deploy-prod` pide confirmación interactiva antes de ejecutar | 6 |

## Entrega

Commit con el mensaje:
```
feat(week-07): proyecto - makefile microservicio produccion
```
