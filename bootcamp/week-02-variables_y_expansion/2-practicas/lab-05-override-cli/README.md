# Lab 05 — Override desde CLI

⏱ Duración estimada: ~50 min

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

## Criterios de éxito

- [ ] `make info` muestra los cuatro valores con defaults
- [ ] `make info ENV=prod VERSION=1.5.0` muestra `IMAGE_TAG: registry.local/myapp:1.5.0-prod`
- [ ] `make build ENV=staging` imprime el tag correcto con `staging`
- [ ] `make deploy ENV=prod` ejecuta `build` primero (dependencia) con el entorno correcto
- [ ] `make help` funciona

## Reto extra

Investiga el comportamiento de `override`. Agrega al starter:
```makefile
override FORCE_ENV := dev
```
Verifica que `make info FORCE_ENV=prod` sigue mostrando `dev`. Explica en un comentario cuándo tiene sentido usar `override` en un proyecto real.
