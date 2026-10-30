# Módulo compartido: test.mk
# Variables requeridas: APP_NAME, VERSION, ARTIFACT (la define build.mk)
# Targets: test

.PHONY: test

# --------------------------------------------------------------------------
# TODO: 'test' depende de ARTIFACT y:
#       - imprime "[<APP_NAME>] Ejecutando tests..."
#       - comprueba con grep -qx que el artefacto contiene la línea
#         version=<VERSION>; si no, imprime un FALLO y sale con exit 1
#       - imprime "[<APP_NAME>] Tests OK"
# --------------------------------------------------------------------------
test: ## Comprobar que el artefacto declara la versión correcta
