# Glosario — Semana 09: Condicionales, include y depuración

| Término | Definición en una línea | Ejemplo en Makefile |
|---------|------------------------|---------------------|
| `ifeq` / `ifneq` | Bloque condicional que compara dos textos al leer el Makefile | `ifeq ($(ENV),production)` |
| `ifdef` / `ifndef` | Bloque condicional que pregunta si una variable tiene valor no vacío (`CI=` cuenta como vacía) | `ifdef CI` |
| Fase de lectura | Primera pasada de Make: asigna variables, evalúa condicionales e `include`; no ve variables de target | `$(info leyendo $(MAKEFILE_LIST))` |
| `include` | Inserta el texto de otro Makefile en ese punto; falla si no existe y no hay regla para crearlo | `include ../shared-mk/build.mk` |
| `-include` | Como `include`, pero no falla si el archivo no existe | `-include mk/local.mk` |
| Include generado | Archivo incluido que tiene regla: Make lo rehace y vuelve a leer todo | `version.mk: VERSION` |
| `unexport` | Impide que una variable, incluida una del entorno, llegue a sub-makes y recetas | `unexport SECRET_VAR` |
| `override` | Hace que una asignación del Makefile gane a la línea de comandos | `override CFLAGS += -fPIC` |
| `MAKELEVEL` | Profundidad de recursión: 0 en el make raíz, 1 en su sub-make | `$(info nivel $(MAKELEVEL))` |
| `$(warning ...)` | Imprime un aviso con archivo y línea y deja seguir a Make | `$(warning No hay fuentes en src/)` |
| `MAKE_VERSION` | Versión del GNU Make que está leyendo el archivo | `$(firstword $(sort $(MAKE_VERSION) 4.3))` |
| `.FEATURES` | Lista de capacidades que anuncia esta versión de Make | `$(filter grouped-target,$(.FEATURES))` |
| `MAKECMDGOALS` | Targets pedidos en la línea de comandos | `ifneq ($(filter publish,$(MAKECMDGOALS)),)` |
| `--trace` | Muestra qué línea del Makefile rehace cada target y por qué | `make --trace all` |
| `--warn-undefined-variables` | Avisa de cada referencia a una variable que no existe | `make --warn-undefined-variables all` |
