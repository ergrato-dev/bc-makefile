# shared-mk/node.mk — Dependencias Node.js con pnpm (nunca npm)
# Requiere: STAMPS (build.mk), package.json y pnpm-lock.yaml en el servicio.
PNPM ?= pnpm

# TODO: stamp $(STAMPS)/deps que depende de package.json y pnpm-lock.yaml,
#       con $(STAMPS)/ order-only. Receta:
#         $(PNPM) install --frozen-lockfile
#         @touch $@
# TODO: deps: $(STAMPS)/deps
# TODO: LINT_CMD := $(PNPM) run lint
#       TEST_CMD := $(PNPM) test
