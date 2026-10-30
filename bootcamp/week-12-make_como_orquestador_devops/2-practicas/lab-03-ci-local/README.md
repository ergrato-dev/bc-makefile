# Lab 03 — Pipeline CI/CD Local

⏱ Duración estimada: ~60 min

## Objetivo

Construir un `make ci` que encadene lint → test → build → report con fallo rápido y llamarlo, sin repetir ningún comando, desde un workflow mínimo de GitHub Actions.

## Contexto

- Un pipeline es una cadena de etapas donde cada una exige el éxito de la anterior. En Make se modela con prerrequisitos: `ci: lint test build report`. Si `lint` sale con código ≠ 0, Make se detiene y `test` nunca corre.
- El runner de CI no debe saber qué es flake8 ni pytest: solo ejecuta `make ci`. Si el YAML repite los comandos, hay dos pipelines que divergen; si solo llama a `make ci`, reproducir un fallo de CI es ejecutar el mismo comando en tu máquina.
- Un workflow también es código que corre con permisos: `permissions: contents: read` limita el token al mínimo, y cada acción se fija por el SHA de 40 caracteres de su commit. Un tag (`@v7`) se puede mover a código distinto; un SHA no.

## Instrucciones

1. Copia el starter:
   ```bash
   cp -r starter/ mi-lab-03 && cd mi-lab-03
   ```

2. Instala las dependencias de Python (uv, nunca pip):
   ```bash
   make install   # uv sync --locked: flake8, pytest y pytest-cov del grupo dev
   make install   # segunda vez: no vuelve a sincronizar (sentinel de la semana 11)
   ```

3. Examina la estructura del proyecto:
   ```bash
   ls src/ tests/
   cat src/calculadora.py
   ```

4. **TODO 1** — implementa `lint`: ejecuta `$(FLAKE8) $(SRC_DIR)`.

5. **TODO 2** — implementa `test`: `$(PYTEST) $(TEST_DIR) -v --cov=$(SRC_DIR) --cov-report=term-missing`.

6. **TODO 3** — implementa `build`: crea `dist/` y `dist/$(APP_NAME)-$(VERSION).tar.gz` con `src/`.

7. **TODO 4** — implementa `report`: imprime app, versión, fecha y una línea `✓` por etapa.

8. **TODO 5** — `ci` solo con prerrequisitos (`lint test build report`) y la línea final `✓ CI OK`. Ejecuta:
   ```bash
   make ci
   ```
   Debes ver, al final:
   ```
   ✓ CI OK
   ```

9. Comprueba el fallo rápido con un error de estilo:
   ```bash
   echo "x=1+2" >> src/calculadora.py
   make ci; echo "exit=$?"
   ```
   Debe aparecer `E225 missing whitespace around operator`, después
   `make: *** [Makefile:NN: lint] Error 1` y `exit=2`; la línea `→ Tests...` no
   aparece. Deshaz el cambio (`sed -i '$ d' src/calculadora.py`; en macOS
   `sed -i '' '$ d' ...`).

10. Escribe el workflow que llama al mismo comando. Crea `.github/workflows/ci.yml`:
    ```yaml
    name: CI

    on:
      push:
        branches: [main]
      pull_request:

    # Mínimo privilegio: el token del job solo puede leer el repositorio
    permissions:
      contents: read

    jobs:
      ci:
        runs-on: ubuntu-24.04
        steps:
          # Acciones pinneadas por SHA; el tag legible va en el comentario
          - uses: actions/checkout@3d3c42e5aac5ba805825da76410c181273ba90b1 # v7.0.1
            with:
              persist-credentials: false
          - uses: astral-sh/setup-uv@c771a70e6277c0a99b617c7a806ffedaca235ff9 # v9.0.0
            with:
              version: "0.12.2"
          # Lo mismo que en local: nada de repetir flake8 ni pytest aquí
          - run: make ci
    ```

11. Verifica el workflow sin subirlo a GitHub (sin red):
    ```bash
    grep -E '^ *(- )?run:' .github/workflows/ci.yml
    grep -E 'uses:' .github/workflows/ci.yml | grep -vE '@[0-9a-f]{40}( |$)' || echo "todas pinneadas"
    grep -A1 '^permissions:' .github/workflows/ci.yml
    ```
    Debes ver exactamente:
    ```
          - run: make ci
    todas pinneadas
    permissions:
      contents: read
    ```

12. Cambia temporalmente el `checkout` a `@v7` y repite el segundo `grep` del paso 11: ahora imprime esa línea. Así detecta un revisor (o un check de CI) una acción sin pinnear. Vuelve a dejar el SHA.

## Criterios de éxito

- [ ] `make lint` ejecuta `uv run --no-sync flake8 src` y sale con 0 sin errores de estilo
- [ ] `make test` ejecuta pytest con cobertura e imprime `5 passed`
- [ ] `make build` crea `dist/calculadora-<VERSION>.tar.gz` con `src/`
- [ ] `make ci` con código limpio ejecuta las cuatro etapas y termina con `✓ CI OK`
- [ ] Con un error de lint, `make ci` sale con código 2 y no imprime `→ Tests...`
- [ ] `.github/workflows/ci.yml` tiene un único `run:` (`make ci`), todas sus acciones pinneadas por SHA y `permissions: contents: read`
- [ ] `make help` lista todos los targets

## Reto extra

Agrega `ci-fast` (solo lint y test) para el ciclo de desarrollo. Después escribe en un comentario del Makefile por qué el workflow debe seguir llamando a `make ci` y no a `make ci-fast`, aunque tarde más.
