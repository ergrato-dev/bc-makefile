# Lab 04 — Variables condicionales con ?=

⏱ Duración estimada: ~60 min

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
   SERVER_HOST=0.0.0.0 make config              # override desde entorno
   ```

5. Verifica que una variable exportada en tu shell también funciona, y luego quítala para no contaminar los pasos siguientes:
   ```bash
   export SERVER_HOST=192.168.1.1
   make config          # SERVER_HOST: 192.168.1.1
   unset SERVER_HOST
   ```
   La forma `VAR=valor make` del paso 4 hace lo mismo solo para ese comando:
   ```bash
   SERVER_HOST=192.168.1.1 make config
   ```

6. **¿De dónde salió el valor?** Completa el target `origen` (función
   `$(origin VAR)`) y ejecuta los dos escenarios:
   ```bash
   make origen
   SERVER_HOST=10.0.0.1 make origen SERVER_PORT=9090
   ```
   Debes ver, primero:
   ```
   SERVER_HOST: file
   SERVER_PORT: file
   HOME:        environment
   NO_EXISTE:   undefined
   ```
   y después `SERVER_HOST: environment` y `SERVER_PORT: command line`. `file`
   significa que se aplicó el `?=` del Makefile.

7. **Definida no es lo mismo que con valor.** Ejecuta:
   ```bash
   make config SERVER_PORT=
   ```
   La línea sale como `SERVER_PORT: ` (vacía), no `8080`: `?=` solo mira si la
   variable está *definida*, y `SERVER_PORT=` la define con valor vacío.

8. **El error que `?=` evita.** Cambia `SERVER_HOST ?= localhost` por
   `SERVER_HOST := localhost` y repite:
   ```bash
   SERVER_HOST=10.0.0.1 make config
   SERVER_HOST=10.0.0.1 make origen
   ```
   Ahora sale `SERVER_HOST: localhost` y el origen es `file`: una asignación
   normal del Makefile **gana** a la variable de entorno. La línea de comandos
   (`make config SERVER_HOST=10.0.0.1`) sí seguiría ganando. Vuelve a `?=`.

## Criterios de éxito

- [ ] `make config` muestra los cuatro defaults
- [ ] `make config SERVER_PORT=9090` muestra `SERVER_PORT: 9090`
- [ ] `SERVER_HOST=10.0.0.1 make config` muestra `SERVER_HOST: 10.0.0.1`
- [ ] `make servidor` imprime el host y el puerto con el formato correcto
- [ ] `make origen` distingue `file`, `environment`, `command line` y `undefined`
- [ ] Con `SERVER_HOST :=`, puedes explicar por qué la variable de entorno deja de tener efecto
- [ ] `make help` funciona

## Reto extra

Agrega una variable `DB_URL` definida con `=` que construya la URL completa:
```makefile
DB_URL = postgres://$(DB_HOST):5432/myapp_$(ENV)
```
Donde `ENV ?= dev`. Verifica que `make config ENV=prod DB_HOST=prod-db.internal` produce la URL correcta.
