# Make como Orquestador DevOps

## ¿Por qué importa esto?

El problema de los pipelines CI/CD es la brecha entre local y remoto: el código pasa en local, falla en CI, y nadie entiende por qué. Make cierra esa brecha. Un `make ci` que corre idéntico en el laptop del desarrollador y en el runner de GitHub Actions elimina el "en mi máquina funciona". Esta semana no aprendes nuevas funciones de Make — aplicas las que ya conoces para construir infraestructura que protege la calidad del código antes de que llegue al servidor.

## Patrón: cargar `.env` sin filtrar secretos

```makefile
# -include (con guion): no falla si .env no existe
# Funciona en local con .env; en CI las vars ya existen en el entorno
-include .env
export DB_URL API_KEY   # solo lo que las recetas necesitan
```

El truco: en CI nunca habrá un `.env` — las variables las inyecta el runner. El `-include` hace que ambos contextos funcionen con el mismo Makefile.

Dos trampas: `export` sin argumentos manda **todas** las variables, secretos incluidos, a cada proceso; y `.env` se parsea como Makefile (`$` se expande, las comillas quedan literales, `#` corta el valor). Ignora todos los `.env*` salvo `.env.example`.

## Patrón: validar variables requeridas

```makefile
# Falla con mensaje claro si una variable no está definida
# Se comprueba en Make, sin pegar el valor del secreto en un comando de shell
guard-%:
	@$(if $($*),:,$(error $* no definida. Copia .env.example a .env))

deploy: guard-API_KEY guard-DB_URL ## Desplegar (requiere API_KEY y DB_URL)
	./deploy.sh
```

## Patrón: instalar git hooks desde Make

```makefile
# git lee los hooks de scripts/hooks/ (versionado): nada que copiar
hooks-install: ## Instalar git hooks
	@chmod +x scripts/hooks/*
	@git config core.hooksPath '$(CURDIR)/scripts/hooks'
	@echo "Hooks activos."

hooks-uninstall: ## Desinstalar git hooks
	@-git config --unset core.hooksPath
```

## Referencia rápida

| Patrón | Sintaxis | Cuándo usarlo |
|--------|----------|---------------|
| Cargar `.env` | `-include .env` + `export VAR1 VAR2` | Solo las variables que las recetas necesitan; nunca `export` a secas |
| Validar var requerida | `guard-%` target | Antes de deploy, build de producción |
| Pipeline en cadena | `ci: lint test build` | Target de entrada para CI |
| Instalar hooks | `git config core.hooksPath` | Setup inicial del repo. `--no-verify` los salta: el control real es CI |
| Fallar con mensaje | `@echo "..." && exit 1` | Error handling explícito |

## Ejemplo mínimo funcional

Pega esto en un directorio con git inicializado y ejecuta `make ci`:

```makefile
.PHONY: lint test build ci env-check help
.DEFAULT_GOAL := help

APP_NAME := mi-app
VERSION  := $(shell git describe --tags --always 2>/dev/null || echo 0.0.0)

-include .env

guard-%:
	@$(if $($*),:,$(error $* no definida. Ver .env.example))

lint: ## Verificar estilo
	@echo "→ Lint OK (sin herramientas reales en este ejemplo)"

test: ## Ejecutar tests
	@echo "→ Tests OK"

build: ## Construir artefacto
	@echo "→ Build $(APP_NAME):$(VERSION) OK"

ci: lint test build ## Pipeline completo
	@echo "✓ CI completado para $(APP_NAME) $(VERSION)"

env-check: guard-APP_NAME ## Verificar variables de entorno
	@echo "Variables de entorno OK"

help: ## Mostrar ayuda
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
		| awk 'BEGIN {FS = ":.*?## "}; {printf "  %-20s %s\n", $$1, $$2}'
```

---

Listo. Ve al [lab-01](../2-practicas/lab-01-env-secrets/README.md) y ponlo en práctica.
