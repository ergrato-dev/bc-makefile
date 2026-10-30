# shared-mk/python.mk — Dependencias Python con uv (nunca pip)
# Requiere: STAMPS (build.mk), pyproject.toml y uv.lock en el servicio.
UV ?= uv

# Stamp: uv sync solo corre si pyproject.toml o uv.lock son más nuevos que
# él. El directorio es order-only: su fecha cambia con cada archivo nuevo y
# no debe forzar reinstalaciones.
$(STAMPS)/deps: pyproject.toml uv.lock | $(STAMPS)/
	$(UV) sync --locked --quiet
	@touch $@

deps: $(STAMPS)/deps

# --no-sync: Make ya decidió si había que instalar; uv run solo ejecuta.
LINT_CMD := $(UV) run --no-sync flake8 src/
TEST_CMD := $(UV) run --no-sync pytest -q -p no:cacheprovider
