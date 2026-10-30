# Glosario — Semana 09: Condicionales, include y depuración

| Término | Definición en una línea | Ejemplo en Makefile |
|---------|------------------------|---------------------|
| `ifeq` | Directiva que inicia un bloque condicional si dos valores son iguales | `ifeq ($(ENV), production)` |
| `ifneq` | Directiva que inicia un bloque condicional si dos valores son distintos | `ifneq ($(CI),)` |
| `ifdef` | Directiva que evalúa si una variable está definida (aunque esté vacía) | `ifdef DEBUG` |
| `ifndef` | Directiva que evalúa si una variable NO está definida | `ifndef VERSION` |
| `endif` | Cierra cualquier bloque condicional `ifeq`, `ifdef`, etc. | `endif` |
| `include` | Directiva que inserta el contenido de otro archivo; falla si no existe | `include mk/build.mk` |
| `-include` | Variante de `include` que no falla si el archivo no existe | `-include .env` |
| Make recursivo | Patrón donde un Makefile invoca `$(MAKE)` en subdirectorios | `$(MAKE) -C api build` |
| `$(MAKE)` | Variable de Make que contiene la ruta del binario de Make actual | `$(MAKE) -C sub all` |
| `export` | Directiva que convierte una variable de Make en variable de entorno para submakes | `export SHARED_VAR` |
| `unexport` | Directiva que evita que una variable se propague a submakes | `unexport SECRET` |
| `override` | Modificador que permite que un target redefina una variable pasada por CLI | `override CFLAGS += -g` |
| `$(info ...)` | Función que imprime texto durante el parsing de Make (sin prefijo @) | `$(info VERSION = $(VERSION))` |
| `$(warning ...)` | Como `$(info)` pero imprime a stderr con número de archivo y línea | `$(warning Variable vacía)` |
| `$(error ...)` | Función que detiene Make inmediatamente con un mensaje de error | `$(error Falta API_KEY)` |
| `make -n` | Flag dry-run: muestra los comandos que se ejecutarían sin ejecutarlos | `make -n build` |
| `make --debug=b` | Flag de depuración básica: muestra por qué Make reconstruye cada target | `make --debug=b all` |
| `make -p` | Imprime la base de datos completa de Make: todas las reglas y variables | `make -p 2>/dev/null \| less` |
| módulo `.mk` | Archivo Make parcial que define targets y variables, importado con `include` | `include mk/colors.mk` |
