# Lab 02 — Include y Makefiles Modulares

**Duración estimada:** 50 min

## Objetivo

Separar un Makefile monolítico en módulos `.mk` especializados (build, test, deploy) que el Makefile principal importa con `include`, logrando que cada módulo sea reutilizable en otros proyectos.

## Contexto

Un Makefile de 500 líneas es difícil de mantener. La solución es modularizarlo:

- Cada módulo `.mk` encapsula targets y variables de un dominio (build, test, docker, etc.)
- El Makefile principal solo hace `include mk/build.mk` y `include mk/test.mk`
- Un módulo no tiene `.DEFAULT_GOAL` — lo controla el Makefile principal
- `-include` (con guion) no falla si el archivo no existe: ideal para configuración opcional

El beneficio real: copiar `mk/build.mk` a otro proyecto y hacer `include ../shared/mk/build.mk` reutiliza toda la lógica sin duplicarla.

## Instrucciones

1. Copia el starter:
   ```bash
   cp -r starter/ mi-lab-02 && cd mi-lab-02
   ```

2. Observa la estructura inicial:
   ```bash
   ls mk/
   cat Makefile
   cat mk/build.mk
   ```

3. Completa `mk/build.mk` añadiendo los targets `build` y `clean` indicados en los TODOs.

4. Completa `mk/test.mk` añadiendo el target `test`.

5. Completa `mk/deploy.mk` con el target `deploy`.

6. Verifica que el Makefile principal orquesta todo:
   ```bash
   make build
   make test
   make deploy ENV=staging
   make help
   ```

7. Agrega un módulo opcional `mk/local.mk` que el Makefile importa con `-include`:
   ```bash
   # Crea el archivo y agrega una variable LOCAL_OVERRIDE
   echo 'LOCAL_OVERRIDE := true' > mk/local.mk
   make info
   ```

## Criterios de éxito

- [ ] `make build` → imprime `[build] Compilando <APP_NAME> <VERSION>`
- [ ] `make test` → imprime `[test] Ejecutando tests de <APP_NAME>`
- [ ] `make deploy ENV=staging` → imprime `[deploy] Desplegando en staging`
- [ ] `make help` → lista targets de todos los módulos (`build`, `test`, `deploy`, `info`)
- [ ] Sin `mk/local.mk`: `make info` funciona (no falla por `-include`)
- [ ] Con `mk/local.mk` presente: `make info` muestra `LOCAL_OVERRIDE = true`

## Reto extra

Crea un módulo `mk/docker.mk` con targets `docker-build` y `docker-push`. Impórtalo en el Makefile principal y verifica que `make help` lo lista automáticamente.
