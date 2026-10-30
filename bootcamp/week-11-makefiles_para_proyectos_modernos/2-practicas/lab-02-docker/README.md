# Lab 02 — Docker con Make

**Duración estimada:** 60 minutos

**Requisitos:** Docker Engine 27+

## Objetivo

Centralizar el ciclo de vida de una imagen Docker (build, run, push, clean) en un Makefile con variables configurables desde CLI.

## Contexto

Sin Make, el flujo Docker requiere recordar flags largos: `docker build --build-arg VERSION=$(git describe --tags) -t miusuario/mi-app:1.2.3 .`. Un error tipográfico en el nombre del tag puede subir una imagen mal etiquetada al registry.

Con Make, ese flujo se vuelve `make build VERSION=1.2.3` — y la misma lógica se reutiliza en CI.

Puntos clave de este lab:
- `VERSION` derivado de git automáticamente, pero sobreescribible desde CLI: `make build VERSION=1.0.0`
- `BUILD_DATE` capturado con `$(shell date ...)`
- `--build-arg` para inyectar metadata en la imagen
- Target `info` que muestra metadata de la imagen ya construida con `docker inspect`
- Build incremental: una imagen no es un archivo, así que Make no puede comparar su fecha. `docker build --iidfile` escribe el ID de la imagen en un archivo que sí puede depender de `Dockerfile` y `app.py`

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

4. Implementa el **TODO 0** (preámbulo estricto) y los TODOs 1–5 del `Makefile`:
   - **TODO 1:** target `build` con `docker build`, usando `--build-arg VERSION` y `--build-arg BUILD_DATE`; etiqueta la imagen como `$(IMAGE_NAME):$(VERSION)` (sin `latest`: es mutable y no dice qué código corre)
   - **TODO 2:** target `run` que ejecute el contenedor con `docker run --rm`
   - **TODO 3:** target `push` que etiquete la imagen con el registry completo (`$(FULL_IMAGE):$(VERSION)`) y publique solo ese tag
   - **TODO 4:** target `info` que use `docker image inspect` para mostrar el tamaño y los labels
   - **TODO 5:** target `clean-image` que elimine la imagen local

5. Verifica el flujo completo:
   ```bash
   make build VERSION=1.0.0
   make info VERSION=1.0.0
   make run VERSION=1.0.0
   make -n push VERSION=1.0.0    # sin red: solo muestra los comandos
   ```

6. Ejecuta `make build VERSION=1.0.0` otra vez. Docker usa su caché, pero el `docker build` se lanza igual: Make no sabe que la imagen ya está al día. Implementa el **TODO 6** (build incremental con `--iidfile`) y comprueba:
   ```bash
   make build VERSION=1.0.0      # construye y escribe .build/mi-app-1.0.0.iid
   make build VERSION=1.0.0      # solo imprime el mensaje: no llama a docker
   touch app.py
   make -n build VERSION=1.0.0   # vuelve a aparecer docker build
   cat .build/mi-app-1.0.0.iid   # sha256:...
   ```
   El nombre del archivo lleva la versión: cambiar `VERSION` construye otra imagen aunque el código no haya cambiado.

7. Limpia:
   ```bash
   make clean-image VERSION=1.0.0
   ls -a                         # sin .build/
   ```

## Criterios de éxito

```
$ make build VERSION=1.0.0
docker build \
	--iidfile .build/mi-app-1.0.0.iid \
	--build-arg VERSION=1.0.0 \
	--build-arg BUILD_DATE=2026-10-30T... \
	-t mi-app:1.0.0 \
	.
...
 => => naming to docker.io/library/mi-app:1.0.0
Imagen: mi-app:1.0.0 (sha256:1346f74f7764)

$ make build VERSION=1.0.0
Imagen: mi-app:1.0.0 (sha256:1346f74f7764)

$ make info VERSION=1.0.0
Nombre:   mi-app:1.0.0
Tamaño:   178415758 bytes
Creada:   2026-10-30T...
```

```
$ make run VERSION=1.0.0
docker run --rm -p 127.0.0.1:8080:8080 mi-app:1.0.0
Hola desde Docker! Versión: 1.0.0
```

```
$ make clean-image VERSION=1.0.0
...
Imagen mi-app:1.0.0 eliminada.
```

Ningún comando etiqueta ni publica `latest`.

## Reto extra

Agrega un target `scan` que ejecute `docker scout cves mi-app:$(VERSION)` para ver vulnerabilidades conocidas de la imagen.
