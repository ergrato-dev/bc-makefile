.PHONY: demo help
.DEFAULT_GOAL := help

SRCS         := src/main.c src/utils.c src/network.c src/config.c
OBJS         := $(patsubst src/%.c,build/%.o,$(SRCS))
TEST_BINS    := $(patsubst build/%.o,bin/%,$(OBJS))
RELEASE_SRCS := $(subst src,release,$(SRCS))
DEPS         := $(patsubst src/%.c,deps/%.d,$(SRCS))

demo: ## Muestra las transformaciones con patsubst y subst
	@echo "SRCS:         $(SRCS)"
	@echo "OBJS:         $(OBJS)"
	@echo "TEST_BINS:    $(TEST_BINS)"
	@echo "RELEASE_SRCS: $(RELEASE_SRCS)"
	@echo "DEPS:         $(DEPS)"

help: ## Muestra esta ayuda
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
		| awk 'BEGIN {FS = ":.*?## "}; {printf "  %-20s %s\n", $$1, $$2}'
