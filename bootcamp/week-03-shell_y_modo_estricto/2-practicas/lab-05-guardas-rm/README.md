# Lab 05 — Guardas para `rm -rf`, `make -n` y el prefijo `+`

⏱ Duración estimada: ~60 min

## Objetivo

Blindar un target `clean` con comillas, `--` y dos guardas de Make, y usar `make -n` para revisar recetas destructivas antes de ejecutarlas.

## Contexto

- `rm -rf $(BUILD_DIR)/*` es inofensivo hasta el día en que `BUILD_DIR` llega vacía (un typo, un `?=` con la variable de entorno vacía, un `include` que no se cargó). Entonces es `rm -rf /*`.
- La guarda va en **Make**, no en el shell: `$(if ...)` y `$(error ...)` se expanden antes de lanzar ninguna línea, y también con `make -n`.
- `make -n` imprime lo que haría sin ejecutarlo. Excepción: las líneas con prefijo `+` (y las que contienen `$(MAKE)`) se ejecutan siempre.

> [!CAUTION]
> Todo lo que se borra en este lab está dentro de su carpeta. Las pruebas con `BUILD_DIR=/` o `BUILD_DIR=..` se hacen **siempre con `-n`**.

## Instrucciones

Trabaja en `starter/`.

1. Prepara el terreno y previsualiza:
   ```bash
   cd starter
   make prepare
   make -n clean
   ls
   ```
   `make -n clean` imprime `rm -rf build` y `ls` muestra que `build/` sigue ahí: `-n` expande y muestra, no ejecuta.

2. El clean de internet, sin ejecutar nada:
   ```bash
   make simulate-clean BUILD_DIR=
   ```
   ```
   [simulado] rm -rf /*
   ```
   Así se ve un typo en producción: escribe `$(BUIDL_DIR)` en vez de `$(BUILD_DIR)` y Make lo expande a vacío sin quejarse.

3. Comillas y `--`. Ejecuta el `clean` actual con una ruta que tiene un espacio:
   ```bash
   make clean BUILD_DIR="mi build"
   ls; ls mi
   ```
   ```
   rm -rf mi build
   Makefile
   mi build
   ls: cannot access 'mi': No such file or directory
   ```
   Pediste borrar `mi build/` y se borraron `mi/` (con `notas.txt`) y `build/`: el shell vio dos argumentos. Cambia la receta por:
   ```makefile
   	rm -rf -- '$(BUILD_DIR)'
   ```
   Repite `make prepare` y `make clean BUILD_DIR="mi build"`: ahora la línea es `rm -rf -- 'mi build'` y `mi/notas.txt` sobrevive. El `--` hace que una ruta que empiece por `-` no se lea como opción de `rm`.

4. La guarda contra variable vacía. Añade como **primera** línea de la receta de `clean`:
   ```makefile
   	$(if $(BUILD_DIR),,$(error BUILD_DIR vacía: rm -rf no se ejecuta))
   ```
   ```bash
   make clean BUILD_DIR=
   ```
   ```
   Makefile:31: *** BUILD_DIR vacía: rm -rf no se ejecuta.  Stop.
   ```
   `$(if cond,entonces,si-no)`: si `BUILD_DIR` no está vacía, la línea se expande a nada y Make la salta; si lo está, `$(error)` detiene Make antes de ejecutar ninguna línea. Comprueba que `make clean` normal sigue borrando `build/`.

   > [!WARNING]
   > Nunca escribas `$(error ...)` en un comentario dentro de una receta (una línea que empieza por TAB y luego `#`): para Make esa línea es receta, la expande y el `$(error)` se dispara siempre. Los comentarios con funciones, en columna 0.

5. La guarda también protege la previsualización:
   ```bash
   make -n clean BUILD_DIR=
   ```
   Mismo `*** BUILD_DIR vacía` y nada impreso. Una guarda en shell (`[ -n "$$BUILD_DIR" ] || exit 1`) solo actuaría al ejecutar.

6. La guarda contra rutas fuera del proyecto. `rm` ya se niega a borrar `/`, `.` y `..`, pero no `../..` ni tu `$HOME`. Prueba, siempre con `-n`:
   ```bash
   make -n clean BUILD_DIR=../..
   ```
   ```
   rm -rf -- '../..'
   ```
   Añade como **segunda** línea de la receta:
   ```makefile
   	$(if $(filter $(CURDIR)/%,$(abspath $(BUILD_DIR))),,$(error BUILD_DIR='$(BUILD_DIR)' está fuera del proyecto: rm -rf no se ejecuta))
   ```
   `$(abspath)` convierte la ruta en absoluta y `$(filter $(CURDIR)/%,...)` solo la deja pasar si empieza por el directorio del Makefile seguido de `/`. Las funciones de texto se estudian en la Semana 07; esta línea cópiala tal cual. Comprueba:
   ```bash
   make -n clean BUILD_DIR=/
   make -n clean BUILD_DIR=../..
   make -n clean BUILD_DIR="$HOME"
   make -n clean
   ```
   Las tres primeras paran con `*** BUILD_DIR='...' está fuera del proyecto: rm -rf no se ejecuta.  Stop.`; la última imprime `rm -rf -- 'build'`.

7. El prefijo `+` rompe `make -n`. El target `reset` borra lo mismo que `clean`, con una diferencia:
   ```bash
   make prepare
   make -n reset
   ls
   ```
   `build/` **ha desaparecido** aunque usaste `-n`: la línea `+rm -rf ...` se ejecuta siempre. `+` existe para que `make -n` pueda recorrer sub-makes (`$(MAKE) -C sub`, Semana 10); en un comando destructivo convierte la previsualización en ejecución. Reescribe `reset` como `reset: clean` (sin receta) y comprueba que `make prepare && make -n reset && ls` deja `build/` en su sitio.

8. Mismo razonamiento con `@`: oculta el comando, no su efecto. En un `rm -rf`, quieres ver en el log qué se borró; no lo silencies. Para terminar, limpia los restos del lab:
   ```bash
   make clean
   rm -rf -- mi 'mi build'
   ```

## Criterios de éxito

- [ ] `make clean BUILD_DIR=` y `make -n clean BUILD_DIR=` imprimen `*** BUILD_DIR vacía: rm -rf no se ejecuta.  Stop.`
- [ ] `make -n clean BUILD_DIR=/` y `make -n clean BUILD_DIR=../..` imprimen `está fuera del proyecto`
- [ ] `make clean BUILD_DIR="mi build"` borra solo `mi build/`
- [ ] `make -n reset` no borra `build/`
- [ ] La receta de `clean` no lleva `@` ni `-` delante del `rm`
- [ ] Puedes explicar por qué la guarda va en Make y no en el shell

## Reto extra

Ejecuta `make -n clean BUILD_DIR=build/../..`. ¿Pasa la guarda? ¿Por qué `$(abspath)` es imprescindible y no bastaría con comprobar que la ruta no empiece por `/`? Después prueba `make --warn-undefined-variables -n simulate-clean` con un `$(BUIDL_DIR)` escrito a propósito en la receta: Make avisa del typo antes de que la guarda tenga que actuar (lo verás a fondo en la Semana 09).
