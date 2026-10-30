# Lab 04 — docker-compose con Make

**Duración estimada:** 60 minutos

**Requisitos:** Docker Engine 27+ con Compose v2 (`docker compose version`)

## Objetivo

Envolver los comandos de `docker compose` en targets Make para que el stack local tenga una interfaz única y sin secretos en el repositorio.

## Contexto

Compose v2 viene integrado en Docker como `docker compose`. El binario antiguo `docker-compose` (v1) está en EOL desde 2023: no lo soportes. Una variable deja el comando en un solo sitio:

```makefile
COMPOSE := docker compose
```

La contraseña de Postgres no está en `docker-compose.yml`: se lee de `.env` (ignorado por git) con `${POSTGRES_PASSWORD:?...}`, que hace fallar `compose up` si falta. El puerto se publica en `127.0.0.1`, no en todas las interfaces.

Los targets de orquestación son siempre `.PHONY` — nunca producen archivos — y generalmente no tienen dependencias entre sí (levantar y bajar son operaciones independientes).

## Instrucciones

1. Entra al directorio starter:
   ```bash
   cd lab-04-compose/starter
   ```

2. Revisa el `docker-compose.yml` (todavía **no** crees `.env`):
   ```bash
   cat docker-compose.yml
   cat .env.example
   ```

3. Ejecuta `make info` para ver el stack configurado (funciona sin docker):
   ```bash
   make info
   ```

4. Implementa el **TODO 0** (preámbulo estricto) y los TODOs 1–6 del `Makefile`:
   - **TODO 1:** target `up` que levante el stack en modo detached (`-d`)
   - **TODO 2:** target `down` que detenga y elimine los contenedores
   - **TODO 3:** target `logs` que muestre logs del servicio `web` en tiempo real
   - **TODO 4:** target `ps` que muestre el estado de los contenedores del stack
   - **TODO 5:** target `restart` que reinicie un servicio específico (usar variable `SERVICE`)
   - **TODO 6:** target `exec` que abra un shell en el contenedor `web`

5. Sin `.env`, prueba qué pasa con `make up` (requiere Docker):
   ```bash
   make up
   ```
   Compose falla al interpolar `${POSTGRES_PASSWORD:?...}`. El mensaje es correcto, pero llega tarde y desde otra herramienta. Implementa el **TODO 7**: `.env` como regla de archivo que falla con un mensaje propio, `up` dependiendo de ella y un target `config` que valide sin levantar nada.
   ```bash
   make up                 # Falta .env: cp .env.example .env y cambia POSTGRES_PASSWORD
   make -n up              # muestra el echo y el exit 1: docker ni aparece
   cp .env.example .env    # edita la contraseña
   make config             # Configuración válida.
   ```
   Prueba también con `POSTGRES_PASSWORD=` vacío en `.env`: ahora `.env` existe y es `make config` quien falla, con el mensaje de Compose. Restaura la contraseña.

6. Ciclo completo (requiere Docker):
   ```bash
   make up
   make ps
   make logs                   # Ctrl+C para salir
   make restart SERVICE=db
   make exec                   # sh dentro de web; exit para salir
   make down
   ```

## Criterios de éxito

```
$ make info
Stack:    mi-stack
Compose:  docker compose
Servicios: web db
```

```
$ rm .env; make up
Falta .env: cp .env.example .env y cambia POSTGRES_PASSWORD
make: *** [Makefile:NN: .env] Error 1

$ cp .env.example .env; make config
docker compose config --quiet
Configuración válida.
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
mi-stack-web-1        nginx:1.30-alpine    running
mi-stack-db-1         postgres:18-alpine   running
```

```
$ make restart SERVICE=web
Reiniciando web...
docker compose restart web
```

## Reto extra

Agrega un target `shell` que acepte `SERVICE=<nombre>` y ejecute `docker compose exec $(SERVICE) sh`. El default de SERVICE debe ser `web`.
