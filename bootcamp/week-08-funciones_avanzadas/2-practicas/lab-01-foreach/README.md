# Lab 01 — foreach

**Duración estimada:** 50 minutos

## Objetivo

Reemplazar listas hardcodeadas y targets duplicados por iteración dinámica con `$(foreach)`.

## Contexto

Tu equipo despliega una aplicación en tres entornos (`dev`, `staging`, `prod`) y tres regiones (`us-east`, `eu-west`, `ap-south`). El Makefile actual tiene rutas y targets escritos a mano: cada vez que se agrega un entorno hay que actualizar el archivo en varios lugares.

`$(foreach var,list,text)` resuelve esto: expande `text` una vez por cada palabra de `list`, sustituyendo `$(var)` por cada elemento. El resultado es una cadena de texto concatenada.

```makefile
# $(foreach env,dev staging prod,deploy/$(env)) → deploy/dev deploy/staging deploy/prod
```

Dentro de una receta, `$(foreach)` genera múltiples comandos shell separados por `;`:

```makefile
dirs:
	@$(foreach dir,$(DEPLOY_DIRS),mkdir -p $(dir);)
```

## Instrucciones

1. Entra al directorio starter:
   ```bash
   cd lab-01-foreach/starter
   ```

2. Ejecuta el estado inicial para ver el punto de partida:
   ```bash
   make demo
   make help
   ```

3. Implementa los 5 TODOs del `Makefile`:
   - **TODO 1:** `DEPLOY_DIRS` con `$(foreach env,$(ENVS),deploy/$(env))`
   - **TODO 2:** `ENV_FLAGS` con `$(foreach env,$(ENVS),-DENV_$(env))`
   - **TODO 3:** `DEPLOY_MATRIX` con `$(foreach)` anidado sobre `$(REGIONS)` y `$(ENVS)`
   - **TODO 4:** receta de `dirs` usando `$(foreach)` para crear cada directorio
   - **TODO 5:** receta de `report` usando `$(foreach)` para imprimir cada entorno

4. Verifica cada target:
   ```bash
   make demo
   make dirs
   make report
   make clean
   ```

## Criterios de éxito

```
$ make demo
DEPLOY_DIRS:   deploy/dev deploy/staging deploy/prod
ENV_FLAGS:     -DENV_dev -DENV_staging -DENV_prod
DEPLOY_MATRIX: us-east-dev us-east-staging us-east-prod eu-west-dev eu-west-staging eu-west-prod ap-south-dev ap-south-staging ap-south-prod
Combinaciones: 9
```

```
$ make dirs
Directorios creados: deploy/dev deploy/staging deploy/prod

$ ls deploy/
dev  prod  staging
```

```
$ make report
=== Reporte de entornos ===
  - dev → deploy/dev
  - staging → deploy/staging
  - prod → deploy/prod
Total: 3 entornos
```

## Reto extra

Agrega una variable `SERVICES := api worker monitor` y genera `DEPLOY_KEYS` con todas las combinaciones `ENV-SERVICE` (ej. `dev-api dev-worker ... prod-monitor`). Muéstrala en `make demo`.
