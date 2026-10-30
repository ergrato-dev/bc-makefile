# Lab 04 — Testing de Makefiles

⏱ Duración estimada: ~60 min

## Objetivo

Construir un target `check` que pruebe el propio Makefile (variables indefinidas, dry-run de referencia, builds aislados y `make -q`) y corregir los dos bugs que destapa.

## Contexto

- Un Makefile es código y se rompe como código: un typo en una variable se expande a vacío sin avisar, y una dependencia que falta "funciona" mientras el orden de `all` la tape.
- Make trae sus propias herramientas de prueba: `--warn-undefined-variables`, `-n` (qué haría), `-q` (¿está al día? exit 0 sí, 1 no, 2 error) y, desde 4.4, `--shuffle`.
- Un target `check` las junta en algo que el CI puede ejecutar en cada PR. Cada línea debe **fallar** si el Makefile tiene el problema que comprueba.

## Instrucciones

Trabaja en `starter/`. Ejecuta `make all` y `cat build/report.txt`: todo parece correcto. No lo está.

1. **Variables indefinidas.**
   ```bash
   make --warn-undefined-variables -n -B all
   ```
   Aparece `warning: undefined variable 'REPORT_TITLE'`, y por eso `make all` imprime `Informe '' listo`. Corrige el typo (la variable es `TITLE`). Añádelo al `check` (TODO) como primera prueba:
   ```makefile
   SUBMAKE := $(MAKE) --no-print-directory
   ```
   ```makefile
   	@echo "1/4 sin variables indefinidas"
   	@out=$$($(SUBMAKE) --warn-undefined-variables -n -B all 2>&1) \
   		&& ! grep 'undefined variable' <<<"$$out"
   ```
   Se guarda la salida en una variable y después se busca: con `make ... | grep` y `pipefail`, un fallo de `make` podría quedar tapado por el código de salida de `grep`.

2. **Dry-run de referencia (golden test).** Guarda lo que hace hoy el Makefile y compáralo en cada ejecución:
   ```bash
   mkdir -p tests
   make -n -B all > tests/dry-run.expected
   cat tests/dry-run.expected
   ```
   ```makefile
   	@echo "2/4 el dry-run coincide con tests/dry-run.expected"
   	@$(SUBMAKE) -n -B all | diff -u tests/dry-run.expected -
   ```
   Pruébalo: cambia `printf '# %s\n'` por `printf '## %s\n'` en la receta de `header.txt`, ejecuta `make check` y lee el diff. Un cambio de receta que nadie pidió aparece en la revisión del PR. Deshaz el cambio.

3. **`make -q`: ¿está al día?**
   ```bash
   make all; make -q build/report.txt; echo $?
   touch data/q1.csv; make -q build/report.txt; echo $?
   ```
   Debes ver `0` y luego `1`. Un CI puede usarlo para comprobar que una segunda pasada no rehace nada. Añade:
   ```makefile
   	@echo "4/4 tras construir, make -q dice que todo está al día"
   	@$(SUBMAKE) -s BUILD_DIR='$(SELFTEST)/c' all
   	@$(SUBMAKE) -q BUILD_DIR='$(SELFTEST)/c' all
   ```
   con `SELFTEST := $(BUILD_DIR)/selftest` definido arriba. Cada prueba usa su propia carpeta para no pisar tu `build/`.

4. **Builds aislados y el `check` completo.** Construye un target desde cero, sin la ayuda del orden de `all`:
   ```bash
   make clean; make build/report.txt
   ```
   Falla: `cat: build/header.txt: No such file or directory`. La receta lee `header.txt`, pero no lo declara. Con `make all` funciona por casualidad, porque `all` lista `header.txt` primero. Añade la prueba 3:
   ```makefile
   	@echo "3/4 cada target se construye aislado, desde cero"
   	@$(SUBMAKE) -s BUILD_DIR='$(SELFTEST)/a' '$(SELFTEST)/a/report.txt'
   	@$(SUBMAKE) -s BUILD_DIR='$(SELFTEST)/b' '$(SELFTEST)/b/total.txt'
   ```
   Ejecuta `make check`: debe fallar en `3/4`. Corrige la regla (`$(BUILD_DIR)/report.txt: $(BUILD_DIR)/total.txt $(BUILD_DIR)/header.txt`) y vuelve a generar `tests/dry-run.expected` (cambió). Abre y cierra el `check` con la limpieza de su carpeta, con guarda:
   ```makefile
   	$(if $(BUILD_DIR),,$(error BUILD_DIR vacía: rm -rf no se ejecuta))
   	@rm -rf -- '$(SELFTEST)'
   ```
   y termina con `@rm -rf -- '$(SELFTEST)'` y `@echo "check: OK"`.

5. **`--shuffle`.**

   > [!NOTE]
   > **Make 4.4+.** `make --shuffle all` construye los prerrequisitos en orden aleatorio y `--shuffle=reverse` en orden inverso. Vuelve a quitar `header.txt` de la regla y ejecuta `make clean; make --shuffle=reverse all`: falla al instante. Con `--shuffle` a secas falla unas veces sí y otras no; el número de semilla que imprime (`shuffle=1234`) permite repetirlo con `--shuffle=1234`.
   > **Alternativa en 4.3:** la prueba 3 del paso 4, construir cada target aislado desde cero, detecta lo mismo de forma determinista.

   Si no tienes 4.4, puedes probarlo con Docker:
   ```bash
   docker run --rm -v "$PWD":/w -w /w debian:13 \
     bash -c 'apt-get update -qq && apt-get install -y -qq make >/dev/null && make clean && make --shuffle=reverse all'
   ```

## Criterios de éxito

- [ ] `make --warn-undefined-variables -n -B all` no muestra ningún aviso
- [ ] `make clean; make build/report.txt` funciona sin pasar por `all`
- [ ] `tests/dry-run.expected` existe y coincide con `make -n -B all`
- [ ] `make check` imprime `1/4` … `4/4` y `check: OK`, y sale con 0
- [ ] Si vuelves a meter cualquiera de los dos bugs, `make check` sale con error
- [ ] `make check` no deja nada en `build/selftest/`

## Reto extra

Añade una prueba 5 que compruebe que cambiar `TITLE` regenera el informe:
`make all TITLE=Otro` debería reconstruir `header.txt`, y hoy no lo hace porque
el archivo no depende de la variable. Resuélvelo con un archivo "sello" que
guarde el valor (`build/.title`) y que solo se reescriba si cambia.
