# shared-mk/node.mk — Dependencias Node.js con pnpm (nunca npm)
# Requiere: STAMPS (build.mk), package.json y pnpm-lock.yaml en el servicio.
PNPM ?= pnpm

# --frozen-lockfile: si package.json y pnpm-lock.yaml no cuadran, falla en
# lugar de reescribir el lockfile a escondidas.
$(STAMPS)/deps: package.json pnpm-lock.yaml | $(STAMPS)/
	$(PNPM) install --frozen-lockfile
	@touch $@

deps: $(STAMPS)/deps

LINT_CMD := $(PNPM) run lint
TEST_CMD := $(PNPM) test
