# Lab 02 — Pipeline Python + Docker

**Duración estimada:** 50 min

## Objetivo

Implementar un pipeline completo `lint → test → build-image → push` para un servicio Python con Make, donde cada etapa falla rápido si encuentra errores.

## Contexto

El patrón pipeline-as-Makefile tiene tres ventajas sobre un script bash:
- Cada etapa es invocable independientemente (`make lint`, `make test`)
- Fallo rápido gracias al comportamiento natural de Make (si una receta falla, el pipeline se detiene)
- Las dependencias entre etapas están explícitas: `build-image` depende de `test`, que depende de `lint`

El target `ci` actúa como punto de entrada que encadena todo. El target `push` solo funciona cuando `CI=true` para evitar pushes accidentales.

## Instrucciones

1. Copia el starter:
   ```bash
   cp -r starter/ mi-lab-02 && cd mi-lab-02
   ```

2. Instala dependencias del proyecto:
   ```bash
   make deps
   # Instala flake8 y pytest vía pip
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

7. Encadena todo en `ci`:
   ```bash
   make ci
   # Debe ejecutar lint → test → build-image en orden
   ```

## Criterios de éxito

- [ ] `make lint` pasa sin errores con el código del starter
- [ ] `make test` ejecuta los tests y todos pasan
- [ ] `make build-image` crea la imagen `mi-servicio:dev`
- [ ] `make push` sin `CI=true` → error claro, no push
- [ ] `make ci` ejecuta lint, test y build-image en ese orden
- [ ] Si se introduce un error de estilo en `src/app.py`, `make ci` falla en la etapa lint

## Reto extra

Agrega un target `scan` que ejecute `docker scout cves` sobre la imagen construida (si Docker Scout está disponible); si no lo está, imprime `Docker Scout no disponible — saltando` sin fallar.
