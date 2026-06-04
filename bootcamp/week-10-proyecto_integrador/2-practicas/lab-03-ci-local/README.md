# Lab 03 — CI Local con Git Hooks Gestionados por Make

**Duración estimada:** 50 min

## Objetivo

Implementar git hooks `pre-commit` y `pre-push` que se instalan, actualizan y desinstalan desde targets Make, garantizando que el equipo tenga siempre los mismos checks antes de hacer commit o push.

## Contexto

El problema de los git hooks tradicionales: `.git/hooks/` no se versiona. Si un nuevo miembro clona el repo, no tiene los hooks. La solución es versionar los scripts en un directorio `hooks/` del proyecto e instalarlos con `make hooks-install`. El flujo es:

```
hooks/pre-commit  →  make hooks-install  →  .git/hooks/pre-commit
```

El hook invoca `make check` (no tiene lógica propia), así que la lógica vive en el Makefile y puede evolucionar sin reinstalar los hooks.

## Instrucciones

1. Copia el starter:
   ```bash
   cp -r starter/ mi-lab-03 && cd mi-lab-03
   git init  # necesario para tener .git/hooks/
   ```

2. Revisa los scripts de hook en `hooks/`:
   ```bash
   cat hooks/pre-commit
   cat hooks/pre-push
   ```

3. Implementa `hooks-install`:
   ```bash
   make hooks-install
   # Debe copiar hooks/ a .git/hooks/ con chmod +x
   # Debe imprimir: ✓ Hooks instalados en .git/hooks/
   ls -la .git/hooks/pre-commit  # debe existir y ser ejecutable
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
   # Elimina .git/hooks/pre-commit y .git/hooks/pre-push
   ```

7. Implementa `hooks-status`:
   ```bash
   make hooks-status
   # Lista qué hooks están instalados y cuáles no
   ```

## Criterios de éxito

- [ ] `make hooks-install` copia los hooks y los hace ejecutables
- [ ] `make check` ejecuta sin errores con el código del starter
- [ ] Al hacer `git commit`, el hook pre-commit ejecuta `make check` automáticamente
- [ ] Si `make check` falla, el commit es abortado
- [ ] `make hooks-uninstall` elimina los hooks
- [ ] `make hooks-status` muestra el estado de cada hook

## Reto extra

Agrega un target `hooks-update` que reinstale los hooks si la versión en `hooks/` es más nueva que la instalada en `.git/hooks/`, usando timestamps de archivos como dependencia Make.
