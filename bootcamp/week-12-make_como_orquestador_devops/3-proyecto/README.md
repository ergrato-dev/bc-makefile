# Proyecto Semana 12 — Pipeline Local Completo

⏱ Duración estimada: 3 h

## Contexto

Tu equipo acaba de adoptar una política de calidad: ningún código llega a `main` sin pasar el pipeline, y el pipeline tiene que ser **el mismo** en la máquina de cada desarrollador y en GitHub Actions. La última vez que el YAML de CI y los scripts locales divergieron, un test se desactivó en CI durante tres semanas sin que nadie lo notara.

Tu tarea es construir ese pipeline como un Makefile profesional para una API Python pequeña, y un workflow de GitHub Actions que no haga nada más que llamarlo. El Makefile debe:

1. Cargar `.env` sin exponer secretos y validar las variables requeridas
2. Leer y validar `VERSION` sin pasarla nunca por el shell
3. Instalar git hooks versionados con `core.hooksPath`
4. Ejecutar env-check → lint → test → build → report con fallo rápido
5. Ser lo único que ejecuta el workflow de CI

## Árbol del starter

```
starter/
├── Makefile                  ← tu trabajo principal (TODO 0 a TODO 10)
├── VERSION                   ← versión inicial: 0.1.0
├── .env.example              ← plantilla de variables (sin valores reales)
├── .gitignore                ← .env* ignorados salvo .env.example
├── .github/
│   └── workflows/
│       └── ci.yml            ← TODO 11: funciona, pero duplica el pipeline y no está pinneado
├── pyproject.toml            ← dependencias (uv)
├── uv.lock                   ← versiones exactas (se commitea)
├── src/
│   └── api.py                ← API Flask simple
├── tests/
│   └── test_api.py
└── scripts/
    └── hooks/
        ├── pre-commit        ← rechaza commits con .env* (salvo .env.example)
        └── pre-push          ← ejecuta make lint antes del push
```

## Entregables

1. `Makefile` con todos los targets de la tabla siguiente y el preámbulo estricto (`SHELL := bash`, `.SHELLFLAGS := -eu -o pipefail -c`, `.DELETE_ON_ERROR:`)
2. `VERSION` leída con `$(file <)` y validada a nivel de Makefile: cualquier target falla si no es `MAYOR.MENOR.PARCHE`
3. `-include .env` con el comentario que advierte que se parsea como Makefile, y `export` solo de `APP_NAME ENV DB_URL SECRET_KEY`, nunca `export` a secas
4. `guard-%` que valida en Make, sin pasar el valor por el shell
5. Hooks activos con `git config core.hooksPath` apuntando a `scripts/hooks/`, con un comentario que recuerde que `git commit --no-verify` los salta
6. `make ci` en verde con tu `.env` de desarrollo
7. `.github/workflows/ci.yml` con `permissions: contents: read`, acciones pinneadas por SHA y un único paso `run: make ci`

## Targets requeridos

| Target | Descripción |
|--------|-------------|
| `env-check` | Valida APP_NAME, DB_URL, SECRET_KEY y ENV con `guard-%` |
| `install` | `uv sync --locked` detrás de un sentinel (`$(VENV)/.installed`) |
| `hooks-install` | `chmod +x` y `git config core.hooksPath` con ruta absoluta |
| `hooks-uninstall` | `git config --unset core.hooksPath` |
| `hooks-status` | Muestra `core.hooksPath` y si cada hook es ejecutable |
| `lint` | `uv run --no-sync flake8 src` |
| `test` | `uv run --no-sync pytest` con cobertura |
| `build` | Crea `dist/mi-api-VERSION.tar.gz` con `src/` |
| `report` | Imprime el resumen del pipeline |
| `ci` | env-check → lint → test → build → report |
| `version` | Muestra la versión actual |
| `bump-patch` | Incrementa el parche en `VERSION_FILE` |
| `clean` | Elimina `.venv/` y `dist/` con guarda de variable vacía |
| `help` | Lista todos los targets (target por defecto) |

## Comandos de verificación

```bash
cp .env.example .env            # valores de desarrollo, sin $, comillas ni #
make env-check                  # Variables de entorno OK
make install && make install    # la segunda no vuelve a ejecutar uv sync
make ci                         # ... ✓ CI OK
make ci SECRET_KEY=; echo $?    # SECRET_KEY no definida ... 2

git init -q && make hooks-install && make hooks-status
git config --get core.hooksPath # /ruta/absoluta/scripts/hooks

make version && make bump-patch && make version   # 0.1.0 → 0.1.1

# El workflow, sin subirlo a GitHub:
grep -E '^ *(- )?run:' .github/workflows/ci.yml   # solo: - run: make ci
grep -E 'uses:' .github/workflows/ci.yml | grep -vE '@[0-9a-f]{40}( |$)' || echo "todas pinneadas"
```

## ✅ Requisitos verificables

Los comprueba `./scripts/verificar-semana.sh 12` desde la raíz del repositorio
(60 de los 100 puntos del Producto). Los otros 40 son de calidad: ver la
[rúbrica](../rubrica-evaluacion.md#-producto-30). Ninguna comprobación toca la
red ni la configuración git de tu repositorio: los hooks se prueban en un repo
temporal y los targets que instalan dependencias, con `make -n`.

- [ ] Una VERSION con código de shell hace fallar a Make antes de ejecutar nada
- [ ] Una VERSION sin tres componentes numéricos se rechaza
- [ ] make bump-patch convierte 1.2.9 en 1.2.10
- [ ] guard-VAR falla con un mensaje que nombra la variable si no está definida
- [ ] make env-check falla si SECRET_KEY está vacía
- [ ] Las recetas reciben DB_URL pero no variables que el Makefile no exporta
- [ ] make hooks-install apunta core.hooksPath a scripts/hooks con ruta absoluta
- [ ] make hooks-uninstall deja core.hooksPath sin configurar
- [ ] Con los hooks instalados, un commit que incluye .env se rechaza
- [ ] make install sincroniza el entorno con uv sync --locked
- [ ] make install no vuelve a ejecutar uv sync si el sentinel es más nuevo que pyproject.toml y uv.lock
- [ ] make lint ejecuta flake8 con uv run --no-sync
- [ ] make test ejecuta pytest con cobertura
- [ ] make build crea dist/mi-api-VERSION.tar.gz con el código de src/
- [ ] make ci encadena lint, test y build en ese orden
- [ ] make ci se detiene en env-check, antes del lint, si falta SECRET_KEY
- [ ] El workflow de GitHub Actions tiene un único paso run y ese paso es make ci
- [ ] Todas las acciones del workflow están pinneadas por SHA de 40 caracteres

## Entrega

```bash
git add Makefile VERSION .env.example .gitignore .github/ scripts/hooks/
git commit -m "feat(week-12): pipeline local completo con Make"
```

> No commitees `.env`, `.venv/` ni `dist/`. Si el hook `pre-commit` te
> rechaza el commit, léelo antes de pensar en `--no-verify`.
