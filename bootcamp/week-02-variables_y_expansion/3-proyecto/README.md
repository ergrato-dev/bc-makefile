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
Fecha:      2026-01-15
Imagen:     registry.local/mywebservice:0.1.0-abc1234-staging
DB URL:     postgres://localhost:5432/mywebservice_staging
Log level:  info
```

### 2. `build`
Simula la construcción. Output esperado con `make build ENV=prod VERSION=1.2.0`:
```
[build] Construyendo mywebservice:1.2.0-prod...
[build] Compilación OK.
[build] Imagen lista: registry.local/mywebservice:1.2.0-prod
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
[deploy]   DB:     postgres://localhost:5432/mywebservice_staging
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
| `GIT_VERSION` | `:=` | resultado de `git describe` o `"0.1.0"` | Versión calculada una sola vez al cargar el Makefile |
| `VERSION` | `?=` | `$(GIT_VERSION)` | Versión del build |
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

## ✅ Requisitos verificables

Los comprueba `./scripts/verificar-semana.sh 02` desde la raíz del repositorio
(60 de los 100 puntos del Producto). Los otros 40 son de calidad: ver la
[rúbrica](../rubrica-evaluacion.md#-producto-30).

- [ ] Sin ENV, make config muestra el entorno dev
- [ ] make config ENV=staging muestra el entorno staging
- [ ] ENV exportada en la shell cambia el entorno sin tocar el Makefile
- [ ] Sin VERSION, la imagen lleva una versión no vacía obtenida de git o 0.1.0
- [ ] make config ENV=prod VERSION=2.0.0 muestra la imagen registry.local/mywebservice:2.0.0-prod
- [ ] La URL de base de datos incluye el entorno activo
- [ ] DB_HOST se puede cambiar desde la línea de comandos
- [ ] IMAGE_TAG se define con = y referencia a ENV
- [ ] BUILD_DATE se define con := y guarda una fecha AAAA-MM-DD
- [ ] make deploy ejecuta build y test antes de desplegar
- [ ] make clean no falla aunque dist/ no exista

## Entrega

Commit con el mensaje:
```
feat(week-02): proyecto - makefile parametrizable multi-entorno
```
