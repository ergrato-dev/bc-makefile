# Lab 02 — call

⏱ Duración estimada: ~60 min

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
   - **TODO 5:** Define `svc_url` en una línea; el puerto sale de `$(PORT_$1)`, un nombre de variable calculado
   - **TODO 6:** Implementa `urls` con `$(foreach)` + `$(call svc_url,...)`

4. Verifica:
   ```bash
   make demo
   make check-services
   ```

5. Funciones que devuelven texto en vez de imprimir (TODOs 5 y 6). `svc_url` no lleva `@echo`: devuelve una cadena que se puede usar en cualquier sitio, incluso dentro de un `$(foreach)`:
   ```bash
   make urls
   ```
   Debes ver:
   ```
   http://localhost:8080 http://localhost:8081 http://localhost:9090
   ```
   `$(PORT_$1)` funciona porque Make expande primero `$1` y después busca la variable con el nombre resultante (`PORT_api`). Añade `PORT_cache := 7000` y `cache` a `SERVICES`, ejecuta `make urls` otra vez y comprueba que aparece la cuarta URL sin tocar `svc_url`. Deshaz el cambio.

6. La trampa del espacio. El target `space-trap` ya está escrito; ejecútalo:
   ```bash
   make space-trap
   ```
   Debes ver:
   ```
   Sin espacio: [build/api/api]
   Con espacio: [build/ api/ api]
   ```
   `$(call)` pasa cada argumento tal cual, espacio incluido. En una lista de palabras no se nota; dentro de una ruta la parte en tres. Desde ahora, los argumentos de `call` van pegados a la coma.

## Criterios de éxito

```
$ make demo
=== Servicios del sistema ===
[api] URL: http://localhost:8080
[worker] URL: http://localhost:8081
[monitor] URL: http://localhost:9090

Rutas de build:
  api: build/api/api
  worker: build/worker/worker
  monitor: build/monitor/monitor
```

```
$ make check-services
api OK
worker OK
monitor OK
```

```
$ make urls
http://localhost:8080 http://localhost:8081 http://localhost:9090
```

- [ ] El Makefile tiene los bloques `define` y las llamadas a `$(call)`, sin repetición de lógica
- [ ] `svc_url` no repite ningún puerto: los lee de `PORT_<servicio>`
- [ ] `make space-trap` muestra la diferencia y sabes explicarla

## Reto extra

Define una tercera función `deploy_cmd` que recibe `$1=servicio`, `$2=entorno` y `$3=versión` e imprime `"Desplegando $1 v$3 en $2"`. Llámala para api/prod/1.0, worker/staging/2.1 y monitor/dev/0.9.
