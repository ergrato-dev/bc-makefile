# Lab 02 — Git Hooks desde Make

⏱ Duración estimada: ~60 min

## Objetivo

Implementar un sistema de instalación y gestión de git hooks desde Make, incluyendo hooks `pre-commit` y `pre-push` que ejecutan validaciones automáticas.

## Contexto

Los git hooks son scripts que git ejecuta en momentos clave del flujo (commit, push, merge). Por defecto viven en `.git/hooks/`, que no se versiona. La solución moderna es guardarlos en `scripts/hooks/` (versionado) y apuntar git ahí con `git config core.hooksPath`: nada que copiar, nada que se desactualice, y funciona en worktrees.

**Los hooks son una ayuda, no un control:** `git commit --no-verify` los salta. Cualquier verificación que importe tiene que correr también en CI.

Tres reglas de oro para hooks en Make:
- Los scripts de hook deben ser ejecutables (`chmod +x`)
- `pre-commit` falla rápido (lint, formato) para no bloquear el flujo
- `pre-push` puede ser más lento (tests completos) porque ocurre menos frecuente

## Instrucciones

1. Copia el starter:
   ```bash
   cp -r starter/ mi-lab-02 && cd mi-lab-02
   git init
   git rev-parse --show-toplevel   # debe terminar en /mi-lab-02
   git add . && git commit -m "init"   # el paso 8 necesita un commit previo
   ```
   > [!WARNING]
   > Sin el `git init`, `git config core.hooksPath` modificaría el repositorio
   > del bootcamp, no el del lab. Comprueba `--show-toplevel` antes de seguir.

2. Revisa los scripts de hook disponibles:
   ```bash
   ls scripts/hooks/
   cat scripts/hooks/pre-commit
   ```

3. Implementa `hooks-install`: `chmod +x` a los hooks y `git config core.hooksPath` apuntando a `$(CURDIR)/scripts/hooks`.

4. Implementa `hooks-uninstall` con `git config --unset core.hooksPath`.

5. Implementa `hooks-status`: muestra `core.hooksPath` y si cada hook es ejecutable.

6. Instala los hooks y verifica:
   ```bash
   make hooks-install
   make hooks-status
   ```

7. Prueba que el hook bloquea secretos, incluidos los `.env.*`:
   ```bash
   echo "API_KEY=x" > .env.prod
   git add -f .env.prod
   git commit -m "test"
   # Debe abortar: ERROR: archivo .env en staging...
   git reset .env.prod && rm .env.prod
   ```

8. Comprueba que el hook es solo una ayuda:
   ```bash
   echo "API_KEY=x" > .env.prod && git add -f .env.prod
   git commit --no-verify -m "saltado"   # pasa sin ejecutar el hook
   git reset --soft HEAD~1 && git reset .env.prod && rm .env.prod
   ```

9. Implementa `hooks-run-pre-commit` para ejecutar el hook manualmente sin necesidad de hacer commit.

## Criterios de éxito

- [ ] `make hooks-install` → `git config --get core.hooksPath` devuelve la ruta de `scripts/hooks`; imprime `Hooks instalados.`
- [ ] `make hooks-status` → muestra `core.hooksPath` y si cada hook es ejecutable
- [ ] `make hooks-uninstall` → `git config --get core.hooksPath` ya no devuelve nada; imprime `Hooks desinstalados.`
- [ ] Un commit con `.env.prod` o `config/.env.staging` aborta; uno con `.env.example` pasa
- [ ] `make hooks-run-pre-commit` → ejecuta el script de pre-commit y muestra su salida
- [ ] `make help` → lista todos los targets con descripción

## Reto extra

Añade a `pre-commit` una búsqueda de patrones de secreto en el contenido staged (`git diff --cached -U0`), por ejemplo `AKIA[0-9A-Z]{16}` o `-----BEGIN .*PRIVATE KEY-----`.
