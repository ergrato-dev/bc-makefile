.PHONY: all demo check-api check-worker check-monitor check-services urls space-trap clean help
.DEFAULT_GOAL := help

SERVICES := api worker monitor
BUILD    := build

# TODO 1: Define la función 'service_info' que recibe 2 argumentos:
# $1 = nombre del servicio, $2 = puerto
# Debe imprimir: "[<nombre>] URL: http://localhost:<puerto>"
# define service_info
# endef

# TODO 2: Define la función 'build_path' (una sola línea, no necesita define):
# $1 = nombre del servicio
# Devuelve: build/<nombre>/<nombre>
# build_path =

PORT_api     := 8080
PORT_worker  := 8081
PORT_monitor := 9090

# TODO 3: Reemplaza este bloque duplicado usando $(call service_info,...) y $(call build_path,...)
# El output debe ser idéntico.
demo: ## Mostrar información de servicios
	@echo "=== Servicios del sistema ==="
	@echo "[api] URL: http://localhost:8080"
	@echo "[worker] URL: http://localhost:8081"
	@echo "[monitor] URL: http://localhost:9090"
	@echo ""
	@echo "Rutas de build:"
	@echo "  api: build/api/api"
	@echo "  worker: build/worker/worker"
	@echo "  monitor: build/monitor/monitor"

# TODO 4: Reemplaza estos 3 targets con uno solo llamado 'check-services'
# que use $(call) y $(foreach) para iterar sobre $(SERVICES)
check-api: ## Verificar servicio api
	@mkdir -p $(BUILD)/api
	@echo "api OK"

check-worker: ## Verificar servicio worker
	@mkdir -p $(BUILD)/worker
	@echo "worker OK"

check-monitor: ## Verificar servicio monitor
	@mkdir -p $(BUILD)/monitor
	@echo "monitor OK"

check-services: check-api check-worker check-monitor ## Verificar todos los servicios

# TODO 5: Define 'svc_url' (una línea): $1 = servicio, devuelve http://localhost:<puerto>
# El puerto sale de la variable PORT_<servicio>: usa un nombre de variable calculado, $(PORT_$1)
# svc_url =

# TODO 6: Haz que 'urls' imprima la URL de los tres servicios con $(foreach) + $(call svc_url,...)
urls: ## Mostrar la URL de cada servicio
	@echo "TODO: implementa urls"

space-trap: ## Mostrar qué pasa con un espacio tras la coma en $(call)
	@echo "Sin espacio: [$(call build_path,api)]"
	@echo "Con espacio: [$(call build_path, api)]"

clean: ## Limpiar build
	$(if $(BUILD),,$(error BUILD vacía: rm -rf no se ejecuta))
	@rm -rf -- '$(BUILD)'
	@echo "Limpiado."

help: ## Mostrar ayuda
	@echo "Targets disponibles:"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
		| awk 'BEGIN {FS = ":.*?## "}; {printf "  %-20s %s\n", $$1, $$2}'
