# Makefile con 5 bugs — encuéntralos y corrígelos
# Pista: ejecuta cada target y lee el mensaje de error con atención

# BUG 1: 'build' no está en .PHONY — si existe un directorio build/, este target nunca se ejecuta
# Solución: agregar 'build' a la lista de .PHONY
.PHONY: all install test clean demo info help

# BUG 4: Variable recursiva que causa expansión infinita con '='
# Solución: cambiar '=' por ':=' y eliminar la autorreferencia
SOURCES = $(SOURCES) src/main.py

VERSION := $(shell git describe --tags 2>/dev/null || echo 0.0.0)

build: ## Compilar el proyecto
	@mkdir -p build
	@echo "Compilando $(SOURCES)..."
	@echo "Build OK"

install: ## Instalar dependencias
    pip install -r requirements.txt

# BUG 3: dependencia con typo — 'instal' no existe como target
# Solución: cambiar 'instal' por 'install'
test: instal ## Ejecutar tests
	@echo "Ejecutando tests..."
	@echo "Tests OK"

clean: ## Limpiar artefactos
	@rm -rf build/
	@echo "Limpiado."

# BUG 5: $(shell git describe --tags) sin fallback — devuelve string vacío si no hay tags
# Solución: agregar '|| echo 0.0.0' al final del comando shell
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
