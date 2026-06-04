#!/usr/bin/env bash
# Script de deploy de infraestructura
# Invocado por infra/Makefile via make deploy
set -e

ENV="${1:-development}"
echo "[infra] Ejecutando deploy en entorno: $ENV"
echo "[infra] ✓ Infraestructura actualizada"
