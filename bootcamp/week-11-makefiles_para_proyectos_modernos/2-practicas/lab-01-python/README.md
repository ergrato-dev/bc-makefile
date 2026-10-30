# Lab 01 — Python con Make

**Duración estimada:** 60 minutos

**Requisitos:** Python 3.14 y [uv](https://docs.astral.sh/uv/)

## Objetivo

Gestionar el ciclo de vida completo de un proyecto Python (entorno, dependencias, tests, lint y formato) usando Make como único punto de entrada.

## Contexto

Sin Make, quien clona el repo necesita recordar qué gestor usa el proyecto, cómo crear el entorno, cómo instalar exactamente lo del lockfile y con qué flags se corren los tests. Con Make: `make install && make test`.

El truco clave es el **sentinel file**: `install` depende de `$(VENV)/.installed`, un archivo vacío que solo se crea si `uv sync` terminó bien. Si `pyproject.toml` o `uv.lock` son más nuevos que el sentinel, Make reinstala; si no, no hace nada. Los targets ejecutan las herramientas con `uv run --no-sync`: Make ya decidió si hacía falta instalar.

El grupo `dev` de `pyproject.toml` trae **pytest** y **ruff** (versión fijada `ruff==0.16.10`). Ruff es un único binario con dos subcomandos: `ruff check` analiza el código (imports sin usar, nombres indefinidos...) y `ruff format` lo reescribe con un estilo fijo.

## Instrucciones

1. Entra al directorio starter y revisa el proyecto:
   ```bash
   cd lab-01-python/starter
   ls -R
   cat pyproject.toml
   make help
   ```
   `help` es el único target que funciona de momento.

2. Implementa el **TODO 0** (preámbulo estricto), el **TODO 1** (sentinel `$(VENV)/.installed`) y el **TODO 2** (alias `install`). Ejecuta dos veces:
   ```bash
   make install
   make install
   ```
   La primera crea `.venv/` e instala 6 paquetes; la segunda imprime `make: Nothing to be done for 'install'.`

3. Comprueba que el sentinel sigue a `uv.lock`. Simula que un compañero actualizó el lock:
   ```bash
   touch uv.lock
   make -n install      # muestra "uv sync --locked": Make reinstalaría
   make install
   make install         # vuelve a no hacer nada
   ```
   Quita `uv.lock` de los prerrequisitos del sentinel, repite `touch uv.lock && make -n install` y anota qué pasa. Vuelve a ponerlo.

4. Implementa el **TODO 3** (`test`) y ejecútalo:
   ```bash
   make test
   ```

5. Implementa el **TODO 4** (`lint` con `ruff check`). Pásalo limpio y después rómpelo a propósito añadiendo un import sin usar:
   ```bash
   make lint                       # All checks passed!
   { echo 'import os'; cat src/app.py; } > src/app.tmp && mv src/app.tmp src/app.py
   make lint; echo "código de salida: $?"
   ```
   Ruff reporta ``F401 [*] `os` imported but unused`` (y un `I001` porque falta la línea en blanco tras el import), y Make sale con código 2 (`make: *** [Makefile:NN: lint] Error 1`). Ese código distinto de cero es lo que hace fallar un pipeline de CI. Borra la línea que añadiste.

6. Implementa el **TODO 5** (`format`). Añade al final de `src/app.py` una función mal formateada y deja que ruff la arregle:
   ```bash
   printf 'def doble( x ):\n    return x*2\n' >> src/app.py
   make format
   tail -2 src/app.py
   ```
   Debe quedar `def doble(x):` y `return x * 2`. Borra la función al terminar.

7. Implementa el **TODO 6** (`clean` con guardas) y prueba la guarda:
   ```bash
   make clean VENV=      # debe negarse
   make clean
   ls .venv              # ya no existe
   ```

## Criterios de éxito

```
$ make install
uv sync --locked
Using CPython 3.14.x
Creating virtual environment at: .venv
Resolved 8 packages in ...
Installed 6 packages in ...
 + pytest==9.2.0
 + ruff==0.16.10
 ...

$ make install
make: Nothing to be done for 'install'.

$ touch uv.lock && make -n install
uv sync --locked
```

```
$ make test
uv run --no-sync pytest tests -v
...
tests/test_app.py::test_saludar PASSED
tests/test_app.py::test_sumar PASSED
2 passed in 0.XXs
```

```
$ make lint
uv run --no-sync ruff check src
All checks passed!
```

```
$ make format
uv run --no-sync ruff format src tests
2 files left unchanged
```

```
$ make clean VENV=
Makefile:NN: *** VENV vacía: rm -rf no se ejecuta.  Stop.
$ make clean
Limpiado.
```

## Reto extra

Agrega un target `test-cov` que ejecute pytest con cobertura: `pytest --cov=src --cov-report=term-missing`. Añade `pytest-cov` con `uv add --dev pytest-cov` (actualiza `pyproject.toml` y `uv.lock`; el sentinel se invalida solo: compruébalo con `make -n install`).
