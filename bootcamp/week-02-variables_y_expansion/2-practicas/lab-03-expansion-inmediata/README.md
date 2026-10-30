# Lab 03 — Expansión inmediata con $(shell ...)

⏱ Duración estimada: ~60 min

## Objetivo

Usar `:=` con `$(shell ...)` para capturar valores de comandos de shell exactamente una vez al cargar el Makefile, y entender por qué `=` con `$(shell ...)` puede producir comportamientos inesperados.

## Contexto

Cuando combinas `$(shell ...)` con `=`, Make re-ejecuta el comando de shell cada vez que la variable se expande. Con `:=`, el comando se ejecuta una sola vez al cargar el archivo.

```makefile
# Con = : date se ejecuta cada vez que se usa TIMESTAMP
TIMESTAMP  = $(shell date +%T)

# Con := : date se ejecuta UNA sola vez al cargar el Makefile
START_TIME := $(shell date +%T)
```

En la práctica, capturar el hash de git, la fecha de build, o la versión del compilador debe hacerse con `:=` para garantizar consistencia durante toda la ejecución.

## Instrucciones

1. Abre `starter/Makefile`.

2. Define `TIMESTAMP_LAZY` con `=` capturando `$(shell date +%T)`.

3. Define `TIMESTAMP_EAGER` con `:=` capturando `$(shell date +%T)`.

4. Define `GIT_HASH` con `:=` capturando el hash corto del commit actual:
   ```makefile
   GIT_HASH := $(shell git rev-parse --short HEAD 2>/dev/null || echo "no-git")
   ```

5. Define `VERSION` con `:=` construyendo `"0.1.0-$(GIT_HASH)"`.

6. Completa los tres targets y verifica:
   ```bash
   make comparar
   make git-info
   ```

7. Observa que en `comparar`, ambas lecturas de `TIMESTAMP_EAGER` son iguales. Las de `TIMESTAMP_LAZY` casi siempre también, porque las dos llamadas a `date` ocurren en el mismo segundo. Hazlo visible: cambia **solo** `TIMESTAMP_LAZY` a `$(shell sleep 1; date +%T)` y repite `make comparar`. Ahora las dos lecturas lazy se separan un segundo y `make comparar` tarda varios segundos: cada uso relanza la shell. Las lecturas eager siguen idénticas. Deja la variable como estaba.

8. **`!=`: la shell al asignar.** `VAR != comando` ejecuta el comando una sola vez, al leer la línea, como `:= $(shell ...)`. Completa los TODO del paso 8 y ejecuta:
   ```bash
   make asignar-shell
   ```
   Debes ver (con tu sistema operativo en `KERNEL`):
   ```
   KERNEL:       Linux [recursive]
   PRECIO_BANG:  cuesta  [recursive]
   PRECIO_SHELL: cuesta $5 [simple]
   ```
   Las dos variables de precio ejecutan el mismo comando y reciben la misma salida, `cuesta $5`. Pero `!=` guarda el resultado en una variable **recursiva**: al usarla, Make expande `$5` (una variable que no existe) y queda vacío. `:=` guarda el texto final y no lo vuelve a tocar. Regla práctica: si la salida del comando puede contener `$`, usa `:= $(shell ...)`.

## Criterios de éxito

- [ ] `make comparar` imprime cuatro líneas: dos de `TIMESTAMP_LAZY` y dos de `TIMESTAMP_EAGER`
- [ ] Las dos líneas de `TIMESTAMP_EAGER` son **siempre idénticas** (capturado una vez)
- [ ] Con `sleep 1` en `TIMESTAMP_LAZY`, sus dos lecturas difieren en un segundo
- [ ] `make git-info` imprime el hash corto y la versión construida a partir de él
- [ ] `make git-info` sin git inicializado imprime `"no-git"` en lugar de error
- [ ] `make asignar-shell` muestra `PRECIO_BANG` sin el `$5` y `PRECIO_SHELL` con él
- [ ] `make help` funciona

## Reto extra

Agrega una variable `COMPILER_VERSION` con `:=` que capture `$(shell $(CC) --version | head -1)`. Crea un target `build-info` que imprima fecha, hash de git, versión del compilador y versión del proyecto. Úsalo como primera línea de salida en cualquier target `build`.
