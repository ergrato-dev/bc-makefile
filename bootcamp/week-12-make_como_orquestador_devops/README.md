# Semana 12 — Make como Orquestador DevOps

## Descripción

Un Makefile bien diseñado sustituye a los scripts sueltos de CI/CD: carga el `.env` sin filtrar secretos, instala los git hooks del equipo, versiona releases y ejecuta el pipeline completo con un solo comando. Esta semana conviertes Make en la columna vertebral del flujo DevOps local: un `make ci` que corre idéntico en tu laptop y en GitHub Actions, de modo que reproducir un fallo de CI sea ejecutar el mismo comando en tu máquina.

## Objetivos de aprendizaje

Al terminar esta semana, podrás:

- Cargar `.env` con `-include` sabiendo que se parsea como Makefile, y exportar solo las variables que las recetas necesitan
- Validar variables requeridas con `guard-%` sin pegar el secreto en una línea de shell
- Instalar git hooks versionados con `core.hooksPath` y explicar por qué `--no-verify` los convierte en ayuda, no en control
- Construir un pipeline `make ci` con fallo rápido y llamarlo desde un workflow de GitHub Actions mínimo, con acciones pinneadas por SHA y `permissions: contents: read`
- Componer targets de calidad (`lint-python`, `lint-shell`, `lint-docs`) y ver todos los fallos con `make -k`
- Leer y validar `VERSION` sin shell y automatizar `bump`, `tag` y `CHANGELOG.md`
- Depurar un pipeline roto con `-n`, `--warn-undefined-variables` y `--debug=v`

## Prerrequisitos

- Semanas 01–11 completadas (en especial la 03, modo estricto, y la 11, sentinels con uv)
- GNU Make ≥ 4.3 (`make --version`; en macOS `gmake`)
- git y bash
- uv 0.12.x (labs 03 y proyecto). Python siempre con uv, nunca pip
- Opcional: shellcheck (lab 04)

## Contenido

| # | Tipo | Tema | Tiempo |
|---|------|------|--------|
| — | Teoría | [01-contexto.md](1-teoria/01-contexto.md) | 45 min |
| — | Conocimiento | [10 preguntas](rubrica-evaluacion.md#-conocimiento-30) | 15 min |
| 1 | Lab | [lab-01-env-secrets](2-practicas/lab-01-env-secrets/) | 60 min |
| 2 | Lab | [lab-02-git-hooks](2-practicas/lab-02-git-hooks/) | 60 min |
| 3 | Lab | [lab-03-ci-local](2-practicas/lab-03-ci-local/) | 60 min |
| 4 | Lab | [lab-04-lint-calidad](2-practicas/lab-04-lint-calidad/) | 60 min |
| 5 | Lab | [lab-05-release](2-practicas/lab-05-release/) | 60 min |
| 6 | Lab | [lab-06-pipeline-roto](2-practicas/lab-06-pipeline-roto/) | 60 min |
| — | Proyecto | [Pipeline local completo](3-proyecto/) | 3 h |

**Total: 10 horas**

## Distribución del tiempo

```
[45 min] Leer 1-teoria/01-contexto.md
[15 min] Responder las 10 preguntas de Conocimiento
[60 min] lab-01 — .env, export selectivo y guard-%
[60 min] lab-02 — git hooks con core.hooksPath y su bypass
[60 min] lab-03 — make ci local y el mismo make ci en GitHub Actions
[60 min] lab-04 — targets de calidad compuestos y make -k
[60 min] lab-05 — VERSION validada, bump, tag y changelog
[60 min] lab-06 — depurar un pipeline con cinco errores
[3 h]    Proyecto: pipeline local completo con workflow de CI
```

## Verificación de completitud

Desde la raíz del repositorio (sin red y sin tocar la configuración git del
repo: los hooks se prueban en un repositorio temporal):

```bash
./scripts/verificar-semana.sh 12
```

## 🔗 Navegación

| Anterior | Actual | Siguiente |
|---|---|---|
| [Semana 11 — Makefiles para proyectos modernos](../week-11-makefiles_para_proyectos_modernos/README.md) | **Semana 12 — Make como orquestador DevOps** | [Semana 13 — Seguridad, portabilidad y alternativas](../week-13-seguridad_portabilidad_y_alternativas/README.md) |

[← Volver al índice del bootcamp](../README.md)
