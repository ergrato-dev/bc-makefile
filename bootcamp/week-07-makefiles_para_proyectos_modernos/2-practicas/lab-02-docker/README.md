# Lab 02 — Docker con Make

**Duración estimada:** 50 minutos

**Requisitos:** Docker 24+

## Objetivo

Centralizar el ciclo de vida de una imagen Docker (build, run, push, clean) en un Makefile con variables configurables desde CLI.

## Contexto

Sin Make, el flujo Docker requiere recordar flags largos: `docker build --build-arg VERSION=$(git describe --tags) -t miusuario/mi-app:1.2.3 -t miusuario/mi-app:latest .`. Un error tipográfico en el nombre del tag puede subir una imagen mal etiquetada al registry.

Con Make, ese flujo se vuelve `make build VERSION=1.2.3` — y la misma lógica se reutiliza en CI.

Puntos clave de este lab:
- `VERSION` derivado de git automáticamente, pero sobreescribible desde CLI: `make build VERSION=1.0.0`
- `BUILD_DATE` capturado con `$(shell date ...)`
- `--build-arg` para inyectar metadata en la imagen
- Target `info` que muestra metadata de la imagen ya construida con `docker inspect`

## Instrucciones

1. Entra al directorio starter:
   ```bash
   cd lab-02-docker/starter
   ```

2. Revisa el `Dockerfile` y el `app.py` incluidos:
   ```bash
   cat Dockerfile
   cat app.py
   ```

3. Ejecuta `make help` para ver la estructura base:
   ```bash
   make help
   ```

4. Implementa los 5 TODOs del `Makefile`:
   - **TODO 1:** target `build` con `docker build`, usando `--build-arg VERSION` y `--build-arg BUILD_DATE`; etiqueta la imagen como `$(IMAGE_NAME):$(VERSION)` y `$(IMAGE_NAME):latest`
   - **TODO 2:** target `run` que ejecute el contenedor con `docker run --rm`
   - **TODO 3:** target `push` que etiquete con el registry completo y haga push de ambos tags
   - **TODO 4:** target `info` que use `docker image inspect` para mostrar el tamaño y los labels
   - **TODO 5:** target `clean-image` que elimine la imagen local

5. Verifica el flujo completo:
   ```bash
   make build
   make info
   make run
   make clean-image
   ```

## Criterios de éxito

```
$ make build
docker build \
  --build-arg VERSION=dev \
  --build-arg BUILD_DATE=2026-06-04T... \
  -t mi-app:dev \
  -t mi-app:latest \
  .
...
Successfully built XXXXXXXXXX

$ make info
Nombre:   mi-app:dev
Tamaño:   XXX MB
Creada:   2026-06-04T...
```

```
$ make run
Hola desde Docker! Versión: dev
```

```
$ make clean-image
Imagen mi-app:dev eliminada.
```

## Reto extra

Agrega un target `scan` que ejecute `docker scout cves mi-app:latest` (o `docker scan mi-app:latest` en versiones antiguas) para ver vulnerabilidades conocidas de la imagen.
