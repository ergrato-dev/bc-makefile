.PHONY: all build install test clean demo info help
.DEFAULT_GOAL := help

# FIX 4: ':=' (expansión inmediata) + sin autorreferencia
SOURCES := src/main.py

# FIX 5: fallback con '|| echo 0.0.0' cuando no hay tags git
VERSION := $(shell git describe --tags 2>/dev/null || echo 0.0.0)

# FIX 1: 'build' agregado a .PHONY — ahora siempre se ejecuta
build: ## Compilar el proyecto
	@mkdir -p build
	@echo "Compilando $(SOURCES)..."
	@echo "Build OK"

# FIX 2: TAB correcto en la receta de install
install: ## Instalar dependencias
	@echo "Instalando dependencias..."
	@echo "pip install -r requirements.txt  (simulado)"

# FIX 3: dependencia corregida 'install' (no 'instal')
test: install ## Ejecutar tests
	@echo "Ejecutando tests..."
	@echo "Tests OK"

clean: ## Limpiar artefactos
	@rm -rf build/
	@echo "Limpiado."

info: ## Mostrar información del proyecto
	@echo "Versión:  $(VERSION)"
	@echo "Sources:  $(SOURCES)"

demo: ## Verificar que todos los bugs están corregidos
	@echo "=== Makefile corregido ==="
	@echo "Versión:  $(VERSION)"
	@echo "Sources:  $(SOURCES)"
	@echo "Build OK: target build es PHONY, siempre ejecuta"
	@echo "Install:  TAB correcto"
	@echo "Test dep: install correcto"

help: ## Mostrar ayuda
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
		| awk 'BEGIN {FS = ":.*?## "}; {printf "  %-20s %s\n", $$1, $$2}'
