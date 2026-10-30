# Lab 02 — Pipeline Python + Docker

⏱ Duración estimada: ~60 min

## Objetivo

Implementar un pipeline completo `lint → test → build-image → push` para un servicio Python con Make, donde cada etapa falla rápido si encuentra errores.

## Contexto

El patrón pipeline-as-Makefile tiene tres ventajas sobre un script bash:
- Cada etapa es invocable independientemente (`make lint`, `make test`)
- Fallo rápido gracias al comportamiento natural de Make (si una receta falla, el pipeline se detiene)
- Las dependencias entre etapas están explícitas: `build-image` depende de `test`, que depende de `lint`

El target `ci` actúa como punto de entrada que encadena todo. El target `push` solo funciona cuando `CI=true` para evitar pushes accidentales, y `check-nonroot` lee la configuración de la imagen recién construida y falla si corre como root (semana 11): es la diferencia entre "el Dockerfile dice USER" y "la imagen que vas a publicar no es root".

## Instrucciones

1. Copia el starter:
   ```bash
   cp -r starter/ mi-lab-02 && cd mi-lab-02
   ```

2. Instala dependencias del proyecto:
   ```bash
   make deps
   # uv sync --locked: crea .venv/ con flake8 y pytest (nunca pip)
   ```

3. Implementa el target `lint`:
   ```bash
   make lint
   # Debe ejecutar: flake8 src/ --max-line-length=100
   ```

4. Implementa el target `test`:
   ```bash
   make test
   # Debe ejecutar: pytest tests/ -v
   ```

5. Implementa el target `build-image`:
   ```bash
   make build-image
   # Debe ejecutar: docker build --tag $(IMAGE_NAME):$(VERSION) .
   ```

6. Implementa `push` con guardia `CI=true`:
   ```bash
   make push           # debe fallar con "ERROR: push solo en CI=true"
   CI=true make push   # debe ejecutar docker push
   ```

7. Implementa `check-nonroot` (depende de `build-image`) y compruébalo con el
   Dockerfile del starter, que todavía no declara `USER`:
   ```bash
   make check-nonroot; echo "exit=$?"
   ```
   Debe fallar con `✗ mi-servicio:<VERSION> corre como root` y `exit=2`.

8. Completa el `TODO` del `Dockerfile` (usuario de sistema con UID 10001 y
   `USER app` antes del `CMD`) y repite:
   ```bash
   make check-nonroot
   docker run --rm --entrypoint id mi-servicio:$(git describe --tags --always) -u
   ```
   Debes ver `✓ mi-servicio:<VERSION> corre como app` y `10001`.

9. Encadena todo en `ci` con `lint test check-nonroot` como prerrequisitos y
   compruébalo sin ejecutar nada:
   ```bash
   make -n ci | grep -E 'flake8|pytest|docker (build|image)'
   ```
   Deben aparecer, en este orden, `flake8`, `pytest`, `docker build` y
   `docker image inspect`. Después ejecútalo de verdad con `make ci`.

## Criterios de éxito

- [ ] `make lint` pasa sin errores con el código del starter
- [ ] `make test` ejecuta los tests y todos pasan
- [ ] `make build-image` crea la imagen `mi-servicio:<VERSION>` (la que muestra `make -n build-image`)
- [ ] `make check-nonroot` falla sin `USER` en el Dockerfile y pasa con `USER app`
- [ ] `make push` sin `CI=true` → error claro, no push
- [ ] `make ci` ejecuta lint, test, build-image y check-nonroot en ese orden
- [ ] Si se introduce un error de estilo en `src/app.py`, `make ci` falla en la etapa lint

## Reto extra

Agrega un target `scan` que ejecute `docker scout cves` sobre la imagen construida (si Docker Scout está disponible); si no lo está, imprime `Docker Scout no disponible — saltando` sin fallar.
