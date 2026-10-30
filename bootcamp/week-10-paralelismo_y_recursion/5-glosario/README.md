# Glosario — Semana 10: Paralelismo y recursión

| Término | Definición en una línea | Ejemplo en Makefile |
|---------|------------------------|---------------------|
| `-j N` / `--jobs` | Ejecuta hasta N recetas a la vez; sin número, sin límite | `make -j4 all` |
| Jobserver | Bolsa de fichas que comparte un `-j` entre el padre y todos sus sub-makes | `MAKEFLAGS= -j4 --jobserver-auth=3,4` |
| Carrera | Fallo que depende del orden de ejecución, casi siempre por una dependencia sin declarar | `page.txt:` lee `config.txt` sin listarlo |
| `-O` / `--output-sync` | Agrupa la salida de cada target (o línea, o sub-make) en lugar de mezclarla | `MAKEFLAGS += --output-sync=target` |
| `.NOTPARALLEL` | Target especial que ejecuta este Makefile en serie aunque se pase `-j` | `.NOTPARALLEL:` |
| `.WAIT` | **Make 4.4+.** En una lista de prerrequisitos, no empieza lo de la derecha hasta terminar lo de la izquierda | `rebuild: clean .WAIT all` |
| `--shuffle` | **Make 4.4+.** Baraja el orden de los prerrequisitos para destapar carreras; imprime la semilla | `make --shuffle=reverse all` |
| `-k` / `--keep-going` | Tras un fallo, sigue construyendo lo que no depende del target roto | `make -k test` |
| Sub-make | Invocación de Make lanzada desde la receta de otro Make | `$(MAKE) -C lib build` |
| `$(MAKE)` | Binario de Make en curso; marca la línea como recursiva (jobserver y `-n`) | `@$(MAKE) --no-print-directory -C $(@D) $(@F)` |
| Prefijo `+` | Marca una línea como recursiva aunque `$(MAKE)` no aparezca literal | `+$(SUBMAKE) -C lib` |
| `MAKEFLAGS` | Flags y variables de línea de comandos que heredan los sub-makes | `make all STAGE=prod` llega a cada hijo |
| `MAKELEVEL` | Profundidad de recursión: 0 en el raíz, 1 en un sub-make | `@echo "nivel $(MAKELEVEL)"` |
| Subdirectorio como target | Patrón que convierte cada pareja directorio/meta en un target phony del grafo | `$(MODULE_TARGETS): ; @$(MAKE) -C $(@D) $(@F)` |
| Make no recursivo | Un solo Make que incluye un fragmento por directorio en lugar de lanzar sub-makes | `include $(addsuffix /module.mk,$(MODULES))` |
