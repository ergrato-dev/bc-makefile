# Lab 02 — call

**Duración estimada:** 50 minutos

## Objetivo

Eliminar bloques de código duplicados definiendo funciones Make con `define...endef` y llamándolas con `$(call)`.

## Contexto

El `starter/Makefile` gestiona tres servicios (`api`, `worker`, `monitor`). Cada uno necesita mostrar su URL, su ruta de build y verificar su estado. El código actual repite la misma estructura tres veces — y si el formato cambia, hay que actualizar en tres lugares.

`$(call name,arg1,arg2,...)` invoca una función definida con `define`:

```makefile
define service_info
	@echo "[$1] URL: http://localhost:$2"
endef

# Uso:
$(call service_info,api,8080)   # → [api] URL: http://localhost:8080
$(call service_info,worker,8081) # → [worker] URL: http://localhost:8081
```

Los argumentos se referencian como `$1`, `$2`, `$3`... dentro del bloque `define`.

## Instrucciones

1. Entra al directorio starter:
   ```bash
   cd lab-02-call/starter
   ```

2. Lee el Makefile y observa el código duplicado en el target `demo`.

3. Implementa los TODOs:
   - **TODO 1:** Define `service_info` — recibe `$1=nombre` y `$2=puerto`, imprime la URL
   - **TODO 2:** Define `build_path` — recibe `$1=nombre`, devuelve `build/<nombre>/<nombre>`
   - **TODO 3:** Reemplaza el target `demo` para usar `$(call service_info,...)` y `$(call build_path,...)`
   - **TODO 4:** Reemplaza los tres targets `check-*` por uno solo usando `$(call)` + `$(foreach)`

4. Verifica:
   ```bash
   make demo
   make check-services
   ```

## Criterios de éxito

```
$ make demo
=== Servicios del sistema ===
[api]     URL: http://localhost:8080
[worker]  URL: http://localhost:8081
[monitor] URL: http://localhost:9090

Rutas de build:
  api:     build/api/api
  worker:  build/worker/worker
  monitor: build/monitor/monitor
```

```
$ make check-services
api OK
worker OK
monitor OK
```

El Makefile de la solución debe tener los bloques `define` y las llamadas a `$(call)`, sin repetición de lógica.

## Reto extra

Define una tercera función `deploy_cmd` que recibe `$1=servicio`, `$2=entorno` y `$3=versión` e imprime `"Desplegando $1 v$3 en $2"`. Llámala para api/prod/1.0, worker/staging/2.1 y monitor/dev/0.9.
