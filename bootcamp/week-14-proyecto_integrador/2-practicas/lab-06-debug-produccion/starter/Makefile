# Makefile de producción con 5 errores intencionados
# Tu tarea: encontrar y corregir cada uno

# ERROR 1: ¿Qué tipo de expansión debería usar TIMESTAMP?
# Pista: ¿qué valor tendrá en todos los targets si se usa = ?
TIMESTAMP = $(shell date +%Y%m%d-%H%M%S)

# ERROR 2: hay un target en .PHONY que no existe
.PHONY: all build lint test ci deploy release help

APP_NAME  := mi-servicio
BUILD_DIR := build
VERSION   := 1.0.0
IMAGE     := $(APP_NAME):$(VERSION)

all: build ## Construir el proyecto

# ERROR 3: este target no está declarado en .PHONY pero crea un archivo llamado "build"
build: lint ## Compilar el servicio
	@echo "==> Compilando $(APP_NAME) $(VERSION) ..."
	@mkdir -p $(BUILD_DIR)
	@echo "$(VERSION)" > $(BUILD_DIR)/version.txt
	@touch build

lint: ## Verificar estilo del código
	@echo "==> Lint OK"

# ERROR 4: test y build no son independientes — test depende de build
# pero la dependencia no está declarada, causando condición de carrera con -j2
test:  ## Ejecutar tests
	@echo "==> Tests con build $(shell cat $(BUILD_DIR)/version.txt 2>/dev/null || echo FALTA)"

ci: lint test build ## Pipeline CI

# ERROR 5: espacios en lugar de TABs en la receta de deploy
deploy: ## Desplegar el servicio
    @echo "==> Desplegando $(IMAGE) ..."
    @echo "Timestamp: $(TIMESTAMP)"

help: ## Mostrar ayuda
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
		| awk 'BEGIN {FS = ":.*?## "}; {printf "  %-20s %s\n", $$1, $$2}'
