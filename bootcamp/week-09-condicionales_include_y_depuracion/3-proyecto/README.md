# Proyecto Semana 09 — Librería de Módulos Make Reutilizables

**Duración estimada:** 2h 30min

## Contexto

Tu equipo mantiene tres proyectos (API, worker, frontend) con Makefiles que duplican las mismas 200 líneas de lógica de build, test y deploy. Cada vez que alguien mejora el pipeline en un proyecto, tiene que copiar el cambio a los otros dos. Esto escala mal.

La solución es una **librería de módulos Make** compartida: un directorio `shared-mk/` que cualquier proyecto puede importar con `include`. Los proyectos solo definen sus variables específicas (`APP_NAME`, `PORT`, `IMAGE`) y la librería proporciona todos los targets reutilizables.

## Estructura del proyecto

```
3-proyecto/starter/
├── Makefile                    # Makefile raíz: orquesta los tres proyectos
├── shared-mk/                  # Librería compartida de módulos
│   ├── build.mk                # Targets: build, clean, package
│   ├── test.mk                 # Targets: test, coverage
│   ├── deploy.mk               # Targets: deploy, rollback
│   └── debug.mk                # Targets: debug-vars, validate
├── api/
│   └── Makefile                # Solo variables + include ../../shared-mk/*.mk
├── worker/
│   └── Makefile                # Solo variables + include ../../shared-mk/*.mk
└── frontend/
    └── Makefile                # Solo variables + include ../../shared-mk/*.mk
```

## Entregables

1. `shared-mk/build.mk` — módulo con targets `build`, `clean`, `package`, que usan `APP_NAME` y `VERSION` del Makefile importador
2. `shared-mk/test.mk` — módulo con target `test` que reporta el módulo siendo testeado
3. `shared-mk/deploy.mk` — módulo con targets `deploy` y `rollback`, con condicional `ifeq` para proteger producción
4. `shared-mk/debug.mk` — módulo con `debug-vars` y `validate` que comprueban variables requeridas
5. `api/Makefile` — solo define `APP_NAME`, `PORT` e importa los módulos compartidos
6. `worker/Makefile` — solo define `APP_NAME`, `WORKERS` e importa los módulos compartidos
7. `frontend/Makefile` — solo define `APP_NAME`, `BUILD_DIR` e importa los módulos compartidos
8. `Makefile` raíz — orquesta con `$(MAKE) -C` usando recursión para `all`, `test`, `deploy`, `clean`

## Comandos de verificación

```bash
# Orquestación completa desde la raíz
make all
# Esperado: [api] build, [worker] build, [frontend] build

make test
# Esperado: [api] test, [worker] test, [frontend] test

make ENV=staging deploy
# Esperado: [api] Desplegando en staging, [worker] Desplegando en staging, [frontend] Desplegando en staging

make ENV=production deploy
# Esperado: igual, pero con confirmación (el módulo deploy.mk protege prod)

# Módulo independiente
make -C api build
# Esperado: [api] Compilando api 1.0.0

make -C api ENV=production deploy
# Esperado: [api] Desplegando en production

# Diagnóstico
make -C worker debug-vars
# Esperado: imprime APP_NAME, VERSION, ENV del worker

make -C frontend validate
# Esperado: Validación OK (todas las variables requeridas definidas)
```

## ✅ Requisitos verificables

Los comprueba `./scripts/verificar-semana.sh 09` desde la raíz del repositorio
(60 de los 100 puntos del Producto). Los otros 40 son de calidad: ver la
[rúbrica](../rubrica-evaluacion.md#-producto-30).

- [ ] make all desde la raíz construye api, worker y frontend
- [ ] make test desde la raíz ejecuta los tests de los tres módulos
- [ ] Si un módulo falla, make all desde la raíz sale con error
- [ ] make ENV=staging deploy despliega los tres módulos en staging
- [ ] deploy en production toma la rama ifeq que marca CONFIRMADO
- [ ] deploy sin ENV usa development y no marca CONFIRMADO
- [ ] Los tres módulos importan deploy.mk y ofrecen rollback
- [ ] make -C worker debug-vars muestra APP_NAME del módulo con $(info)
- [ ] debug-vars muestra en MAKEFILE_LIST los cuatro módulos incluidos
- [ ] make -C frontend validate pasa con las variables definidas
- [ ] validate falla con mensaje claro si VERSION está vacía
- [ ] make all no usa ninguna variable indefinida (--warn-undefined-variables)
- [ ] El Makefile raíz ejecuta las recetas con bash -eu -o pipefail
- [ ] El Makefile raíz declara .DELETE_ON_ERROR
- [ ] Los Makefiles de api, worker y frontend también usan bash -eu -o pipefail

## Instrucciones de entrega

```bash
git add bootcamp/week-09-condicionales_include_y_depuracion/3-proyecto/
git commit -m "feat(week-09): proyecto - librería de módulos Make reutilizables"
```
