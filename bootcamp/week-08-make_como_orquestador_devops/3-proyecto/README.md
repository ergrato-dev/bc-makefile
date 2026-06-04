# Proyecto Semana 08 — Pipeline Local Completo

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
├── requirements.txt
├── src/
│   └── api.py            ← API Flask simple
├── tests/
│   └── test_api.py
└── scripts/
    └── hooks/
        ├── pre-commit    ← verifica que .env no se commitee
        └── pre-push      ← ejecuta lint antes de push
```

## Entregables

1. `Makefile` completo con todos los targets especificados
2. `.env` creado a partir de `.env.example` con valores de desarrollo
3. Hooks instalados en `.git/hooks/`
4. Pipeline `make ci` ejecutándose sin errores

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

## Rúbrica del proyecto (30 pts)

| Criterio | Pts |
|----------|-----|
| `make ci` ejecuta pipeline completo sin errores | 10 |
| `make env-check` valida todas las variables con mensajes claros | 8 |
| `make hooks-install` + `make hooks-status` funcionan | 7 |
| `make bump-patch` actualiza VERSION correctamente | 5 |

## Instrucciones de entrega

```bash
git add Makefile .env.example scripts/hooks/ VERSION
git commit -m "feat(week-08): pipeline local completo con Make"
```

> No commitees `.env` ni el directorio `.venv`.
