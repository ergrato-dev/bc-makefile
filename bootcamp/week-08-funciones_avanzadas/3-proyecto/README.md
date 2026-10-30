# Proyecto Semana 08 — Orquestador de Microservicios Auto-Configurable

⏱ Duración estimada: 3 h

## Contexto

Eres el responsable del build de una plataforma con tres microservicios (`api`, `worker`, `monitor`). Cada uno vive en `services/<nombre>/main.c` y compila a un binario independiente.

El Makefile anterior listaba los servicios a mano. Cada vez que el equipo agregaba un servicio nuevo, alguien olvidaba actualizar el Makefile y el nuevo servicio nunca se compilaba en CI.

Tu misión: reescribir el Makefile usando las cuatro funciones de esta semana para que cualquier directorio nuevo en `services/` se compile automáticamente, y el Makefile genere un `manifest.mk` con los metadatos del build.

## Estructura del starter

```
starter/
├── Makefile
└── services/
    ├── api/
    │   └── main.c
    ├── worker/
    │   └── main.c
    └── monitor/
        └── main.c
```

## Entregables

1. `make info` — muestra servicios auto-descubiertos y metadatos del sistema
2. `make all` — compila todos los servicios usando reglas generadas por `$(eval)`
3. `make <servicio>` (ej. `make api`) — compila un servicio individual, target generado dinámicamente
4. `make run-<servicio>` (ej. `make run-worker`) — compila si hace falta y ejecuta ese servicio, también generado por la plantilla
5. `make generate` — compila todo y escribe `build/manifest.mk` **con `$(file)`**, sin `printf` ni `echo`, incluyendo una línea `BIN_<servicio>` por servicio
6. `make clean` — elimina todo lo generado en `build/`, con guarda de variable vacía

## Variables requeridas en el Makefile

| Variable | Cómo generarla | Valor esperado |
|----------|---------------|----------------|
| `SERVICES` | `$(notdir $(shell find services -mindepth 1 -maxdepth 1 -type d \| sort))` | `api monitor worker` |
| `BINS` | `$(foreach svc,$(SERVICES),$(BUILD)/$(svc))` | `build/api build/monitor build/worker` |
| `BUILD_DATE` | `$(shell date +%Y-%m-%dT%H:%M:%S)` | timestamp del build |
| `GIT_HASH` | `$(shell git rev-parse --short HEAD 2>/dev/null \|\| echo sin-git)` | hash corto |
| `OS_NAME` | `$(shell uname -s)` | `Linux` o `Darwin` |

## Plantilla requerida

Punto de partida; te falta añadir el target `run-$(1)` (entregable 4):

```makefile
define SERVICE_RULE
.PHONY: $(1)

$(1): $(BUILD)/$(1)

$(BUILD)/$(1): services/$(1)/main.c | $(BUILD)
	$(CC) $(CFLAGS) $$< -o $$@
	@echo "Compilado: $$@"
endef
```

El directorio `$(BUILD)` es un prerrequisito *order-only* (semana 06): la regla `$(BUILD): ; @mkdir -p $@` ya está en el starter. `generate` también lo necesita, porque Make expande `$(file ...)` antes de ejecutar la primera línea de la receta (ver [02-file-value-let-intcmp.md](../1-teoria/02-file-value-let-intcmp.md)).

## Comandos de verificación

```bash
cd 3-proyecto/solucion

# Verificar auto-descubrimiento
make info

# Compilar todos
make all

# Compilar individual (target generado dinámicamente)
make api
make worker

# Compilar y ejecutar un servicio
make run-worker

# Generar manifest
make generate
cat build/manifest.mk

# Probar resistencia — agregar nuevo servicio sin tocar el Makefile
mkdir -p services/cache
cat > services/cache/main.c << 'EOF'
#include <stdio.h>
int main(void) { printf("[cache] servicio iniciado\n"); return 0; }
EOF
make clean && make all
```

## Salida esperada de `make info`

```
=== Orquestador de Microservicios ===
Servicios:  api monitor worker
Binarios:   build/api build/monitor build/worker
Total:      3 servicios
---
Git:        a1b2c3d
Fecha:      2026-06-04T14:30:00
OS:         Linux
```

## Salida esperada de `make all`

```
gcc -Wall -Wextra -std=c11 services/api/main.c -o build/api
Compilado: build/api
gcc -Wall -Wextra -std=c11 services/monitor/main.c -o build/monitor
Compilado: build/monitor
gcc -Wall -Wextra -std=c11 services/worker/main.c -o build/worker
Compilado: build/worker
=== Build completo ===
  api: build/api
  monitor: build/monitor
  worker: build/worker
```

## Salida esperada de `make run-worker`

```
gcc -Wall -Wextra -std=c11 services/worker/main.c -o build/worker
Compilado: build/worker
./build/worker
[worker] servicio iniciado
```

## Contenido esperado de `build/manifest.mk`

```makefile
# Generado automáticamente — no editar
BUILT_SERVICES := api monitor worker
BUILD_DATE := 2026-06-04T14:30:00
GIT_HASH := a1b2c3d
OS_NAME := Linux
BIN_api := build/api
BIN_monitor := build/monitor
BIN_worker := build/worker
```

Compruébalo leyéndolo como Makefile:

```bash
make -s -f build/manifest.mk --eval 'x: ; @echo $(BIN_worker)' x
# build/worker
```

## ✅ Requisitos verificables

Los comprueba `./scripts/verificar-semana.sh 08` desde la raíz del repositorio
(60 de los 100 puntos del Producto). Los otros 40 son de calidad: ver la
[rúbrica](../rubrica-evaluacion.md#-producto-30).

- [ ] make info lista los servicios descubiertos en services/, ordenados
- [ ] make info muestra un binario en build/ por servicio
- [ ] make info muestra el sistema operativo obtenido con $(shell)
- [ ] make info muestra el hash corto de git o sin-git
- [ ] make all desde cero compila los tres servicios y cada binario arranca
- [ ] make api compila solo build/api, con un target generado por $(eval)
- [ ] make run-worker compila y ejecuta solo build/worker, con un target generado por la plantilla
- [ ] Un directorio nuevo en services/ se compila sin editar el Makefile
- [ ] Una segunda ejecución de make all no recompila ningún servicio
- [ ] make generate escribe BUILT_SERVICES := api monitor worker en build/manifest.mk
- [ ] build/manifest.mk es un Makefile válido que define OS_NAME
- [ ] build/manifest.mk define BIN_<servicio> para cada servicio descubierto
- [ ] make clean elimina build/ por completo
- [ ] make clean se niega a borrar si BUILD está vacío
- [ ] El Makefile ejecuta las recetas con bash -eu -o pipefail
- [ ] El Makefile declara .DELETE_ON_ERROR

## Instrucciones de entrega

```bash
git add bootcamp/week-08-funciones_avanzadas/3-proyecto/
git commit -m "feat(week-08): proyecto - orquestador de microservicios auto-configurable"
```
