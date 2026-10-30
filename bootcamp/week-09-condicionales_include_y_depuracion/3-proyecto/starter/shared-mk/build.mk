# Módulo compartido: build.mk
# Variables requeridas: APP_NAME, VERSION
# Variables opcionales: BUILD_DIR (por defecto build), SRC_DIR (por defecto src)
# Targets: build, package, clean

# --------------------------------------------------------------------------
# TODO 1: Valores por defecto que el módulo importador puede cambiar.
#         Usa ?= para que frontend (BUILD_DIR := dist) gane.
#   BUILD_DIR ?= build
#   SRC_DIR   ?= src
# --------------------------------------------------------------------------

# --------------------------------------------------------------------------
# TODO 2: Variables derivadas:
#   SRCS     -> todos los archivos de SRC_DIR, ordenados ($(sort $(wildcard ...)))
#   ARTIFACT -> BUILD_DIR/APP_NAME-VERSION.txt
#   PACKAGE  -> BUILD_DIR/APP_NAME-VERSION.tar.gz
# --------------------------------------------------------------------------

.PHONY: build package clean

# --------------------------------------------------------------------------
# TODO 3: 'build' depende del ARTIFACT, y el ARTIFACT es un archivo real que
#         depende de SRCS. Su receta:
#         - crea el directorio del target ($(@D))
#         - escribe "app=<APP_NAME>", "version=<VERSION>" y el contenido de los fuentes
#         - imprime "[<APP_NAME>] Compilando <APP_NAME> <VERSION>"
#         Así una segunda pasada no rehace nada.
# --------------------------------------------------------------------------
build: ## Compilar el módulo (artefacto en BUILD_DIR)

# --------------------------------------------------------------------------
# TODO 4: 'package' depende de PACKAGE; PACKAGE depende de ARTIFACT y se crea
#         con tar -czf, entrando en el directorio del artefacto (tar -C) para
#         que el .tar.gz contenga solo APP_NAME-VERSION.txt.
# --------------------------------------------------------------------------
package: ## Empaquetar el artefacto en un .tar.gz

# --------------------------------------------------------------------------
# TODO 5: 'clean' borra BUILD_DIR con la guarda de la semana 03 y luego
#         imprime "[<APP_NAME>] Limpiando artefactos". La guarda va como
#         primera línea de la receta:
#   $(if $(BUILD_DIR),,$(error BUILD_DIR vacía: rm -rf no se ejecuta))
#   rm -rf -- '$(BUILD_DIR)'
# --------------------------------------------------------------------------
clean: ## Borrar BUILD_DIR
