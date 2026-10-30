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

## Rúbrica del proyecto (30 pts)

| Criterio | Pts |
|----------|-----|
| `make all` desde raíz construye los 3 módulos correctamente | 10 |
| Los módulos `.mk` son reutilizables: cualquier proyecto puede importarlos con `include` sin modificarlos | 8 |
| `make ENV=staging deploy` adapta comportamiento con condicionales en `deploy.mk` | 7 |
| `make -C <modulo> debug-vars` muestra diagnóstico útil con `$(info)` | 5 |

## Instrucciones de entrega

```bash
git add bootcamp/week-09-condicionales_include_y_depuracion/3-proyecto/
git commit -m "feat(week-09): proyecto - librería de módulos Make reutilizables"
```
