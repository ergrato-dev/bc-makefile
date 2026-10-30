# shared-mk/python.mk — Dependencias Python con uv (nunca pip)
# Requiere: STAMPS (build.mk), pyproject.toml y uv.lock en el servicio.
UV ?= uv

# TODO: stamp $(STAMPS)/deps que depende de pyproject.toml y uv.lock, con
#       $(STAMPS)/ como prerrequisito order-only (|). Receta:
#         $(UV) sync --locked --quiet
#         @touch $@
# TODO: deps: $(STAMPS)/deps
# TODO: LINT_CMD := $(UV) run --no-sync flake8 src/
#       TEST_CMD := $(UV) run --no-sync pytest -q -p no:cacheprovider
