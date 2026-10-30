# Lab 01 — Python con Make

**Duración estimada:** 50 minutos

**Requisitos:** Python 3.14 y [uv](https://docs.astral.sh/uv/)

## Objetivo

Gestionar el ciclo de vida completo de un proyecto Python (virtualenv, dependencias, tests, linting) usando Make como único punto de entrada.

## Contexto

Sin Make, un desarrollador que clona el repo necesita recordar: qué gestor usa el proyecto, cómo crear el entorno, cómo instalar exactamente lo del lockfile y con qué flags se corren los tests. Con Make: `make install && make test`.

El truco clave es el **sentinel file**: el target `install` depende de `$(VENV)/.installed`, un archivo vacío que Make usa para saber si ya se ejecutó `uv sync`. Si `pyproject.toml` o `uv.lock` cambian, Make detecta que el sentinel es más antiguo y reinstala; de lo contrario, no hace nada.

```makefile
$(VENV)/.installed: pyproject.toml uv.lock
	$(UV) sync --locked   # crea .venv/ e instala exactamente uv.lock
	@touch $@             # ← crea el sentinel al terminar
```

Python se gestiona siempre con **uv**, nunca con pip: `pyproject.toml` declara las dependencias, `uv.lock` las fija y se commitea, `uv sync --locked` instala exactamente eso (y falla si el lock no coincide con `pyproject.toml`). Los targets ejecutan las herramientas con `uv run --no-sync`: Make ya decidió si hacía falta instalar.

## Instrucciones

1. Entra al directorio starter:
   ```bash
   cd lab-01-python/starter
   ```

2. Revisa la estructura del proyecto:
   ```bash
   ls -R
   ```

3. Ejecuta el estado inicial — el target `help` ya funciona:
   ```bash
   make help
   ```

4. Implementa los 5 TODOs del `Makefile`:
   - **TODO 1:** target `$(VENV)/.installed` con dependencias `pyproject.toml` y `uv.lock`; receta `$(UV) sync --locked` y `touch $@`
   - **TODO 2:** target `install` como alias del sentinel file, con comentario `## ...`
   - **TODO 3:** target `test` que dependa de `install` y ejecute pytest
   - **TODO 4:** target `lint` que dependa de `install` y ejecute flake8
   - **TODO 5:** target `clean` que elimine `.venv/` y cachés de Python

5. Verifica cada target:
   ```bash
   make install
   make test
   make lint
   make clean
   make install  # segunda vez: no debe reinstalar
   ```

## Criterios de éxito

```
$ make install
uv sync --locked
...
Installed 7 packages in 12ms

$ make install  # segunda ejecución — sentinel sin cambios
make: Nothing to be done for 'install'.
```

```
$ make test
uv run --no-sync pytest tests/ -v
...
tests/test_app.py::test_saludar PASSED
tests/test_app.py::test_sumar PASSED
2 passed in 0.XXs
```

```
$ make lint
uv run --no-sync flake8 src/ --max-line-length=100
(sin salida si no hay errores)
```

```
$ make clean
Limpiado.
$ ls .venv
ls: no se puede acceder a '.venv': No existe el archivo o el directorio
```

## Reto extra

Agrega un target `test-cov` que ejecute pytest con cobertura: `pytest --cov=src --cov-report=term-missing`. Añade `pytest-cov` con `uv add --dev pytest-cov` (actualiza `pyproject.toml` y `uv.lock`; el sentinel se invalida solo).
