# Lab 05 — Override desde CLI

⏱ Duración estimada: ~60 min

## Objetivo

Parametrizar un Makefile de build pasando múltiples variables desde la línea de comandos y entender la diferencia de precedencia entre `?=`, `=`/`:=` y argumentos CLI.

## Contexto

Cualquier variable se puede sobreescribir desde CLI con `make VAR=valor`. Los argumentos CLI tienen mayor precedencia que `=`, `:=` y `?=`, pero no superan a `override`:

```bash
make ENV=prod VERSION=2.1.0 REGISTRY=hub.docker.com deploy
```

Esto es el patrón más común para Makefiles de CI/CD: el pipeline pasa variables de entorno y versión; el Makefile tiene defaults razonables para desarrollo local.

Una trampa frecuente: si `IMAGE_TAG` se define con `:=` construido a partir de `ENV` y `VERSION`, y esos valores llegan por CLI, funciona correctamente porque los argumentos CLI se aplican antes de que el Makefile sea procesado.

## Instrucciones

1. Abre `starter/Makefile`.

2. Define estas variables con `?=`:
   - `ENV` → `"dev"`
   - `VERSION` → `"0.1.0"`
   - `REGISTRY` → `"registry.local"`
   - `APP_NAME` → `"myapp"`

3. Define `IMAGE_TAG` con `=` (no `:=`) construyendo `"$(REGISTRY)/$(APP_NAME):$(VERSION)-$(ENV)"`.
   *(Con `=`, `IMAGE_TAG` sigue a `ENV` y `VERSION` aunque cambien después de esta línea. Los overrides CLI funcionarían también con `:=`, como explica el Contexto.)*

4. Completa los targets `info`, `build` y `deploy`.

5. Verifica los escenarios:
   ```bash
   make info                                        # defaults
   make info ENV=staging VERSION=1.0.0             # override dos vars
   make build ENV=prod VERSION=2.0.0 REGISTRY=hub.docker.com
   make deploy ENV=prod VERSION=2.0.0
   ```

6. **Diagnóstico con `$(origin)`.** Añade a `info` la línea
   `Origen de ENV: $(origin ENV)` y comprueba los tres casos:
   ```bash
   make info | tail -1                # Origen de ENV: file
   ENV=qa make info | tail -1         # Origen de ENV: environment
   make info ENV=prod | tail -1       # Origen de ENV: command line
   ```
   Cuando un pipeline "despliega en el entorno equivocado", esta línea te dice
   en un segundo si el valor vino del CI (línea de comandos), de la máquina
   (entorno) o del default del Makefile.

7. **Flags obligatorios con `override`.** El equipo exige que todo build use
   `--pull`, pero quiere poder añadir otros flags. Completa el TODO del paso 7:
   ```makefile
   BUILD_FLAGS ?=
   override BUILD_FLAGS += --pull
   ```
   y añade `Flags: $(BUILD_FLAGS)` a `build`. Verifica:
   ```bash
   make build | grep Flags                         #   Flags: --pull
   make build BUILD_FLAGS=--no-cache | grep Flags  #   Flags: --no-cache --pull
   ```

8. Quita la palabra `override` y repite el segundo comando: ahora sale
   `Flags: --no-cache` y `--pull` se perdió. Una variable que llega por la
   línea de comandos hace que Make **ignore** las asignaciones normales del
   Makefile, `+=` incluido; `override` es la única forma de que el Makefile
   añada algo encima. Vuelve a poner `override`.

## Criterios de éxito

- [ ] `make info` muestra los cuatro valores con defaults
- [ ] `make info ENV=prod VERSION=1.5.0` muestra `IMAGE_TAG: registry.local/myapp:1.5.0-prod`
- [ ] `make build ENV=staging` imprime el tag correcto con `staging`
- [ ] `make deploy ENV=prod` ejecuta `build` primero (dependencia) con el entorno correcto
- [ ] `make info` muestra `Origen de ENV:` con `file`, `environment` o `command line` según cómo pases `ENV`
- [ ] `make build BUILD_FLAGS=--no-cache` imprime `Flags: --no-cache --pull`
- [ ] Sin `override`, puedes explicar por qué `--pull` desaparece
- [ ] `make help` funciona

## Reto extra

Ejecuta `ENV=qa make -e info`. Con `ENV ?= dev` no cambia nada, pero añade
temporalmente `ENV := dev` y compara `ENV=qa make info` con
`ENV=qa make -e info`. ¿Qué fila de la tabla de precedencia de
[02-origen-y-precedencia.md](../../1-teoria/02-origen-y-precedencia.md) mueve
`-e`, y por qué es mala idea usarlo en vez de `?=`?
