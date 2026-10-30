# Lab 04 — Targets de Calidad y Análisis Estático

⏱ Duración estimada: ~60 min

## Objetivo

Implementar un target `lint` compuesto que ejecute múltiples herramientas de análisis estático (shellcheck, flake8, markdownlint) y un target `format` que aplique formatos automáticamente.

## Contexto

Un target `lint` real en un proyecto moderno no es solo una herramienta — es una composición de varias. Cada herramienta tiene su dominio:

| Herramienta | Dominio |
|------------|---------|
| `flake8` | Python — estilo PEP8 |
| `shellcheck` | Bash scripts — errores y buenas prácticas |
| `markdownlint` o `mdl` | Documentación Markdown |
| `hadolint` | Dockerfiles |

El patrón Make para esto: un target padre `lint` que depende de `lint-python lint-shell lint-docs`. Si alguno falla, `lint` falla. Cada sub-target puede ejecutarse por separado.

## Instrucciones

1. Copia el starter:
   ```bash
   cp -r starter/ mi-lab-04 && cd mi-lab-04
   ```

2. Verifica qué herramientas tienes disponibles:
   ```bash
   which shellcheck flake8 mdl 2>/dev/null || echo "algunas no están instaladas"
   ```

3. Implementa `lint-python` usando flake8 (si disponible) con fallback a `python3 -m py_compile`.

4. Implementa `lint-shell` usando shellcheck con fallback a `bash -n`.

5. Implementa `lint-docs` usando grep para detectar líneas muy largas en Markdown (>120 chars).

6. Implementa `lint` como target padre que ejecuta los tres.

7. Implementa `format-python` que ejecuta `autopep8` o imprime instrucciones si no está instalado.

8. Implementa `check-tools` que verifica qué herramientas de calidad están instaladas.

9. Verifica:
   ```bash
   make check-tools
   make lint
   ```
   Debe terminar con `✓ Lint OK`.

10. Rompe a propósito dos dominios a la vez y compara `make` con `make -k`:
    ```bash
    cp src/app.py app.py.bak && cp scripts/deploy.sh deploy.sh.bak
    echo 'def roto(:' >> src/app.py
    echo 'if [ ; then' >> scripts/deploy.sh
    make lint; echo "exit=$?"
    make -k lint; echo "exit=$?"
    ```
    Con `make lint` solo verás el error de Python: Make se detiene en
    `lint-python` y nunca ejecuta `lint-shell`. Con `make -k lint` (*keep going*)
    verás los dos errores, `✓ Lint Docs OK` y al final:
    ```
    make: Target 'lint' not remade because of errors.
    exit=2
    ```
    `-k` sigue con todo lo que no depende de lo que falló, pero el código de
    salida sigue siendo ≠ 0: sirve para ver todos los problemas de una pasada
    sin que el pipeline pase en verde.

11. Añade el target `lint-all` (`## Ejecutar todos los linters aunque alguno falle`)
    cuya receta sea `@$(MAKE) --no-print-directory -k lint`, y restaura los
    archivos:
    ```bash
    make lint-all; echo "exit=$?"     # dos errores, exit=2
    mv app.py.bak src/app.py && mv deploy.sh.bak scripts/deploy.sh
    make lint-all; echo "exit=$?"     # ✓ Lint OK, exit=0
    ```

## Criterios de éxito

- [ ] `make check-tools` → imprime tabla con herramientas disponibles y no disponibles
- [ ] `make lint-python` → ejecuta análisis Python (nunca falla por herramienta no instalada)
- [ ] `make lint-shell` → ejecuta análisis de scripts bash
- [ ] `make lint-docs` → detecta líneas largas en archivos .md
- [ ] `make lint` → ejecuta los tres lint y reporta resultado final
- [ ] Si una herramienta no está instalada, el target muestra advertencia pero no aborta
- [ ] Con errores en Python y en shell, `make lint` muestra solo el primero y `make -k lint` muestra los dos; ambos salen con código 2
- [ ] `make lint-all` reporta todos los errores y sale con ≠ 0; sin errores, sale con 0
- [ ] `make help` → lista todos los targets

## Reto extra

Agrega `lint-makefile` que usa `checkmake` (si disponible) o implementa verificaciones básicas propias: detecta targets sin `.PHONY`, TABs vs espacios, targets sin `##`.
