# Lab 03 — CI Local con Git Hooks Gestionados por Make

⏱ Duración estimada: ~60 min

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

1. Copia el starter **sin** ejecutar todavía `git init`:
   ```bash
   cp -r starter/ mi-lab-03 && cd mi-lab-03
   git rev-parse --show-toplevel   # la raíz del repo del bootcamp, no mi-lab-03
   ```

   > [!WARNING]
   > Ahora mismo `git config core.hooksPath ...` escribiría en el repositorio del
   > bootcamp, y todos tus commits allí pasarían a ejecutar estos hooks. El primer
   > TODO es una guarda que lo impide.

2. Revisa los scripts de `hooks/`. No tienen lógica: solo `exec make -C ... check`.
   ```bash
   cat hooks/pre-commit hooks/pre-push
   ```

3. Implementa la guarda de `hooks-install` (paso 0 del TODO) y compruébala
   antes de crear el repositorio:
   ```bash
   make hooks-install; echo "exit=$?"
   # ✗ .../mi-lab-03 no es la raíz de un repositorio git (raíz actual: .../bc-makefile). Ejecuta git init aquí.
   # exit=2
   ```

4. Crea el repositorio del lab y completa `hooks-install`:
   ```bash
   git init
   make hooks-install                # ✓ Hooks activos desde <ruta>/hooks
   git config --get core.hooksPath   # <ruta>/mi-lab-03/hooks
   ```

5. Implementa `check` y el primer commit:
   ```bash
   make check                        # ✓ Checks OK
   git add . && git commit -m "init" # el hook imprime ✓ Checks OK antes del commit
   ```

6. Rompe el check y comprueba que el commit se aborta:
   ```bash
   printf '# comentario con espacio final \n' >> Makefile
   git add . && git commit -m "roto"; echo "exit=$?"
   # Makefile:NN:# comentario con espacio final
   # ✗ Trailing whitespace encontrado
   # exit=1
   ```

7. Salta el hook y mira por qué no es un control:
   ```bash
   git commit -m "roto" --no-verify; echo "exit=$?"   # exit=0
   git log --oneline                                  # 2 commits
   ```
   El commit roto ya está en el historial. Lo único que lo pararía es el mismo
   `make check` dentro de `make ci` en el runner de CI. Deshazlo con
   `git reset --hard HEAD~1`.

8. Implementa `hooks-status` y `hooks-uninstall`:
   ```bash
   make hooks-status                 # core.hooksPath y ✓ pre-commit ejecutable, ✓ pre-push ejecutable
   make hooks-uninstall
   git config --get core.hooksPath; echo "exit=$?"   # exit=1: ya no hay hooks
   ```

## Criterios de éxito

- [ ] Sin `git init`, `make hooks-install` sale con error y no cambia la configuración de ningún repositorio
- [ ] `make hooks-install` configura `core.hooksPath` y deja los hooks ejecutables
- [ ] `make check` ejecuta sin errores con el código del starter
- [ ] Al hacer `git commit`, el hook pre-commit ejecuta `make check` automáticamente
- [ ] Con un espacio final en el `Makefile`, el commit se aborta; con `--no-verify`, no
- [ ] `make hooks-uninstall` elimina `core.hooksPath`
- [ ] `make hooks-status` muestra el estado de cada hook

## Reto extra

Haz que `pre-push` ejecute `make ci` en lugar de `make check`, y mide con `time` cuánto tarda. Si pasa de 30 segundos, decide qué checks mover solo a CI.
