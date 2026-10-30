# Lab 04 — Scope de Variables en Make Recursivo

**Duración estimada:** 50 min

## Objetivo

Demostrar y controlar qué variables hereda un submake del proceso padre, usando `export`, `unexport`, paso explícito en línea de comando y `override`.

## Contexto

Las variables de Make **no** se heredan automáticamente entre procesos Make padre e hijo. Solo se propagan:

1. Variables del entorno del shell (las que ya estaban en el ambiente antes de invocar Make)
2. Variables pasadas explícitamente: `$(MAKE) -C sub ENV=$(ENV)`
3. Variables marcadas con `export` en el Makefile padre

Esto es intencional: cada submake debe ser autónomo. Pero a veces necesitas propagar configuración (como `ENV` o `VERSION`) de forma controlada. El target `override` permite que el submake acepte valores del CLI incluso si el Makefile hijo ya define la variable.

## Instrucciones

1. Copia el starter:
   ```bash
   cp -r starter/ mi-lab-04 && cd mi-lab-04
   ```

2. Ejecuta sin configuración y observa qué variables llegan al submake:
   ```bash
   make show-scope
   ```

3. Implementa `export` para `SHARED_VAR` y verifica que ahora llega al hijo:
   ```bash
   make show-scope
   ```

4. Implementa el paso explícito de `ENV` al submake:
   ```bash
   make show-scope ENV=production
   ```

5. Implementa `unexport` para `SECRET_VAR` y verifica que no llega al hijo:
   ```bash
   SECRET_VAR=supersecret make show-scope
   ```

6. Implementa el target `override-demo` que pasa `VERSION` al hijo con override:
   ```bash
   make override-demo VERSION=9.9.9
   ```

## Criterios de éxito

- [ ] `make show-scope` sin nada → submake imprime `ENV=development`, `SHARED_VAR=valor-compartido`
- [ ] `make show-scope ENV=production` → submake imprime `ENV=production`
- [ ] `SECRET_VAR=supersecret make show-scope` → submake imprime `SECRET_VAR=` (vacío, no heredado)
- [ ] `make override-demo VERSION=9.9.9` → submake imprime `VERSION=9.9.9`
- [ ] `make help` → lista todos los targets

## Reto extra

Usa `$(MAKE) -e` para forzar que las variables del entorno tengan prioridad sobre las del Makefile hijo. Documenta con `$(info)` qué pasa cuando usas `-e` vs sin él.
