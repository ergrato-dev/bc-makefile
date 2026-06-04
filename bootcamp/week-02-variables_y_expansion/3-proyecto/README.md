# Proyecto Semana 02 — Makefile parametrizable multi-entorno

⏱ Duración estimada: ~2h 30min

## Contexto

Eres el único platform engineer de una startup con tres ambientes: `dev`, `staging` y `prod`. El equipo despliega un servicio web y actualmente cada ambiente requiere un script diferente con paths y URLs hardcodeadas. Cada deploy manual genera inconsistencias.

Tu tarea: escribir un único `Makefile` que funcione para los tres ambientes. El único parámetro que cambia entre ejecuciones es `ENV=dev|staging|prod`. Sin ese parámetro, el Makefile usa `dev` como default seguro.

## Estructura del proyecto

```
starter/
└── Makefile          ← aquí trabajas
```

El proyecto no requiere archivos adicionales. Todos los targets simulan operaciones con `@echo`.

## Lo que debes construir

Implementa los siguientes targets con el comportamiento indicado:

### 1. `config`
Imprime toda la configuración activa. Output esperado con `make config ENV=staging`:
```
Entorno:    staging
Versión:    0.1.0-abc1234
Imagen:     registry.local/mywebservice:0.1.0-abc1234-staging
DB URL:     postgres://staging-db.internal:5432/mywebservice_staging
Log level:  info
```

### 2. `build`
Simula la construcción. Output esperado con `make build ENV=prod VERSION=1.2.0`:
```
[build] Construyendo mywebservice:1.2.0-prod...
[build] Compilación OK.
[build] Imagen lista: registry.local/mywebservice:1.2.0-prod-prod
```

### 3. `test`
Simula la ejecución de tests. Output esperado:
```
[test] Ejecutando suite de pruebas en entorno: dev
[test] Tests OK.
```

### 4. `deploy`
Depende de `build` y `test`. Output esperado con `make deploy ENV=staging VERSION=1.1.0`:
```
[build] ...
[test] ...
[deploy] Desplegando en staging...
[deploy]   Imagen: registry.local/mywebservice:1.1.0-staging
[deploy]   DB:     postgres://staging-db.internal:5432/mywebservice_staging
[deploy] Deploy OK.
```

### 5. `clean`
Elimina el directorio `dist/` si existe. No falla si no existe:
```
[clean] Limpiando artefactos...
[clean] Listo.
```

### 6. `help`
Lista todos los targets con descripción usando el patrón `##`.

## Variables requeridas

Tu Makefile debe definir al menos:

| Variable | Tipo | Default | Descripción |
|----------|------|---------|-------------|
| `ENV` | `?=` | `dev` | Entorno destino |
| `VERSION` | `?=` | resultado de `git describe` o `"0.1.0"` | Versión del build |
| `APP_NAME` | `?=` | `mywebservice` | Nombre de la aplicación |
| `REGISTRY` | `?=` | `registry.local` | Registry de imágenes |
| `LOG_LEVEL` | `?=` | `info` | Nivel de logging |
| `IMAGE_TAG` | `=` | `$(REGISTRY)/$(APP_NAME):$(VERSION)-$(ENV)` | Tag completo de la imagen |
| `DB_HOST` | `?=` | `localhost` | Host de base de datos |
| `DB_NAME` | `=` | `$(APP_NAME)_$(ENV)` | Nombre de la base de datos |
| `DB_URL` | `=` | `postgres://$(DB_HOST):5432/$(DB_NAME)` | URL completa de BD |
| `BUILD_DATE` | `:=` | `$(shell date +%F)` | Fecha de construcción |

## Verificación

Estos comandos deben funcionar sin errores y producir outputs distintos:

```bash
make help
make config
make config ENV=staging
make config ENV=prod DB_HOST=prod-db.internal
make build
make build ENV=prod VERSION=2.0.0
make deploy ENV=staging VERSION=1.1.0
make clean
```

## Rúbrica del proyecto (30 pts)

| Criterio | Pts |
|----------|-----|
| `make config` y `make config ENV=prod` muestran configuraciones distintas | 8 |
| `make deploy ENV=staging` produce output con imagen y DB correctas para staging | 8 |
| Variables `?=` respetan override desde CLI y desde entorno exportado | 7 |
| `make clean` funciona sin error aunque `dist/` no exista | 4 |
| `make help` documenta todos los targets | 3 |

## Entrega

Commit con el mensaje:
```
feat(week-02): proyecto - makefile parametrizable multi-entorno
```
