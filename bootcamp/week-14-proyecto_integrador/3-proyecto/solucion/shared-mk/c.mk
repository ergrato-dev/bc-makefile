# shared-mk/c.mk — Binario C con dependencias de headers automáticas
# Requiere: APP_NAME y BUILD_DIR (build.mk). Fuentes en src/, headers en include/.
C_SRC_DIR ?= src
C_INC_DIR ?= include
CFLAGS    ?= -Wall -Wextra -std=c11 -O2

C_SRCS := $(wildcard $(C_SRC_DIR)/*.c)
C_OBJS := $(patsubst $(C_SRC_DIR)/%.c,$(BUILD_DIR)/obj/%.o,$(C_SRCS))
C_DEPS := $(C_OBJS:.o=.d)
C_BIN  := $(BUILD_DIR)/$(APP_NAME)-healthcheck

# build ya tiene receta en build.mk; aquí solo se le añade el binario.
build: $(C_BIN)

$(C_BIN): $(C_OBJS)
	$(CC) $(LDFLAGS) -o $@ $^

# -MMD escribe un .d con los headers que incluye cada .c; -MP añade una regla
# vacía por header para que borrar uno no rompa el build. El directorio es
# order-only: se crea antes, pero su fecha no recompila nada.
$(BUILD_DIR)/obj/%.o: $(C_SRC_DIR)/%.c | $(BUILD_DIR)/obj/
	$(CC) $(CFLAGS) -I$(C_INC_DIR) -MMD -MP -c $< -o $@

$(BUILD_DIR)/obj/:
	mkdir -p $@

# El test de infra ejecuta el binario; el lint, una pasada de solo sintaxis.
test: $(C_BIN)
LINT_CMD := $(CC) $(CFLAGS) -I$(C_INC_DIR) -fsyntax-only $(C_SRCS)
TEST_CMD := $(C_BIN)

-include $(C_DEPS)
