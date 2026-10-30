# Módulo compartido: test.mk
# Variables requeridas: APP_NAME, VERSION, ARTIFACT (la define build.mk)
# Targets: test

.PHONY: test

test: $(ARTIFACT) ## Comprobar que el artefacto declara la versión correcta
	@echo "[$(APP_NAME)] Ejecutando tests..."
	@grep -qx 'version=$(VERSION)' $< || \
		{ echo "[$(APP_NAME)] FALLO: $< no declara version=$(VERSION)"; exit 1; }
	@echo "[$(APP_NAME)] Tests OK"
