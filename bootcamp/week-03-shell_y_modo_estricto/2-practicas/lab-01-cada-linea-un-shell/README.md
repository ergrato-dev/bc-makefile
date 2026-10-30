# Lab 01 — Cada línea, un shell nuevo

⏱ Duración estimada: ~60 min

## Objetivo

Corregir cinco recetas que fallan porque cada línea de receta se ejecuta en un shell distinto, y comprobar la trampa de `.ONESHELL`.

## Contexto

- Make lanza un proceso de shell **por cada línea** de receta. Un `cd`, una variable de shell o un `export` desaparecen al terminar su línea.
- Make expande `$` antes que el shell. Para que el shell reciba un `$`, escribe `$$`.
- `.ONESHELL:` manda la receta entera a un solo shell, pero afecta a todo el Makefile y, sin `-e`, oculta los fallos intermedios.

## Instrucciones

Trabaja en `starter/`. Los pasos 2 a 6 tienen un `# TODO (paso N)` en el `Makefile`.

1. Prepara los datos y mira la ayuda:
   ```bash
   cd starter
   make
   make prepare
   ```
   `make prepare` crea `build/enero.txt` y `build/febrero.txt`.

2. Ejecuta `make where`. Esperarías ver `build/` y sus dos `.txt`:
   ```
   cd build
   pwd
   .../lab-01-cada-linea-un-shell/starter
   ls
   Makefile
   build
   oneshell.mk
   ```
   El `cd` se ejecutó en su propio shell, que terminó en esa misma línea. Une los tres comandos en una línea con `&&`:
   `cd $(BUILD_DIR) && pwd && ls`. Usa `&&` y no `;`: si el `cd` falla, `ls` no debe ejecutarse en el directorio equivocado.
   Ahora `make where` imprime `.../starter/build`, `enero.txt` y `febrero.txt`.

3. Ejecuta `make package`:
   ```
   tar: enero.txt: Cannot stat: No such file or directory
   tar: febrero.txt: Cannot stat: No such file or directory
   tar: Exiting with failure status due to previous errors
   make: *** [Makefile:28: package] Error 2
   ```
   Ejecuta `ls`: `tar` dejó un `reportes.tar.gz` roto **en el directorio del lab**, no en `build/`. Bórralo (`rm reportes.tar.gz`) y arregla la receta igual que en el paso 2. Verifica:
   ```bash
   make package
   tar -tzf build/reportes.tar.gz
   ```
   ```
   enero.txt
   febrero.txt
   ```
   Los nombres salen sin el prefijo `build/`: el `tar` se ejecutó dentro de `build/`.

4. Ejecuta `make greet`. Imprime `hola, ` sin nombre: `DESTINO=mundo` se asignó en un shell y el `echo` corrió en otro. Ponlas en la misma línea separadas por `;`. Debe imprimir `hola, mundo`.

5. Ejecuta `make home`. Imprime `Tu HOME es OME`. Make leyó `$HOME` como la variable de Make `$(H)` (vacía) seguida de `OME`. Cambia `$HOME` por `$$HOME` y vuelve a ejecutar: verás tu directorio real. Mira la línea que Make imprime antes de ejecutar: `echo "Tu HOME es $HOME"`. Eso es lo que recibe el shell.

6. Implementa `count` con un bucle `for` de shell partido en tres líneas de Makefile unidas por `\`:
   ```makefile
   count: prepare
   	@for f in $(BUILD_DIR)/*.txt; do \
   		echo "$$f -> $$(cat "$$f")"; \
   	done
   ```
   Make une las líneas terminadas en `\` y se las pasa a un solo shell, así que el `;` antes de cada `\` es obligatorio. `make count` debe imprimir:
   ```
   build/enero.txt -> enero
   build/febrero.txt -> febrero
   ```
   Quita un `$` de `$$f` y observa qué pasa: Make expande `$f` (vacía) y el shell recibe `echo " -> ..."`.

7. Ahora la alternativa: `.ONESHELL`. Ejecuta:
   ```bash
   make -f oneshell.mk deploy; echo "código de salida: $?"
   ```
   ```
   comprobando artefactos en .../starter/build
   desplegado
   código de salida: 0
   ```
   El `cd` sí persistió (todo va a un shell), pero `test -f marzo.txt` falló y aun así se imprimió `desplegado` con salida 0: Make solo ve el código de salida del **último** comando. Añade en `oneshell.mk`, encima de `.ONESHELL:`, las dos líneas que lo arreglan (las explica el lab-02):
   ```makefile
   SHELL       := bash
   .SHELLFLAGS := -eu -o pipefail -c
   ```
   Ahora `deploy` termina con `make: *** [oneshell.mk:...: deploy] Error 1` y no imprime `desplegado`.

8. Limpia:
   ```bash
   make clean
   ```

## Criterios de éxito

- [ ] `make where` imprime la ruta de `build/` y lista `enero.txt` y `febrero.txt`
- [ ] `tar -tzf build/reportes.tar.gz` lista `enero.txt` y `febrero.txt`, sin prefijo `build/`
- [ ] `make greet` imprime `hola, mundo`
- [ ] `make home` imprime tu directorio real, no `OME`
- [ ] `make count` imprime las dos líneas `build/<mes>.txt -> <mes>`
- [ ] `make -f oneshell.mk deploy` termina con error y no imprime `desplegado`
- [ ] Puedes explicar por qué `.ONESHELL` no se puede activar solo para un target

## Reto extra

En `oneshell.mk`, cambia la primera línea de la receta de `deploy` por `@cd $(BUILD_DIR)` y ejecuta `make -f oneshell.mk deploy`. ¿Qué líneas dejan de mostrarse? Ahora pon `@` delante de la **segunda** línea en vez de la primera. Con `.ONESHELL`, Make solo mira los prefijos `@`, `-` y `+` de la primera línea de la receta. Escribe en un comentario qué consecuencia tiene eso para un `-` que alguien pone en mitad de una receta pensando que ignora solo ese comando.
