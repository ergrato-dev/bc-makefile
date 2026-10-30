# Lab 05 — Makefile Multi-Stack

**Duración estimada:** 60 minutos

**Requisitos:** Python 3.14 y uv; Node.js 26 LTS y pnpm. Docker no hace falta.

## Objetivo

Combinar un backend Python y un frontend Node.js en un único Makefile con targets prefijados (`backend-*`, `frontend-*`) y targets sin prefijo que orquesten los dos stacks.

## Contexto

En un repositorio con backend Python y frontend Node.js, el Makefile de la raíz es el coordinador. La convención de prefijos evita colisiones: `backend-install` y `frontend-install` son targets distintos, cada uno con su sentinel. El target sin prefijo solo agrupa:

```makefile
test: backend-test frontend-test ## Ejecutar todos los tests
```

Como `backend-test` y `frontend-test` no dependen entre sí, Make puede ejecutarlos en paralelo con `-j`, y con `-k` puede seguir con uno aunque el otro falle. Eso solo es posible porque cada stack es un target, no una línea dentro de un script.

## Instrucciones

1. Entra al directorio starter y revisa la estructura:
   ```bash
   cd lab-05-multi-stack/starter
   ls -R backend frontend
   make info
   ```

2. Implementa el **TODO 0** (preámbulo estricto) y los TODOs del backend:
   - **TODO 1:** `$(VENV)/.installed` (`VENV` ya incluye `backend/`), dependiente de `backend/pyproject.toml` y `backend/uv.lock`
   - **TODO 2:** `backend-install` — alias del sentinel
   - **TODO 3:** `backend-test` — pytest en `backend/`

   ```bash
   make backend-test
   make backend-install    # Nothing to be done
   ```
   Fíjate en que el sentinel vive en `backend/.venv/` pero Make lo gestiona desde la raíz: la receta hace `cd backend`, la ruta del target no.

3. Implementa los TODOs del frontend:
   - **TODO 4:** `frontend/node_modules/.installed` (`pnpm install --frozen-lockfile` + `mkdir -p $(@D)` + `touch $@`)
   - **TODO 5:** `frontend-install` — alias del sentinel
   - **TODO 6:** `frontend-test` — tests de Node en `frontend/`

4. Implementa **TODO 7** (`install`) y **TODO 8** (`test`), y ejecútalos:
   ```bash
   make install
   make test
   ```

5. Implementa **TODO 9** (`backend-lint` con `ruff check` y `backend-format` con `ruff format`) y **TODO 10** (`frontend-lint` y `lint`):
   ```bash
   make lint
   make backend-format
   ```

6. Paralelismo: como los dos stacks son independientes, Make puede ejecutarlos a la vez. `-O` agrupa la salida de cada target para que no se mezcle:
   ```bash
   make -j2 -O test
   ```
   El orden de los bloques `[backend]` y `[frontend]` puede variar entre ejecuciones.

7. Propagación de fallos: rompe un test del backend y compara `make test` con `make -k test`:
   ```bash
   sed -i 's/== 5/== 6/' backend/tests/test_app.py   # en macOS: sed -i ''
   make test;    echo "salida: $?"
   make -k test; echo "salida: $?"
   ```
   Sin `-k`, Make para en `backend-test` y el frontend no se prueba. Con `-k` prueba el frontend igualmente, pero `test` sigue sin rehacerse y la salida sigue siendo 2. Deshaz el cambio (`sed -i 's/== 6/== 5/' backend/tests/test_app.py`).

8. Limpia y comprueba que no queda nada:
   ```bash
   make clean
   ls -a backend frontend
   ```

## Criterios de éxito

```
$ make install
[backend] Instalando dependencias...
cd backend && uv sync --locked
...
[frontend] Instalando dependencias...
cd frontend && pnpm install --frozen-lockfile
...

$ make install
make: Nothing to be done for 'install'.
```

```
$ make test
[backend] Ejecutando tests...
tests/test_app.py::test_saludar PASSED
tests/test_app.py::test_sumar PASSED
[frontend] Ejecutando tests...
PASS: saludar retorna saludo correcto
...
Todos los tests pasaron.
```

```
$ make lint
[backend] Lint...
cd backend && uv run --no-sync ruff check src/
All checks passed!
[frontend] Lint...
cd frontend && pnpm run lint
Lint OK
```

```
$ make -k test        # con el test del backend roto
make: *** [Makefile:NN: backend-test] Error 1
[frontend] Ejecutando tests...
Todos los tests pasaron.
make: Target 'test' not remade because of errors.
```

Tras `make clean`, `backend/` y `frontend/` solo contienen los archivos versionados (sin `.venv/` ni `node_modules/`).

## Reto extra

Agrega un target `build` que construya una imagen Docker de todo el stack: etapa Node que copia `frontend/src` a un bundle, etapa final `python:3.14-slim` con `uv sync --locked --no-dev` del backend que copia el bundle, y usuario no-root.
