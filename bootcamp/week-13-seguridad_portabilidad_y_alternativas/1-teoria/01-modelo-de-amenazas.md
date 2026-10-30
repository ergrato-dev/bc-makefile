# Modelo de amenazas de un Makefile

## ¿Por qué importa esto?

Un Makefile es un programa que ejecuta comandos de shell con tus permisos, en tu portátil y en el runner de CI, donde suele haber tokens de despliegue. Casi nadie lo revisa como código: se copia, se amplía y se llama con valores que vienen de fuera (`VERSION=$TAG`, `BRANCH=$RAMA`). Esta semana lo tratas como lo que es: superficie de ataque.

## Las dos fases de Make

Make **lee** el Makefile completo (parse-time) y después **ejecuta** recetas (run-time). Lo que corre al leer, corre siempre: con `make help`, con `make -n`, con cualquier target.

| Corre al parsear | Corre con `make -n` | No corre con `make -n` |
|---|---|---|
| `X := $(shell ...)` | `$(shell ...)` dentro de una receta | El shell de la receta (`$$(cmd)`, `cmd`) |
| `include archivo` (todo su contenido) | Líneas con `+` o con `$(MAKE)` | |

## Amenazas y defensas

| Amenaza | Ejemplo | Defensa |
|---|---|---|
| `$(shell)` con efectos al parsear | `STAMP := $(shell mkdir -p build && date > build/.stamp)` | Al parsear solo se lee; lo que escribe va en una receta |
| Inyección por comillas | `make release VERSION="1'; rm -rf ~; '"` con `echo '$(VERSION)'` | Validar con lista blanca; texto libre por entorno (`"$$VAR"`) |
| Make expande el valor | `NOTE='$(shell id)'` se ejecuta al usar `$(NOTE)` | `override NOTE := $(value NOTE)` |
| `include .env` | Una línea `SHELL=./x.sh` o `$(shell ...)` | Lista blanca de claves y caracteres antes del `include` |
| `export` a secas | El token llega a `pnpm install` y a sus `postinstall` | `unexport TOKEN` + `export` solo en el target que lo usa |
| Secreto en el texto del comando | `curl -H "Bearer $(TOKEN)"`: sale en `make -n`, en el log y en `ps` | La receta lo lee del entorno: `"$$TOKEN"` |
| Permisos de artefactos | `echo ... > creds.conf` nace `644` | `umask 077;` en la misma línea |
| `rm -rf` sin guarda | `BUILD_DIR=` o `BUILD_DIR=/` | Vacía, absoluta, `..` y caracteres: `$(error)` antes de borrar |
| `curl \| sh` | Ejecuta lo que sirva el servidor hoy | Descargar, verificar SHA-256 fijado, ejecutar |

Dos detalles que sorprenden. Primero, Make lanza cada línea como `bash -c '<línea expandida>'`: el `@` oculta la línea en tu terminal, pero no en la tabla de procesos, donde cualquier usuario la ve con `ps`. Segundo, las variables que llegan por la línea de comandos o por el entorno se exportan siempre a las recetas, aunque no escribas `export`; solo `unexport` las corta.

## Ejemplo mínimo funcional

Pega esto en un `Makefile` y prueba los comandos de abajo:

```makefile
SHELL       := bash
.SHELLFLAGS := -eu -o pipefail -c

.PHONY: release
VERSION ?= 0.1.0
BRANCH  ?= main
TOKEN   ?=

# 1. Formato conocido: lista blanca, sin shell y sin expandir el valor.
strip-chars = $(if $2,$(call strip-chars,$(subst $(firstword $2),,$1),$(wordlist 2,$(words $2),$2)),$1)
ifneq ($(words $(value VERSION))$(call strip-chars,$(value VERSION),0 1 2 3 4 5 6 7 8 9 .),1)
  $(error VERSION inválida)
endif

# 2. Texto libre: literal y por entorno.
override BRANCH := $(value BRANCH)
export BRANCH

# 3. Secreto: ninguna receta lo recibe salvo release.
unexport TOKEN
release: export TOKEN := $(TOKEN)
release:
	@printf 'versión %s, rama %s, token de %s caracteres\n' '$(VERSION)' "$$BRANCH" "$${#TOKEN}"
```

```bash
make release VERSION=1.4.2 BRANCH="feat/o'brien" TOKEN=s3cr3t
make release 'VERSION=1;touch pwned'               # VERSION inválida
make release 'BRANCH=x`touch pwned`'; ls pwned     # no existe
make -n release TOKEN=s3cr3t                       # la línea no contiene s3cr3t
```

---

Listo. Ve al [lab-01](../2-practicas/lab-01-parse-time-vs-run-time/README.md) y ponlo en práctica.
