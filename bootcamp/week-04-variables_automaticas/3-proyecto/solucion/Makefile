# ============================================================
# Proyecto Semana 04 — Solución: Build system C multi-archivo
# ============================================================

SHELL       := bash
.SHELLFLAGS := -eu -o pipefail -c
.DELETE_ON_ERROR:

.PHONY: all dist clean help

.DEFAULT_GOAL := help

# ── Compilador ────────────────────────────────────────────────
CC      := gcc
CFLAGS  ?= -Wall -Wextra -std=c11
LDFLAGS :=

# ── Rutas ─────────────────────────────────────────────────────
SRC_DIR   := src
BUILD_DIR := build
INC_DIR   := include
APP       := $(BUILD_DIR)/app
DIST_DIR  := dist

# ── Empaquetado ───────────────────────────────────────────────
VERSION ?= 1.0.0
TARBALL := $(DIST_DIR)/app-$(VERSION).tar.gz

# ── Fuentes y objetos ─────────────────────────────────────────
SRCS := $(wildcard $(SRC_DIR)/*.c)
OBJS := $(SRCS:$(SRC_DIR)/%.c=$(BUILD_DIR)/%.o)
# Un .d por objeto: los escribe gcc con -MMD (headers que incluye cada .c)
DEPS := $(OBJS:.o=.d)

all: $(APP) ## compila el proyecto completo

# $^ = todos los .o (el linker los necesita todos)
# $@ = ruta del binario final
$(APP): $(OBJS)
	$(CC) $(LDFLAGS) $^ -o $@
	@echo "[link] $@ listo."

# $<    = el único .c fuente (gcc -c toma un solo fuente)
# $@    = la ruta del .o de salida
# $(@D) = el directorio del .o (build/); mkdir -p lo crea si no existe
# -MMD -MP: genera build/x.d para que cambiar un header recompile lo necesario
$(BUILD_DIR)/%.o: $(SRC_DIR)/%.c
	@mkdir -p $(@D)
	$(CC) $(CFLAGS) -MMD -MP -I$(INC_DIR) -c $< -o $@
	@echo "[cc]   $< → $@"

# Con guion: la primera vez los .d aún no existen
-include $(DEPS)

dist: $(TARBALL) ## empaqueta el binario en dist/app-$(VERSION).tar.gz

# $(@D) = dist (se crea si falta); $(<D) = build y $(<F) = app:
# tar entra en el directorio del binario y guarda solo su nombre
$(TARBALL): $(APP)
	@mkdir -p $(@D)
	tar -czf $@ -C $(<D) $(<F)
	@echo "[dist] $@ listo."

clean: ## elimina todos los artefactos de build
	$(if $(BUILD_DIR),,$(error BUILD_DIR vacía: rm -rf no se ejecuta))
	$(if $(DIST_DIR),,$(error DIST_DIR vacía: rm -rf no se ejecuta))
	@rm -rf -- '$(BUILD_DIR)' '$(DIST_DIR)'
	@echo "[clean] Listo."

help: ## muestra esta ayuda
	@echo "Uso: make [target] [CC=compilador] [CFLAGS=flags] [VERSION=x.y.z]"
	@grep -hE '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
		| awk 'BEGIN {FS = ":.*?## "}; {printf "  %-20s %s\n", $$1, $$2}'
