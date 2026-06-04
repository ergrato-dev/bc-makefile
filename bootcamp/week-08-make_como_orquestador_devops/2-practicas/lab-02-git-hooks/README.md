# Lab 02 — Git Hooks desde Make

**Duración estimada:** 50 min

## Objetivo

Implementar un sistema de instalación y gestión de git hooks desde Make, incluyendo hooks `pre-commit` y `pre-push` que ejecutan validaciones automáticas.

## Contexto

Los git hooks son scripts en `.git/hooks/` que git ejecuta en momentos clave del flujo (commit, push, merge). El problema es que `.git/` no se commitea, así que cada desarrollador necesita instalarlos manualmente. La solución es guardar los scripts en `scripts/hooks/` (que sí se commitea) e instalarlos con `make hooks-install`.

Tres reglas de oro para hooks en Make:
- Los scripts de hook deben ser ejecutables (`chmod +x`)
- `pre-commit` falla rápido (lint, formato) para no bloquear el flujo
- `pre-push` puede ser más lento (tests completos) porque ocurre menos frecuente

## Instrucciones

1. Copia el starter:
   ```bash
   cp -r starter/ mi-lab-02 && cd mi-lab-02
   git init
   ```

2. Revisa los scripts de hook disponibles:
   ```bash
   ls scripts/hooks/
   cat scripts/hooks/pre-commit
   ```

3. Implementa `hooks-install` para copiar los hooks a `.git/hooks/` y hacerlos ejecutables.

4. Implementa `hooks-uninstall` para eliminar los hooks instalados.

5. Implementa `hooks-status` para verificar qué hooks están instalados y si son ejecutables.

6. Instala los hooks y verifica:
   ```bash
   make hooks-install
   make hooks-status
   ```

7. Prueba que el hook funciona:
   ```bash
   echo "x = 1" > test.py
   git add test.py
   git commit -m "test"
   # El pre-commit debe ejecutarse
   ```

8. Implementa `hooks-run-pre-commit` para ejecutar el hook manualmente sin necesidad de hacer commit.

## Criterios de éxito

- [ ] `make hooks-install` → copia los scripts a `.git/hooks/` con permisos ejecutables, imprime `Hooks instalados.`
- [ ] `make hooks-status` → muestra una tabla con nombre del hook, si existe y si es ejecutable
- [ ] `make hooks-uninstall` → elimina los hooks instalados, imprime `Hooks desinstalados.`
- [ ] `make hooks-run-pre-commit` → ejecuta el script de pre-commit y muestra su salida
- [ ] `make help` → lista todos los targets con descripción

## Reto extra

Agrega soporte para múltiples repos en monorepo: `make hooks-install SUBDIR=backend` instala los hooks específicos de `backend/scripts/hooks/`.
