# Lab 06 — Shell roto: siete fallos en un Makefile de eventos

⏱ Duración estimada: ~60 min

## Objetivo

Diagnosticar y corregir siete fallos de shell y de modo estricto en un Makefile que procesa un log de eventos, partiendo solo de sus síntomas.

## Contexto

- Este Makefile "funciona" a ratos: varios fallos están tapados por otros. Al arreglar uno, aparece el siguiente (al activar `pipefail` saldrá a la luz un `grep` que antes pasaba).
- Tienes la tabla de síntomas, no la ubicación de los bugs. Usa `make -n <target>` para ver qué recibe el shell y `echo $?` para ver el código de salida real.
- Datos: `data/eventos.csv` (`fecha,nivel,mensaje`, sin ningún `WARN`), `data/eventos-corrupto.csv` (línea 4 sin mensaje) y `data/vacio.csv` (vacío).

## Los siete bugs

| Bug | Síntoma observable | Cómo reproducirlo |
|:--:|---|---|
| A | `check` imprime `[[: not found` y aun así dice `datos OK`, incluso con un CSV vacío | `make check DATA=data/vacio.csv` |
| B | Un CSV corrupto imprime `línea corrupta`, pero el build termina con código 0 | `make -B levels DATA=data/eventos-corrupto.csv; echo $?` |
| C | Tras arreglar B, la segunda ejecución da por bueno el `levels.txt` a medias | El comando de B, y después el mismo **sin** `-B` |
| D | `archive` falla con `tar: levels.txt: Cannot stat` y deja un `eventos.tar.gz` en la carpeta del lab | `make archive` |
| E | `list` imprime `: 8 líneas` sin el nombre del archivo | `make list` |
| F | Tras arreglar B, `warnings` falla aunque el CSV es correcto | `make -B warnings` |
| G | `clean` imprime `rm -rf ` y `build/` sigue ahí | `make clean; ls` |

## Instrucciones

1. Entra en `starter/` y reproduce los síntomas en el orden de la tabla. Mientras `clean` esté roto, limpia a mano con `rm -rf build` y borra el `eventos.tar.gz` que deje `tar` fuera de sitio.

2. Para cada bug, antes de tocar nada, explica la causa en una frase. Si no la ves:
   - A y B: ¿qué shell ejecuta las recetas y con qué flags? `make -p __nada__ 2>/dev/null | grep -E '^(SHELL|[.]SHELLFLAGS)'`
   - C: ¿qué hace Make con un target cuya receta falla? (lab-04)
   - D y E: `make -n archive` y `make -n list` muestran lo que recibe el shell (lab-01)
   - F: ¿con qué código sale `grep` cuando no encuentra nada? (lab-03)
   - G: ¿existe la variable que usa la receta? `make --warn-undefined-variables clean`

3. Corrige cada bug con el cambio mínimo y escribe debajo, **en columna 0**, un comentario `# FIX: <letra> — qué cambiaste y por qué`. No pongas el comentario indentado con TAB dentro de la receta.

4. Al terminar, todos estos comandos deben comportarse así:
   ```bash
   make all; echo "código: $?"
   ```
   ```
   datos OK: data/eventos.csv
   ...
   cd build && tar -czf eventos.tar.gz levels.txt warnings.txt
   código: 0
   ```
   ```bash
   tar -tzf build/eventos.tar.gz
   cat build/levels.txt
   ```
   ```
   levels.txt
   warnings.txt
         2 ERROR
         6 INFO
   ```
   ```bash
   make list
   ```
   ```
   data/eventos-corrupto.csv: 8 líneas
   data/eventos.csv: 8 líneas
   data/vacio.csv: 0 líneas
   ```

5. Comprueba los casos de fallo:
   ```bash
   make check DATA=data/vacio.csv          # data/vacio.csv está vacío + Error 1
   make -B levels DATA=data/eventos-corrupto.csv
   ls build/levels.txt                     # No such file or directory
   make clean BUILD_DIR=                   # *** BUILD_DIR vacía: rm -rf no se ejecuta.  Stop.
   make clean; ls                          # sin build/
   ```

## Criterios de éxito

- [ ] `make all` termina con código 0 y `build/eventos.tar.gz` contiene `levels.txt` y `warnings.txt` sin prefijo
- [ ] `make check DATA=data/vacio.csv` termina con error
- [ ] `make -B levels DATA=data/eventos-corrupto.csv` termina con error y no deja `build/levels.txt`
- [ ] `make -B warnings` termina con código 0 y deja un `build/warnings.txt` vacío
- [ ] `make list` imprime el nombre de cada CSV
- [ ] `make clean` borra `build/` y `make clean BUILD_DIR=` se niega
- [ ] Cada corrección tiene su `# FIX:` en columna 0 (siete en total)

## Reto extra

Añade un octavo bug y pásale el Makefile a un compañero con solo el síntoma: pon un `-` delante de la línea del `awk` de `$(LEVELS)`. ¿Qué síntoma ve con `make -B levels DATA=data/eventos-corrupto.csv`? ¿Por qué ese `-` anula a la vez los arreglos de B y de C?
