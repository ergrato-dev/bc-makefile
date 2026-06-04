# Lab 04 — Targets de Calidad y Análisis Estático

**Duración estimada:** 50 min

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

## Criterios de éxito

- [ ] `make check-tools` → imprime tabla con herramientas disponibles y no disponibles
- [ ] `make lint-python` → ejecuta análisis Python (nunca falla por herramienta no instalada)
- [ ] `make lint-shell` → ejecuta análisis de scripts bash
- [ ] `make lint-docs` → detecta líneas largas en archivos .md
- [ ] `make lint` → ejecuta los tres lint y reporta resultado final
- [ ] Si una herramienta no está instalada, el target muestra advertencia pero no aborta
- [ ] `make help` → lista todos los targets

## Reto extra

Agrega `lint-makefile` que usa `checkmake` (si disponible) o implementa verificaciones básicas propias: detecta targets sin `.PHONY`, TABs vs espacios, targets sin `##`.
