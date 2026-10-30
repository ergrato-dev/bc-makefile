# ============================================================
# app/module.mk — ejecutable hola, que enlaza con libgreet.a
# Rutas relativas a la RAÍZ del repo.
# ============================================================

# TODO 2: sigue el modelo de lib/module.mk:
#   - APP_SRCS := app/main.c
#   - APP_OBJS: los .o en $(BUILD_DIR), igual que LIB_OBJS
#   - APP := $(BUILD_DIR)/app/hola
#   - main.c incluye greet.h: añade -Ilib a CPPFLAGS solo para sus
#     objetos con una variable específica de target:
#       $(APP_OBJS): CPPFLAGS += -Ilib
#   - Regla de enlace: $(APP) depende de $(APP_OBJS) y de $(LIB);
#     receta: echo "[ld] $@" y $(CC) $(LDFLAGS) -o $@ $^
#   - Añade APP_OBJS a OBJS con +=
