# Lab 01 — Condicionales en Make

**Duración estimada:** 50 min

## Objetivo

Implementar condicionales `ifeq`, `ifneq`, `ifdef` y `ifndef` para que un único Makefile adapte su comportamiento según el entorno (`development`, `staging`, `production`) y la presencia de variables de CI.

## Contexto

Un Makefile que hardcodea valores para un entorno obliga al equipo a mantener múltiples archivos paralelos. Los condicionales de Make resuelven esto en el mismo archivo:

- `ifeq` / `ifneq` comparan el **valor** de una variable
- `ifdef` / `ifndef` comprueban si una variable está **definida** (aunque esté vacía)
- Los condicionales se evalúan al **parsear** — antes de ejecutar cualquier target

El patrón típico es definir variables con `?=` como default y luego sobreescribir bloques con condicionales según el entorno.

## Instrucciones

1. Copia el starter:
   ```bash
   cp -r starter/ mi-lab-01 && cd mi-lab-01
   ```

2. Explora el Makefile y los TODOs:
   ```bash
   cat Makefile
   ```

3. Implementa el bloque condicional que selecciona `BUILD_FLAGS` según `ENV`:
   ```bash
   make info ENV=development
   make info ENV=production
   make info ENV=staging
   ```

4. Implementa la detección de entorno CI:
   ```bash
   CI=true make info
   ```

5. Implementa el target `build` que usa las variables del entorno activo:
   ```bash
   make build ENV=production
   ```

6. Implementa `deploy` que falla con `$(error ...)` si `ENV` es `development`:
   ```bash
   make deploy ENV=development  # debe fallar con error claro
   make deploy ENV=production   # debe funcionar
   ```

## Criterios de éxito

- [ ] `make info ENV=development` → imprime `ENV=development`, `BUILD_FLAGS=--debug`
- [ ] `make info ENV=production` → imprime `ENV=production`, `BUILD_FLAGS=--release`
- [ ] `make info ENV=staging` → imprime `ENV=staging`, `BUILD_FLAGS=--release`
- [ ] `CI=true make info` → imprime `Modo CI activado — paralelo habilitado`
- [ ] `make build ENV=production` → imprime `Compilando con --release`
- [ ] `make deploy ENV=development` → falla con `ERROR: deploy no permitido en development`
- [ ] `make deploy ENV=production` → imprime `Desplegando en production`

## Reto extra

Agrega un condicional `ifndef VERSION` que asigne `VERSION` automáticamente con `$(shell git describe --tags --always 2>/dev/null || echo 0.0.0)` solo si no fue definida por el usuario.
