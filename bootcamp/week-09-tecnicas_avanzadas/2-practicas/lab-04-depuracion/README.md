# Lab 04 — Depuración de Makefiles

**Duración estimada:** 50 min

## Objetivo

Usar las herramientas de depuración de Make (`--debug`, `$(info)`, `$(warning)`, `$(error)`, `make -n`, `make -p`) para diagnosticar por qué un Makefile no se comporta como se espera.

## Contexto

Make toma decisiones silenciosamente: reconstruye un target o no basándose en timestamps, evalúa variables al parsear, expande recursivamente. Cuando algo falla o no se reconstruye cuando debería, no hay un stack trace. Las herramientas de depuración de Make son:

- `make -n` — dry-run: muestra los comandos sin ejecutarlos
- `make --debug=b` — muestra qué targets se reconstruyen y por qué
- `make --debug=v` — traza completa: todas las decisiones de dependencias
- `$(info texto)` — imprime durante el parsing (útil para ver valores de variables)
- `$(warning texto)` — como `$(info)` pero a stderr, incluye archivo y línea
- `$(error texto)` — detiene Make con error fatal (útil para validaciones)
- `make -p` — imprime la base de datos completa de Make (variables y reglas)

## Instrucciones

1. Copia el starter:
   ```bash
   cp -r starter/ mi-lab-04 && cd mi-lab-04
   ```

2. Ejecuta el dry-run y observa qué comandos se ejecutarían:
   ```bash
   make -n build
   ```

3. Implementa el target `debug-vars` que imprime todas las variables clave con `$(info)`:
   ```bash
   make debug-vars
   ```

4. Implementa el target `debug-deps` que muestra las dependencias usando `--debug=b`:
   ```bash
   make debug-deps
   ```

5. Implementa el target `validate` que usa `$(error ...)` para fallar si `APP_NAME` está vacía:
   ```bash
   make validate APP_NAME=
   make validate APP_NAME=mi-app
   ```

6. Implementa el target `debug-all` que ejecuta todos los diagnósticos:
   ```bash
   make debug-all
   ```

7. Usa `make -p` para ver la base de datos de Make y cuenta cuántas reglas existen:
   ```bash
   make -p 2>/dev/null | grep -c "^[a-zA-Z].*:$"
   ```

## Criterios de éxito

- [ ] `make -n build` → imprime comandos sin ejecutarlos
- [ ] `make debug-vars` → imprime APP_NAME, ENV, VERSION, MAKEFILE_LIST con `$(info)`
- [ ] `make validate APP_NAME=` → falla con `ERROR: APP_NAME no puede estar vacía`
- [ ] `make validate APP_NAME=mi-app` → imprime `Validación OK`
- [ ] `make debug-all` → ejecuta todos los diagnósticos sin errores
- [ ] `make --debug=b build` → muestra la decisión de reconstrucción

## Reto extra

Crea un target `why-rebuild` que crea un archivo `build/output`, luego modifica una dependencia y usa `--debug=b` para mostrar exactamente por qué Make decide reconstruir.
