# Lab 03 — eval

**Duración estimada:** 50 minutos

## Objetivo

Generar targets Make dinámicamente con `$(eval)` + `$(call)` + `$(foreach)` para eliminar reglas duplicadas.

## Contexto

El `starter/Makefile` ejecuta cuatro suites de tests (`unit`, `integration`, `e2e`, `performance`). Cada suite tiene exactamente la misma estructura de target pero con distinto nombre. Si se agrega una quinta suite, hay que copiar y pegar otro bloque.

`$(eval text)` es la función que cierra el ciclo: parsea `text` como sintaxis Makefile real. Combinada con `$(call)` para parametrizar y `$(foreach)` para iterar, genera N reglas a partir de una sola plantilla:

```makefile
define SUITE_RULE
.PHONY: run-$(1)
run-$(1):
	@echo "[$(1)] ejecutando..."
endef

SUITES := unit integration
$(foreach s,$(SUITES),$(eval $(call SUITE_RULE,$(s))))
# → genera los targets run-unit y run-integration automáticamente
```

Nota: dentro del bloque `define`, `$(SUITES)` y `$(REPORTS)` se expanden cuando `$(call)` procesa la plantilla. Las variables automáticas (`$$@`, `$$<`) necesitan doble dólar — pero en este lab los targets son phony y no usan variables automáticas.

## Instrucciones

1. Entra al directorio starter:
   ```bash
   cd lab-03-eval/starter
   ```

2. Ejecuta `make all` y observa que funciona con los 4 targets hardcodeados.

3. Implementa los TODOs:
   - **TODO 1:** Define la plantilla `TEST_SUITE_RULE` que genera un target `run-$(1)` y escribe el reporte en `$(REPORTS)/$(1).txt`
   - **TODO 2:** Usa `$(foreach) + $(eval) + $(call)` para instanciar la plantilla
   - **TODO 3:** Elimina los 4 bloques `run-*` hardcodeados y reemplaza `all` para usar `$(foreach)`

4. Verifica:
   ```bash
   make all
   make run-unit
   make run-performance
   make demo
   ls reports/
   ```

## Criterios de éxito

```
$ make all
[unit] Ejecutando suite unit...
[unit] Reporte: reports/unit.txt
[integration] Ejecutando suite integration...
[integration] Reporte: reports/integration.txt
[e2e] Ejecutando suite e2e...
[e2e] Reporte: reports/e2e.txt
[performance] Ejecutando suite performance...
[performance] Reporte: reports/performance.txt
```

```
$ make demo
Suites:  unit integration e2e performance
Targets: run-unit run-integration run-e2e run-performance
Reportes: reports/unit.txt reports/integration.txt reports/e2e.txt reports/performance.txt
```

```
$ ls reports/
e2e.txt  integration.txt  performance.txt  unit.txt
```

## Reto extra

Agrega una variable `SLOW_SUITES := integration e2e performance`. Define una segunda plantilla `SLOW_RULE` que genera targets `run-slow-$(1)` que imprimen un mensaje de advertencia antes de ejecutar. Instanciala con `$(foreach)`.
