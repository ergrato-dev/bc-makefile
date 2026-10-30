# ============================================================
# lib — cuatro tareas independientes de un segundo cada una.
# Lo usa el Makefile raíz. No necesitas tocarlo.
# ============================================================

SHELL       := bash
.SHELLFLAGS := -eu -o pipefail -c
.DELETE_ON_ERROR:

TASKS := parser lexer codegen runtime
TRACE ?= /dev/null

.PHONY: all flags $(TASKS)
.DEFAULT_GOAL := all

all: $(TASKS)

# "start"/"end" en TRACE: el raíz cuenta cuántas tareas corren a la vez.
$(TASKS):
	@echo "start $@" >> '$(TRACE)'
	@echo "  [lib] $@"
	@sleep 1
	@echo "end $@" >> '$(TRACE)'

# Lo que recibe un sub-make de su padre.
flags:
	@echo "MAKE=$(MAKE)"
	@echo "MAKELEVEL=$(MAKELEVEL)"
	@echo "MAKEFLAGS=$(MAKEFLAGS)"
