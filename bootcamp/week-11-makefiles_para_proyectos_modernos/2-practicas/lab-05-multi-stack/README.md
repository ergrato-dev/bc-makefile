# Lab 05 — Makefile Multi-Stack

**Duración estimada:** 50 minutos

**Requisitos:** Python 3.10+, Node.js 18+, Docker 24+

## Objetivo

Combinar Python, Node.js y Docker en un único Makefile usando targets prefijados (`backend-*`, `frontend-*`, `docker-*`) y un target `all` que orqueste el build completo.

## Contexto

En proyectos reales, un equipo puede tener un backend Python y un frontend Node.js en el mismo repositorio. El Makefile actúa como coordinador:

```
make backend-test     → pytest en backend/
make frontend-test    → npm test en frontend/
make test             → ambos, en secuencia
make build            → docker build de todo el stack
```

La convención de prefijos evita colisiones: `backend-install` y `frontend-install` son targets distintos. El target sin prefijo (`install`, `test`) llama a los dos.

```makefile
test: backend-test frontend-test ## Ejecutar todos los tests
```

## Instrucciones

1. Entra al directorio starter:
   ```bash
   cd lab-05-multi-stack/starter
   ```

2. Revisa la estructura:
   ```bash
   ls -R
   ```

3. Ejecuta `make info` para ver el stack configurado:
   ```bash
   make info
   ```

4. Implementa los 8 TODOs del `Makefile`:
   - **TODO 1:** `backend/$(VENV)/.installed` — sentinel para backend Python
   - **TODO 2:** `backend-install` — alias del sentinel
   - **TODO 3:** `backend-test` — pytest en backend/
   - **TODO 4:** `frontend/node_modules/.package-lock.json` — sentinel para frontend Node
   - **TODO 5:** `frontend-install` — alias del sentinel
   - **TODO 6:** `frontend-test` — npm test en frontend/
   - **TODO 7:** `install` — depende de `backend-install frontend-install`
   - **TODO 8:** `test` — depende de `backend-test frontend-test`

5. Verifica:
   ```bash
   make install
   make test
   make info
   make clean
   ```

## Criterios de éxito

```
$ make install
[backend] Instalando dependencias...
[frontend] Instalando dependencias...

$ make test
[backend] Ejecutando tests...
tests/test_app.py::test_saludar PASSED
tests/test_app.py::test_sumar PASSED
[frontend] Ejecutando tests...
PASS: saludar retorna saludo correcto
Todos los tests pasaron.
```

```
$ make info
=== Stack multi-lenguaje ===
Backend:   Python 3.x — backend/
Frontend:  Node.js vX.X — frontend/
Docker:    docker compose disponible
```

## Reto extra

Agrega un target `build` que construya la imagen Docker de todo el stack, usando la imagen del backend como base y copiando el bundle del frontend.
