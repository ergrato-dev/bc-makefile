# Lab 03 — Expansión inmediata con $(shell ...)

⏱ Duración estimada: ~50 min

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

7. Observa que en `comparar`, ambas lecturas de `TIMESTAMP_EAGER` son iguales, mientras que `TIMESTAMP_LAZY` puede diferir (el shell se invoca dos veces).

## Criterios de éxito

- [ ] `make comparar` imprime cuatro líneas: dos de `TIMESTAMP_LAZY` y dos de `TIMESTAMP_EAGER`
- [ ] Las dos líneas de `TIMESTAMP_EAGER` son **siempre idénticas** (capturado una vez)
- [ ] `make git-info` imprime el hash corto y la versión construida a partir de él
- [ ] `make git-info` sin git inicializado imprime `"no-git"` en lugar de error
- [ ] `make help` funciona

## Reto extra

Agrega una variable `COMPILER_VERSION` con `:=` que capture `$(shell $(CC) --version | head -1)`. Crea un target `build-info` que imprima fecha, hash de git, versión del compilador y versión del proyecto. Úsalo como primera línea de salida en cualquier target `build`.
