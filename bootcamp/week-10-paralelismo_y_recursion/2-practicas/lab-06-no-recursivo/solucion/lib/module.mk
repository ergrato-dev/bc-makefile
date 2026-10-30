# ============================================================
# lib/module.mk — librería estática libgreet.a
# Lo incluye el Makefile raíz: no hay sub-make. Por eso las rutas
# son relativas a la RAÍZ del repo, no a lib/.
# ============================================================

LIB_SRCS := lib/greet.c
LIB_OBJS := $(LIB_SRCS:%.c=$(BUILD_DIR)/%.o)
LIB      := $(BUILD_DIR)/lib/libgreet.a

$(LIB): $(LIB_OBJS)
	@echo "[ar] $@"
	@$(AR) rcs $@ $^

OBJS += $(LIB_OBJS)
