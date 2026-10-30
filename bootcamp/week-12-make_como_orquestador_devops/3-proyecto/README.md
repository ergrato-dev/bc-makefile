# Proyecto Semana 12 — Pipeline Local Completo

**Duración estimada:** 2h 30min

## Contexto

Tu equipo acaba de adoptar una política de calidad: ningún código llega a producción sin pasar un pipeline local completo. Tu tarea es construir ese pipeline como un Makefile profesional para una API Python pequeña.

El pipeline debe:
1. Validar variables de entorno requeridas
2. Instalar git hooks para proteger el repositorio
3. Ejecutar lint + test + build en secuencia
4. Generar un reporte de resultado
5. Soportar múltiples entornos (dev/staging/prod)

## Árbol del starter

```
starter/
├── Makefile              ← tu trabajo principal
├── VERSION               ← versión inicial: 0.1.0
├── .env.example          ← plantilla de variables
├── .gitignore
├── pyproject.toml        ← dependencias (uv)
├── uv.lock               ← versiones exactas (commitear)
├── src/
│   └── api.py            ← API Flask simple
├── tests/
│   └── test_api.py
└── scripts/
    └── hooks/
        ├── pre-commit    ← verifica que ningún .env* (salvo .env.example) se commitee
        └── pre-push      ← ejecuta lint antes de push
```

## Entregables

1. `Makefile` completo con todos los targets especificados
2. `.env` creado a partir de `.env.example` con valores de desarrollo
3. Hooks activos con `git config core.hooksPath` (versionados en `scripts/hooks/`)
4. Pipeline `make ci` ejecutándose sin errores
5. `VERSION` leída sin shell (`$(file <)`) y validada: cualquier target falla si no es `MAYOR.MENOR.PARCHE`
6. `export` solo de `APP_NAME ENV DB_URL SECRET_KEY`, nunca `export` a secas

## Targets requeridos

| Target | Descripción |
|--------|-------------|
| `env-check` | Valida APP_NAME, DB_URL, SECRET_KEY, ENV |
| `install` | Instala dependencias Python (sentinel file) |
| `hooks-install` | Instala git hooks |
| `hooks-uninstall` | Desinstala git hooks |
| `hooks-status` | Muestra estado de los hooks |
| `lint` | Ejecuta flake8 sobre src/ |
| `test` | Ejecuta pytest con cobertura |
| `build` | Crea dist/api-VERSION.tar.gz |
| `report` | Imprime resumen del pipeline |
| `ci` | Pipeline completo: env-check → lint → test → build → report |
| `version` | Muestra versión actual |
| `bump-patch` | Incrementa versión patch |
| `clean` | Elimina artefactos |
| `help` | Lista todos los targets |

## Comandos de verificación

```bash
# 1. Verificar variables de entorno
make env-check
# Esperado: "Variables de entorno OK"

# 2. Instalar dependencias y hooks
make install
make hooks-install
make hooks-status
# Esperado: tabla con pre-commit ✓ instalado ✓ ejecutable

# 3. Pipeline completo
make ci
# Esperado: "✓ CI OK"

# 4. Bump de versión
make version          # 0.1.0
make bump-patch
make version          # 0.1.1

# 5. Ayuda
make help
# Esperado: tabla con todos los targets y descripciones
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

## Instrucciones de entrega

```bash
git add Makefile .env.example scripts/hooks/ VERSION
git commit -m "feat(week-12): pipeline local completo con Make"
```

> No commitees `.env` ni el directorio `.venv`.
