# Proyecto Semana 06 — Orquestador de Microservicios Auto-Configurable

**Duración estimada:** 2 horas 30 minutos

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
4. `make generate` — compila todo y genera `build/manifest.mk` con variables Make
5. `make clean` — elimina todo lo generado en `build/`

## Variables requeridas en el Makefile

| Variable | Cómo generarla | Valor esperado |
|----------|---------------|----------------|
| `SERVICES` | `$(notdir $(shell find services -mindepth 1 -maxdepth 1 -type d \| sort))` | `api monitor worker` |
| `BINS` | `$(foreach svc,$(SERVICES),$(BUILD)/$(svc))` | `build/api build/monitor build/worker` |
| `BUILD_DATE` | `$(shell date +%Y-%m-%dT%H:%M:%S)` | timestamp del build |
| `GIT_HASH` | `$(shell git rev-parse --short HEAD 2>/dev/null \|\| echo sin-git)` | hash corto |
| `OS_NAME` | `$(shell uname -s)` | `Linux` o `Darwin` |

## Plantilla requerida

```makefile
define SERVICE_RULE
.PHONY: $(1)

$(1): $(BUILD)/$(1)

$(BUILD)/$(1): services/$(1)/main.c
	@mkdir -p $(BUILD)
	$(CC) $(CFLAGS) $$< -o $$@
	@echo "Compilado: $$@"
endef
```

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

## Contenido esperado de `build/manifest.mk`

```makefile
BUILT_SERVICES := api monitor worker
BUILD_DATE := 2026-06-04T14:30:00
GIT_HASH := a1b2c3d
OS_NAME := Linux
# Generado automáticamente — no editar
```

## Rúbrica del proyecto (30 pts)

| Criterio | Puntos |
|----------|--------|
| `make info` muestra servicios auto-descubiertos correctamente | 8 |
| `make all` compila todos los servicios sin errores | 12 |
| Agregar un nuevo directorio en `services/` compila sin editar el Makefile | 10 |

## Instrucciones de entrega

```bash
git add bootcamp/week-06-funciones_avanzadas/3-proyecto/
git commit -m "feat(week-06): proyecto - orquestador de microservicios auto-configurable"
```
