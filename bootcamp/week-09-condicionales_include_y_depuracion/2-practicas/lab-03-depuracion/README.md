# Lab 03 — Depuración de Makefiles

**Duración estimada:** 60 min

## Objetivo

Diagnosticar un Makefile con `$(info)`, `$(warning)`, `$(error)`, `make -n` y
`--debug`, y encontrar con ellos un bug que no produce ningún error.

## Contexto

- `$(info)`, `$(warning)` y `$(error)` son **funciones**: actúan cuando Make
  las expande. A nivel de archivo, al leerlo; dentro de una receta, al
  ejecutar ese target. `$(warning)` añade archivo y línea; `$(error)` además
  detiene Make.
- `make -n` muestra los comandos sin ejecutarlos, pero tiene que expandir las
  recetas para saber cuáles son.
- `--debug=b` cuenta qué targets rehace y por qué; `--debug=v` además cada
  prerrequisito que considera.

## Instrucciones

1. Copia el starter y genera el manual:
   ```bash
   cp -r starter/ mi-lab-03 && cd mi-lab-03
   make -n build      # qué haría, sin hacerlo
   make build         # [build] build/manual.txt <- 2 capítulos
   ```

2. **`debug-vars` (TODO 2).** Escribe una línea `$(info ...)` por variable:
   ```bash
   make debug-vars
   ```
   ```
   APP_NAME      = manual
   ENV           = development
   SRCS          = src/01-instalacion.txt src/02-uso.txt
   OUT           = build/manual.txt
   MAKEFILE_LIST = Makefile
   Variables mostradas.
   ```

3. **`-n` no silencia las funciones.** Ejecuta `make -n debug-vars`. Los
   `$(info)` se imprimen y el `echo` solo se muestra. Escribe en un comentario
   por qué (pista: ¿qué tiene que hacer Make con la receta para poder
   mostrarla?).

4. **Avisar sin detener (TODO 1).** Añade el `$(warning)` a nivel de archivo y
   pruébalo con un directorio sin fuentes:
   ```bash
   make debug-vars SRC_DIR=vacio
   ```
   La primera línea es `Makefile:NN: No hay fuentes en vacio/: build/manual.txt saldrá vacío`
   y Make continúa.

5. **Detener donde toca (TODO 3).** Implementa `validate` con
   `$(if ...,,$(error ...))` dentro de la receta:
   ```bash
   make validate                  # Validación OK
   make validate APP_NAME=        # Makefile:NN: *** APP_NAME no puede estar vacía: ...  Stop.
   make help APP_NAME=            # la ayuda sale normal
   ```
   Ahora copia esa misma línea `$(if ...)` a nivel de archivo (columna 0) y
   repite `make help APP_NAME=`: también falla. Anota por qué y devuelve la
   validación a la receta.

6. **El bug silencioso.** Modifica un capítulo y reconstruye:
   ```bash
   touch src/02-uso.txt
   make build        # make: Nothing to be done for 'build'.
   ```
   El manual está desactualizado y Make no se entera. Pregúntale por qué:
   ```bash
   make --debug=v build 2>&1 | grep -A2 "Considering target file 'build/manual.txt'"
   ```
   Entre `Considering` y `Finished prerequisites` no aparece ningún
   prerrequisito. Encuentra en la regla de `$(OUT)` la causa, corrígela
   (y usa `$^` en la receta) y comprueba:
   ```bash
   touch src/02-uso.txt
   make --debug=b build | grep -E 'newer|Must remake'
   ```
   ```
      Prerequisite 'src/02-uso.txt' is newer than target 'build/manual.txt'.
     Must remake target 'build/manual.txt'.
   Must remake target 'build'.
   ```

7. **`debug-all` (TODO 4)** solo con prerrequisitos:
   ```bash
   make debug-all
   ```
   Termina con `Validación OK` y `Diagnóstico completo.`

8. Limpia: `make clean`.

## Criterios de éxito

- [ ] `make debug-vars` imprime las cinco variables con el formato del paso 2
- [ ] `make debug-vars SRC_DIR=vacio` imprime el aviso con `Makefile:NN:` y termina con `Variables mostradas.`
- [ ] `make validate APP_NAME=` sale con error `APP_NAME no puede estar vacía`; `make help APP_NAME=` funciona
- [ ] Tras `touch src/02-uso.txt`, `make build` reconstruye `build/manual.txt`
- [ ] `make --debug=b build` muestra `Prerequisite 'src/02-uso.txt' is newer than target 'build/manual.txt'`
- [ ] `make debug-all` termina con `Diagnóstico completo.`
- [ ] Los comentarios de los pasos 3 y 5 explican cuándo se expande cada función

## Reto extra

Añade un capítulo nuevo `src/03-faq.txt` y ejecuta `make build`. Se reconstruye
porque hay un prerrequisito nuevo más reciente. Ahora bórralo y ejecuta
`make build`: no pasa nada y el manual sigue con la FAQ. Usa `--debug=v` para
explicar por qué, y propón una forma de que el borrado también provoque la
reconstrucción.
