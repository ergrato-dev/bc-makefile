.PHONY: demo help
.DEFAULT_GOAL := help

# Lista de fuentes de ejemplo (no necesitas crear estos archivos)
SRCS := src/main.c src/utils.c src/network.c src/config.c

# TODO: Usa $(patsubst src/%.c,build/%.o,$(SRCS)) para generar la lista de objetos
OBJS :=

# TODO: Usa $(patsubst build/%.o,bin/%,$(OBJS)) para generar binarios de prueba
TEST_BINS :=

# TODO: Usa $(subst src,release,$(SRCS)) para crear rutas de release
RELEASE_SRCS :=

demo: ## Muestra las transformaciones con patsubst y subst
	@echo "SRCS:         $(SRCS)"
	@echo "OBJS:         $(OBJS)"
	@echo "TEST_BINS:    $(TEST_BINS)"
	@echo "RELEASE_SRCS: $(RELEASE_SRCS)"

help: ## Muestra esta ayuda
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
		| awk 'BEGIN {FS = ":.*?## "}; {printf "  %-20s %s\n", $$1, $$2}'
