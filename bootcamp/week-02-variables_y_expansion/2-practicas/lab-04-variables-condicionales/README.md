# Lab 04 — Variables condicionales con ?=

⏱ Duración estimada: ~50 min

## Objetivo

Implementar valores por defecto con `?=` que el usuario puede sobreescribir desde la línea de comandos o desde variables de entorno del shell, sin modificar el Makefile.

## Contexto

El operador `?=` asigna un valor **solo si la variable no está ya definida**. Si la variable tiene valor (desde CLI, desde el entorno del shell, o desde una asignación anterior), `?=` no hace nada.

```makefile
SERVER_HOST ?= localhost   # default si nadie más la define
SERVER_PORT ?= 8080
```

Esto permite tres formas de configurar el Makefile sin editarlo:

```bash
# Desde CLI (mayor precedencia):
make SERVER_PORT=9090 servidor

# Desde entorno del shell (exportada antes de ejecutar make):
export SERVER_HOST=0.0.0.0
make servidor

# Sin configuración: usa los defaults del Makefile
make servidor
```

## Instrucciones

1. Abre `starter/Makefile`.

2. Define cuatro variables con `?=`:
   - `SERVER_HOST` → `"localhost"`
   - `SERVER_PORT` → `"8080"`
   - `DB_HOST` → `"localhost"`
   - `LOG_LEVEL` → `"info"`

3. Completa los targets `config` y `servidor`.

4. Verifica los tres modos de configuración:
   ```bash
   make config                                   # usa defaults
   make config SERVER_PORT=9090                  # override desde CLI
   export SERVER_HOST=0.0.0.0 && make config    # override desde entorno
   ```

5. Verifica que la variable de entorno exportada funciona:
   ```bash
   SERVER_HOST=192.168.1.1 make config
   ```

## Criterios de éxito

- [ ] `make config` muestra los cuatro defaults
- [ ] `make config SERVER_PORT=9090` muestra `SERVER_PORT: 9090`
- [ ] `SERVER_HOST=10.0.0.1 make config` muestra `SERVER_HOST: 10.0.0.1`
- [ ] `make servidor` imprime el host y el puerto con el formato correcto
- [ ] `make help` funciona

## Reto extra

Agrega una variable `DB_URL` definida con `=` que construya la URL completa:
```makefile
DB_URL = postgres://$(DB_HOST):5432/myapp_$(ENV)
```
Donde `ENV ?= dev`. Verifica que `make config ENV=prod DB_HOST=prod-db.internal` produce la URL correcta.
