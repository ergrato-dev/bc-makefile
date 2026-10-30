# Lab 05 — `$(MAKE)` y el jobserver

⏱ Duración estimada: ~60 min

## Objetivo

Demostrar por qué un sub-make se lanza con `$(MAKE)` y nunca con `make`, midiendo el jobserver, el comportamiento con `-n` y lo que hereda el hijo.

## Contexto

- Con `make -j4`, el padre crea un **jobserver**: una bolsa de 4 fichas. Cada trabajo que arranca, en el padre o en cualquier sub-make, necesita una. Así, todo el árbol de sub-makes respeta el `-j4` global.
- Make solo comparte el jobserver con las líneas que reconoce como recursivas: las que contienen `$(MAKE)` o `${MAKE}` literalmente, o las que empiezan con `+`. Esas líneas, además, se ejecutan aunque pases `-n`, `-t` o `-q`, para que el sub-make pueda mostrar su propio plan.
- `lib/` tiene cuatro tareas de un segundo. Con jobserver tardan 1 s; sin él, 4 s.

## Instrucciones

1. Copia el starter y mide `lib` sola:
   ```bash
   cp -r starter/ mi-lab-05 && cd mi-lab-05
   time make -C lib
   time make -C lib -j4
   ```
   Unos 4 s y 1 s.

2. Lanza `lib` desde el raíz con `make` literal:
   ```bash
   time make -j4 literal
   ```
   En Make 4.3 verás:
   ```
   make[1]: warning: jobserver unavailable: using -j1.  Add '+' to parent make rule.
   ```
   y unos 4 s: el hijo recibió `-j4` en `MAKEFLAGS`, pero no las fichas, y cae a serie.

   > [!NOTE]
   > **Make 4.4+:** el jobserver por defecto es una FIFO con nombre que cualquier proceso puede abrir, así que `make` literal ya no avisa y tarda 1 s. Para ver el problema de 4.3: `make -j4 --jobserver-style=pipe literal`. Los demás problemas de `make` literal (pasos 4 y 7) siguen igual en 4.4.

3. Implementa el **TODO 1** (`recursive` con `$(MAKE)`):
   ```bash
   time make -j4 recursive
   ```
   Sin aviso y en 1 s.

4. Compara los dos con `-n` (simulacro):
   ```bash
   make -n literal
   make -n recursive
   ```
   `literal` solo imprime `make --no-print-directory -C lib`: Make no lo ejecuta, así que no sabes qué haría `lib`. `recursive` ejecuta el sub-make con `-n` y ves sus recetas (`echo "  [lib] parser"`, `sleep 1`...) sin que se ejecute ninguna. Esto es lo que comprueba el autograding del proyecto.

5. Implementa el **TODO 2** (`twice`: dos sub-makes en paralelo) y mide cuántas tareas corren a la vez:
   ```bash
   make clean && make -j4 twice && make concurrency
   ```
   Debes ver `Máximo simultáneo: 4`, no 8: los dos hijos sacan fichas de la misma bolsa. Ahora el antipatrón, `-j4` escrito dentro de la receta:
   ```bash
   make clean && make -j4 forced && make concurrency
   ```
   Verás dos veces `warning: -j4 forced in submake: resetting jobserver mode.` y `Máximo simultáneo: 8`: cada hijo creó su propio jobserver. En una máquina de 4 núcleos acabas de pedir el doble. El `-j` se pasa una vez, en la línea de comandos.

6. Implementa el **TODO 3**. Antes, observa el problema:
   ```bash
   make -n hidden
   ```
   Solo imprime la línea: `$(MAKE)` está dentro de `$(SUBMAKE)` y Make no lo ve al leer la receta (en 4.3, además, `make -j4 hidden` avisa de `jobserver unavailable`). Añade `+` al principio de la receta y repite: ahora `-n` entra en `lib`.

7. Mira qué hereda el hijo:
   ```bash
   make -j4 flags
   ```
   Debes ver algo como:
   ```
   MAKE=make
   MAKELEVEL=1
   MAKEFLAGS= -j4 --jobserver-auth=3,4 --no-print-directory
   ```
   En 4.4 la última línea dice `--jobserver-auth=fifo:/tmp/GMfifoNNNN`. Ahora ejecútalo con otro binario: `/usr/bin/make flags` imprime `MAKE=/usr/bin/make`. En macOS con Homebrew lanzas `gmake`, y `$(MAKE)` vale `gmake`; una receta con `make` literal ejecutaría la 3.81 del sistema.

## Criterios de éxito

- [ ] `make -j4 recursive` tarda ~1 s y no imprime ningún `warning`
- [ ] `make -n recursive` muestra las recetas de `lib` sin ejecutarlas
- [ ] `make clean && make -j4 twice && make concurrency` imprime `Máximo simultáneo: 4`
- [ ] `make -n hidden` muestra las recetas de `lib`
- [ ] Puedes explicar con tus palabras los tres avisos que viste: `jobserver unavailable`, `forced in submake` y por qué no aparece ninguno con `$(MAKE)`

## Reto extra

Añade a `lib/Makefile` una tarea que lance un sub-sub-make (`$(MAKE) -C sub`) con otras cuatro tareas de un segundo, y comprueba con `make concurrency` que, con `make -j4 recursive`, el máximo sigue siendo 4 aunque ahora haya tres niveles. Mira `MAKELEVEL` en cada nivel.
