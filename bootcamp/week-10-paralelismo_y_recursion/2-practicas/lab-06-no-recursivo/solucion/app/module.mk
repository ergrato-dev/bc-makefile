# ============================================================
# app/module.mk — ejecutable hola, que enlaza con libgreet.a
# Rutas relativas a la RAÍZ del repo.
# ============================================================

APP_SRCS := app/main.c
APP_OBJS := $(APP_SRCS:%.c=$(BUILD_DIR)/%.o)
APP      := $(BUILD_DIR)/app/hola

# main.c incluye greet.h: solo sus objetos necesitan -Ilib.
$(APP_OBJS): CPPFLAGS += -Ilib

# $(LIB) viene de lib/module.mk. Los prerrequisitos se expanden al leer
# esta línea: lib/module.mk tiene que estar incluido ANTES que este.
$(APP): $(APP_OBJS) $(LIB)
	@echo "[ld] $@"
	@$(CC) $(LDFLAGS) -o $@ $^

OBJS += $(APP_OBJS)
