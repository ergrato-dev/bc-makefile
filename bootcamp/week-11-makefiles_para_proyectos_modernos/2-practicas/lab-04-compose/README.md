# Lab 04 — docker-compose con Make

**Duración estimada:** 50 minutos

**Requisitos:** Docker 24+ con docker compose (o docker-compose v2)

## Objetivo

Envolver los comandos de docker-compose en targets Make para que el stack local tenga una interfaz consistente independientemente de la versión de compose instalada.

## Contexto

`docker-compose` (v1) y `docker compose` (v2 integrado en Docker) tienen CLIs casi idénticas pero el ejecutable cambia. Make resuelve esto con una variable que detecta cuál está disponible:

```makefile
COMPOSE := $(shell docker compose version > /dev/null 2>&1 && echo "docker compose" || echo "docker-compose")
```

Resultado: el mismo Makefile funciona en ambos entornos sin cambios.

Los targets de orquestación son siempre `.PHONY` — nunca producen archivos — y generalmente no tienen dependencias entre sí (levantar y bajar son operaciones independientes).

## Instrucciones

1. Entra al directorio starter:
   ```bash
   cd lab-04-compose/starter
   ```

2. Revisa el `docker-compose.yml`:
   ```bash
   cat docker-compose.yml
   ```

3. Ejecuta `make info` para ver el stack configurado (funciona sin docker):
   ```bash
   make info
   ```

4. Implementa los 6 TODOs del `Makefile`:
   - **TODO 1:** target `up` que levante el stack en modo detached (`-d`)
   - **TODO 2:** target `down` que detenga y elimine los contenedores
   - **TODO 3:** target `logs` que muestre logs del servicio `web` en tiempo real
   - **TODO 4:** target `ps` que muestre el estado de los contenedores del stack
   - **TODO 5:** target `restart` que reinicie un servicio específico (usar variable `SERVICE`)
   - **TODO 6:** target `exec` que abra un shell en el contenedor `web`

5. Verifica (requiere Docker):
   ```bash
   make up
   make ps
   make logs        # Ctrl+C para salir
   make down
   ```

## Criterios de éxito

```
$ make info
Stack:    mi-stack
Compose:  docker compose  (o docker-compose según versión)
Servicios: web db
```

```
$ make up
docker compose up -d
[+] Running 2/2
 ✔ Container mi-stack-db-1   Started
 ✔ Container mi-stack-web-1  Started
```

```
$ make ps
NAME                  IMAGE           STATUS
mi-stack-web-1        nginx:alpine    running
mi-stack-db-1         postgres:15-alpine  running
```

```
$ make restart SERVICE=web
Reiniciando web...
docker compose restart web
```

## Reto extra

Agrega un target `shell` que acepte `SERVICE=<nombre>` y ejecute `docker compose exec $(SERVICE) sh`. El default de SERVICE debe ser `web`.
