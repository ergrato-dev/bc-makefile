# Lab 03 — CI Local con Git Hooks Gestionados por Make

**Duración estimada:** 60 min

## Objetivo

Implementar git hooks `pre-commit` y `pre-push` que se instalan, actualizan y desinstalan desde targets Make, garantizando que el equipo tenga siempre los mismos checks antes de hacer commit o push.

## Contexto

Repaso de la semana 12: los hooks se versionan en `hooks/` y git los lee de ahí con `core.hooksPath`. Aquí el foco es el **CI local**: el hook no tiene lógica propia, solo llama a `make check`, así que el mismo target corre en tu máquina y en el pipeline.

```
git commit  →  hooks/pre-commit  →  make -C <proyecto> check
```

`git commit --no-verify` salta el hook. Por eso `make check` tiene que correr también en CI.

El hook invoca `make check` (no tiene lógica propia), así que la lógica vive en el Makefile y puede evolucionar sin reinstalar los hooks.

## Instrucciones

1. Copia el starter:
   ```bash
   cp -r starter/ mi-lab-03 && cd mi-lab-03
   git init
   ```

2. Revisa los scripts de hook en `hooks/`:
   ```bash
   cat hooks/pre-commit
   cat hooks/pre-push
   ```

3. Implementa `hooks-install`:
   ```bash
   make hooks-install
   # Debe imprimir: ✓ Hooks activos desde <ruta>/hooks
   git config --get core.hooksPath   # la ruta de hooks/
   ```

4. Implementa el target `check` que el hook invoca:
   ```bash
   make check
   # Debe ejecutar lint y una comprobación básica
   ```

5. Prueba que el hook funciona:
   ```bash
   git add .
   git commit -m "test"
   # El hook debe ejecutar make check antes de crear el commit
   ```

6. Implementa `hooks-uninstall`:
   ```bash
   make hooks-uninstall
   git config --get core.hooksPath   # ya no devuelve nada
   ```

7. Implementa `hooks-status`:
   ```bash
   make hooks-status
   # Muestra core.hooksPath y si cada hook es ejecutable
   ```

## Criterios de éxito

- [ ] `make hooks-install` configura `core.hooksPath` y deja los hooks ejecutables
- [ ] `make check` ejecuta sin errores con el código del starter
- [ ] Al hacer `git commit`, el hook pre-commit ejecuta `make check` automáticamente
- [ ] Si `make check` falla, el commit es abortado
- [ ] `make hooks-uninstall` elimina `core.hooksPath`
- [ ] `make hooks-status` muestra el estado de cada hook

## Reto extra

Haz que `pre-push` ejecute `make ci` en lugar de `make check`, y mide con `time` cuánto tarda. Si pasa de 30 segundos, decide qué checks mover solo a CI.
