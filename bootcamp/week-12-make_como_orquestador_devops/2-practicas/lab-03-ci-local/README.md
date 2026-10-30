# Lab 03 — Pipeline CI/CD Local

**Duración estimada:** 50 min

## Objetivo

Construir un pipeline CI/CD local completo con Make que ejecute lint → test → build → report en secuencia, abortando en la primera etapa que falle.

## Contexto

Un pipeline CI/CD es una secuencia de etapas donde cada una depende del éxito de la anterior. En Make esto se modela con dependencias entre targets:

```makefile
ci: lint test build report
```

Si `lint` falla (exit code ≠ 0), Make aborta y nunca ejecuta `test`. Esto es exactamente el comportamiento que queremos: fail fast, fail loud.

La diferencia entre `make ci` local y el CI remoto (GitHub Actions, GitLab CI) es solo la infraestructura de ejecución. El Makefile puede ser idéntico.

## Instrucciones

1. Copia el starter:
   ```bash
   cp -r starter/ mi-lab-03 && cd mi-lab-03
   ```

2. Instala las dependencias de Python:
   ```bash
   make install   # uv sync --locked: flake8, pytest y pytest-cov del grupo dev
   ```

3. Examina la estructura del proyecto:
   ```bash
   ls src/ tests/
   cat src/calculadora.py
   ```

4. Implementa el target `lint` que ejecuta `flake8` sobre `src/`.

5. Implementa el target `test` que ejecuta `pytest` con cobertura.

6. Implementa el target `build` que crea un archivo `dist/calculadora.tar.gz` con los fuentes.

7. Implementa el target `report` que imprime un resumen del pipeline.

8. Implementa el target `ci` que encadena todo en secuencia.

9. Ejecuta el pipeline completo:
   ```bash
   make ci
   ```

10. Introduce un error de lint en `src/calculadora.py` y verifica que el pipeline aborta:
    ```bash
    echo "x=1+2" >> src/calculadora.py  # sin espacios = error flake8
    make ci
    # Debe abortar en lint, nunca llegar a test
    ```

## Criterios de éxito

- [ ] `make lint` → ejecuta flake8, sale con 0 si no hay errores
- [ ] `make test` → ejecuta pytest con cobertura, imprime resumen de tests
- [ ] `make build` → crea `dist/calculadora.tar.gz`
- [ ] `make report` → imprime resumen: versión, fecha, resultado de cada etapa
- [ ] `make ci` con código limpio → ejecuta todas las etapas y termina con `✓ CI OK`
- [ ] `make ci` con error de lint → aborta después de `lint`, nunca ejecuta `test`
- [ ] `make help` → lista todos los targets

## Reto extra

Agrega un target `ci-fast` que ejecuta solo lint y test (sin build ni report) para feedback más rápido durante desarrollo.
