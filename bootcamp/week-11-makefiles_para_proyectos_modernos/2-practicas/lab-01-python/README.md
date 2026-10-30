# Lab 01 — Python con Make

**Duración estimada:** 50 minutos

**Requisitos:** Python 3.10+, pip

## Objetivo

Gestionar el ciclo de vida completo de un proyecto Python (virtualenv, dependencias, tests, linting) usando Make como único punto de entrada.

## Contexto

Sin Make, un desarrollador que clona el repo necesita recordar: `python3 -m venv .venv && source .venv/bin/activate && pip install -r requirements.txt && pip install -r requirements-dev.txt && pytest tests/ -v`. Con Make: `make install && make test`.

El truco clave es el **sentinel file**: el target `install` depende de `$(VENV)/.installed`, un archivo vacío que Make usa para saber si ya se ejecutó `pip install`. Si `requirements.txt` cambia, Make detecta que el sentinel es más antiguo y reinstala; de lo contrario, no hace nada.

```makefile
$(VENV)/.installed: requirements.txt
	python3 -m venv $(VENV)
	$(PIP) install -r requirements.txt
	@touch $@   # ← crea el sentinel al terminar
```

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
   - **TODO 1:** target `$(VENV)/.installed` con dependencia `requirements.txt`, crea venv e instala
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
python3 -m venv .venv
.venv/bin/pip install --upgrade pip ...
.venv/bin/pip install -r requirements.txt ...

$ make install  # segunda ejecución — sentinel sin cambios
make: '.venv/.installed' is up to date.
```

```
$ make test
.venv/bin/pytest tests/ -v
...
tests/test_app.py::test_saludar PASSED
tests/test_app.py::test_sumar PASSED
2 passed in 0.XXs
```

```
$ make lint
.venv/bin/flake8 src/ --max-line-length=100
(sin salida si no hay errores)
```

```
$ make clean
Limpiado.
$ ls .venv
ls: no se puede acceder a '.venv': No existe el archivo o el directorio
```

## Reto extra

Agrega un target `test-cov` que ejecute pytest con cobertura: `pytest --cov=src --cov-report=term-missing`. Instala `pytest-cov` añadiéndolo al `requirements.txt`.
