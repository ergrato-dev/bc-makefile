# Glosario — Semana 01

| Término | Definición en una línea | Ejemplo en Makefile |
|---------|------------------------|---------------------|
| **target** | Nombre del artefacto o acción a construir | `build:` |
| **dependencia** | Target o archivo que debe existir antes de ejecutar la receta | `build: src/main.c` |
| **receta** | Comandos de shell que produce el target; indentada con TAB | `	gcc -o app main.c` |
| **TAB** | Caracter de indentación obligatorio en recetas (no espacios) | El caracter `\t` al inicio de cada línea de receta |
| **.PHONY** | Declaración que indica que un target no produce un archivo | `.PHONY: clean build help` |
| **`$(MAKE)`** | Variable que contiene el comando make actual; útil para sub-makes | `$(MAKE) -C subdir` |
| **`.DEFAULT_GOAL`** | Target ejecutado cuando se invoca `make` sin argumentos | `.DEFAULT_GOAL := help` |
| **`$(shell ...)`** | Captura el output de un comando de shell como string | `DATE := $(shell date +%F)` |
| **`@`** | Prefijo que suprime la impresión del comando antes de ejecutarlo | `@echo "Hola"` |
| **`$(MAKEFILE_LIST)`** | Variable automática con la lista de Makefiles cargados | `grep -E '^## ' $(MAKEFILE_LIST)` |
| **`make -n`** | Dry-run: muestra qué ejecutaría make sin ejecutarlo | `make -n build` |
| **`make -B`** | Fuerza re-ejecución aunque los targets estén al día | `make -B build` |
| **`MAKE_VERSION`** | Variable que Make define con su propia versión | `@echo "GNU Make $(MAKE_VERSION)"` |
| **`gmake`** | Nombre con el que Homebrew instala GNU Make en macOS para no pisar el `make` 3.81 | `gmake build` (en lugar de `make build`) |
