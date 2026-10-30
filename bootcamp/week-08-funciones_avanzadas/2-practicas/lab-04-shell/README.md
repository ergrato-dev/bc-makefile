# Lab 04 — shell

**Duración estimada:** 50 minutos

## Objetivo

Capturar información del sistema operativo con `$(shell)` para generar metadatos de build reproducibles y trazables.

## Contexto

Un build reproducible necesita saber cuándo se compiló, desde qué commit y en qué entorno. Esa información no está en el código — está en el sistema. El `starter/Makefile` tiene todos los metadatos hardcodeados como `UNKNOWN` o `0`.

`$(shell cmd)` ejecuta `cmd` en el shell y captura su stdout como string:

```makefile
GIT_HASH   := $(shell git rev-parse --short HEAD 2>/dev/null || echo sin-git)
BUILD_DATE := $(shell date +%Y-%m-%dT%H:%M:%S)
NUM_CPUS   := $(shell nproc 2>/dev/null || sysctl -n hw.ncpu 2>/dev/null || echo 1)
```

Puntos clave:
- `$(shell)` se evalúa en el momento en que Make carga el Makefile, no cuando se ejecuta la receta
- Si el comando falla, la variable queda vacía — siempre incluye un fallback con `|| echo valor`
- `2>/dev/null` redirige stderr a null para silenciar errores esperados

## Instrucciones

1. Entra al directorio starter:
   ```bash
   cd lab-04-shell/starter
   ```

2. Ejecuta `make info` y observa los valores `UNKNOWN`:
   ```bash
   make info
   ```

3. Implementa los 5 TODOs del Makefile:
   - **TODO 1:** `GIT_HASH` — hash corto de git con fallback `sin-git`
   - **TODO 2:** `BUILD_DATE` — fecha ISO completa con `date +%Y-%m-%dT%H:%M:%S`
   - **TODO 3:** `OS_NAME` — nombre del OS con `uname -s`
   - **TODO 4:** `NUM_CPUS` — número de CPUs (portable: `nproc` en Linux, `sysctl -n hw.ncpu` en macOS)
   - **TODO 5:** `MAKE_VERSION_STR` — primera línea de `$(MAKE) --version`

4. Verifica:
   ```bash
   make info
   make version
   cat build/version.txt
   ```

## Criterios de éxito

```
$ make info
=== Build Info ===
Git Hash:     a3f1b2c
Build Date:   2026-06-04T14:30:00
OS:           Linux
CPUs:         8
Make:         GNU Make 4.3
```

(Los valores exactos varían según el entorno — lo importante es que no sean `UNKNOWN`.)

```
$ make version
Generado: build/version.txt
version: git-a3f1b2c
date: 2026-06-04T14:30:00
os: Linux
cpus: 8
```

## Reto extra

Agrega `DISK_FREE` que captura el espacio libre en `/` con `df -h / | tail -1 | awk '{print $4}'`. Muéstralo en `make info` e inclúyelo en `build/version.txt`.
