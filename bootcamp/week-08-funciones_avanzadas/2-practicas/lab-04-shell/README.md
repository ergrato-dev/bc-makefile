# Lab 04 — shell

⏱ Duración estimada: ~60 min

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
- Coste, seguridad y `$(file)` como alternativa sin shell: [02-file-value-let-intcmp.md](../../1-teoria/02-file-value-let-intcmp.md)

## Instrucciones

1. Entra al directorio starter:
   ```bash
   cd lab-04-shell/starter
   ```

2. Ejecuta `make info` y observa los valores `UNKNOWN`:
   ```bash
   make info
   ```

3. Implementa los TODOs 1 a 5 del Makefile:
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

5. `=` frente a `:=` con `$(shell)` (TODO 6). Define `STAMP_LAZY` con `=` y `STAMP_NOW` con `:=`, ambas con `$(shell date +%s%N)`, y ejecuta:
   ```bash
   make stamps
   ```
   Debes ver dos números **distintos** en la línea de `=` y dos **iguales** en la de `:=`:
   ```
   Con =  : 1793349077409264485 1793349077411066751
   Con := : 1793349077406599838 1793349077406599838
   ```
   Con `=` el shell se lanza en cada referencia. Ahora mide el coste en la fase de lectura: añade temporalmente `SLOW := $(shell sleep 1; echo x)` y ejecuta `time make -n help`. Tarda ~1 s aunque `-n` no ejecuta nada y `help` no usa `SLOW`. Quita la línea.

6. Escribe y lee un archivo sin shell (TODOs 7 y 8). Implementa `build/version.mk` con `$(file >...)` y `$(file >>...)`, y `version-mk` con `$(file <...)`:
   ```bash
   make clean
   make version-mk
   cat build/version.mk
   make -s -f build/version.mk --eval 'x: ; @echo $(OS_NAME)' x
   ```
   Debes ver (con tus valores):
   ```
   Generado: build/version.mk
   Leído: GIT_HASH := a3f1b2c BUILD_DATE := 2026-06-04T14:30:00 OS_NAME := Linux
   GIT_HASH := a3f1b2c
   BUILD_DATE := 2026-06-04T14:30:00
   OS_NAME := Linux
   Linux
   ```
   El último comando prueba que lo que escribiste es un Makefile válido: Make lo lee y encuentra `OS_NAME`. Prueba a mover el `mkdir` a la receta en lugar del prerrequisito `| $(BUILD)` tras un `make clean`: falla con `open: build/version.mk: No such file or directory`, porque Make expande `$(file ...)` antes de ejecutar la primera línea.

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

- [ ] `make stamps` muestra dos valores distintos con `=` y dos iguales con `:=`
- [ ] `make version-mk` crea `build/version.mk` sin `printf` ni `echo`, y `make -s -f build/version.mk --eval 'x: ; @echo $(OS_NAME)' x` imprime el sistema operativo
- [ ] `make clean` elimina `build/`

## Reto extra

Agrega `DISK_FREE` que captura el espacio libre en `/` con `df -h / | tail -1 | awk '{print $4}'`. Muéstralo en `make info` e inclúyelo en `build/version.txt`.
