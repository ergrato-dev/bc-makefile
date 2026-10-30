# shared-mk/c.mk — Binario C con dependencias de headers automáticas
# Requiere: APP_NAME y BUILD_DIR (build.mk). Fuentes en src/, headers en include/.
C_SRC_DIR ?= src
C_INC_DIR ?= include
CFLAGS    ?= -Wall -Wextra -std=c11 -O2

# TODO: C_SRCS con $(wildcard), C_OBJS en $(BUILD_DIR)/obj/ con $(patsubst),
#       C_DEPS = los .d de cada objeto, C_BIN := $(BUILD_DIR)/$(APP_NAME)-healthcheck
# TODO: build: $(C_BIN)   (sin receta: build.mk ya tiene la suya)
# TODO: enlazar $(C_BIN) desde $(C_OBJS) con $^ y $@
# TODO: regla de patrón $(BUILD_DIR)/obj/%.o: $(C_SRC_DIR)/%.c con el
#       directorio como order-only, compilando con -I$(C_INC_DIR) -MMD -MP
# TODO: test: $(C_BIN); LINT_CMD con -fsyntax-only; TEST_CMD := $(C_BIN)
# TODO: -include $(C_DEPS) al final
