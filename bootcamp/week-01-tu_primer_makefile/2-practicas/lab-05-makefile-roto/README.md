# Lab 05 — Depurar un Makefile roto

⏱ Duración estimada: ~60 min

## Objetivo

Diagnosticar y corregir cuatro errores reales en un Makefile usando los mensajes de error de Make como guía.

## Contexto

Los errores de Make son crípticos al principio. Este lab te expone a los cuatro más frecuentes para que los reconozcas de inmediato en proyectos reales. No busques las respuestas directamente en la solución — intenta leer el mensaje de error y razonarlo primero.

Los cuatro errores en `starter/Makefile`:

| # | Tipo de error | Síntoma en Make |
|---|---------------|-----------------|
| 1 | Espacios en lugar de TAB en la receta | `missing separator. Stop.` |
| 2 | Dependencia circular | `Circular dependency dropped.` |
| 3 | Target de archivo sin `.PHONY` (hay archivo `test` en el dir) | `make: 'test' is up to date` |
| 4 | Referencia a target inexistente como dependencia | `No rule to make target 'X'` |

## Instrucciones

1. Ejecuta `make all` y lee el error:
   ```bash
   make all
   ```
   Debes ver:
   ```
   Makefile:25: *** missing separator.  Stop.
   ```
   El número tras `Makefile:` es la línea exacta donde Make dejó de entender
   el archivo.

2. **Error 1 — separador faltante.** Antes de editar, haz visibles los TAB:
   ```bash
   cat -A Makefile | sed -n '22,27p'
   ```
   Una receta correcta empieza por `^I` (un TAB); las líneas rotas empiezan con
   cuatro espacios:
   ```
   build:$
       @echo "Compilando..."$
   ```
   Corrige las cuatro líneas de la receta de `build` usando TAB y repite el
   `cat -A` hasta ver `^I@echo "Compilando..."$`.

3. Vuelve a ejecutar `make all`. Ya no se detiene, pero aparece un aviso y
   `make all` termina con código 0:
   ```
   make: Circular test <- all dependency dropped.
   ```

4. **Error 2 — dependencia circular.** Identifica qué par de targets se llaman
   mutuamente (`all` depende de `test`, y `test` de `all`). Rompe el ciclo
   eliminando la dependencia incorrecta.

5. **Error 3 — archivo fantasma.** `make all` ya no avisa, pero tampoco ejecuta
   los tests: no aparece `Ejecutando tests...`. Ejecuta `ls` en la carpeta del
   lab: hay un archivo llamado `test`. Agrega ese target al `.PHONY`, junto con
   `verify` y `validate-output`.

6. **Error 4 — target inexistente.** Este no salta con `make all`. Ejecuta:
   ```bash
   make validate-output
   ```
   Debes ver `No rule to make target 'validate', needed by 'validate-output'`.
   Busca dónde se referencia `validate` y corrige el nombre (hay un typo).

7. Verifica que todo funciona:
   ```bash
   make all
   make test
   make validate-output
   make clean
   ```
   `make validate-output` debe terminar con `Binario encontrado.` y
   `Salida validada.`

8. **Comprueba sin ejecutar.** Usa el modo de ensayo para revisar el orden:
   ```bash
   make -n all
   ```
   Debes ver los seis comandos (cuatro de `build`, dos de `test`) impresos sin
   ejecutarse, y `ls` confirma que no se creó `output/`. Usa `make -n` siempre que
   vayas a lanzar un target que no conoces.

## Criterios de éxito

- [ ] `cat -A Makefile` muestra `^I` al inicio de todas las líneas de receta
- [ ] `make all` corre sin errores ni avisos e imprime `Tests OK`
- [ ] `make test` ejecuta la receta aunque exista un archivo `test` en el directorio
- [ ] `make validate-output` imprime `Salida validada.`
- [ ] `make -n all` lista los comandos sin crear `output/`
- [ ] `make clean` limpia sin errores
- [ ] Puedes explicar cada error y su causa

## Reto extra

Rompe tú el Makefile corregido de una quinta forma (por ejemplo, un target
que dependa de un archivo que no existe, o una receta antes de cualquier
target) y anota el mensaje exacto de Make. Pásaselo a un compañero: ¿llega a la
causa solo con el mensaje?
