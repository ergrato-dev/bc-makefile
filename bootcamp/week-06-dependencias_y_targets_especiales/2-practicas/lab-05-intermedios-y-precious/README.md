# Lab 05 — Intermedios, `.SECONDARY` y `.PRECIOUS`

⏱ Duración estimada: ~60 min

## Objetivo

Controlar qué archivos generados conserva o borra Make usando `.SECONDARY`, `.PRECIOUS`, `.INTERMEDIATE` y, en Make 4.4+, `.NOTINTERMEDIATE`.

## Contexto

- El starter genera `build/es.c` y `build/en.c` a partir de `msgs/*.txt` con una regla de patrón, y los compila con otra. Funciona, pero al terminar Make **borra** los `.c` generados. Si quieres leer el código que compilaste, ya no está.
- Cada target especial cambia una cosa distinta: si el archivo se borra al terminar, si un archivo ausente obliga a rehacer, y si sobrevive a una receta que falla. Elegir mal el último deja archivos corruptos en disco.
- Teoría: [03-grouped-e-intermedios.md](../../1-teoria/03-grouped-e-intermedios.md), sección Intermedios.

## Instrucciones

Trabaja dentro de `starter/`.

1. **Make borra tu código.**
   ```bash
   make clean && make all
   ```
   La última línea es:
   ```
   rm build/es.c build/en.c
   ```
   `make all` otra vez imprime `Nothing to be done for 'all'.` aunque los `.c` no
   existan: un intermedio ausente no obliga a rehacer nada. Y `make run` funciona.

2. **Por qué.** Ningún Makefile nombra `build/es.c`: Make lo dedujo encadenando
   `build/%.o: build/%.c` con `build/%.c: msgs/%.txt`. Eso lo hace **intermedio**. Si
   cambia la fuente, la cadena se rehace entera y el `.c` se vuelve a borrar:
   ```bash
   touch msgs/es.txt && make all
   ```
   ```
   [gen]  msgs/es.txt → build/es.c
   [cc]   build/es.c
   [link] build/app
   rm build/es.c
   ```

3. **`.SECONDARY`.** Completa el TODO del paso 3 con `.SECONDARY: $(GEN_SRCS)`.
   ```bash
   make clean && make all && ls build
   ```
   Ahora `es.c` y `en.c` siguen ahí. Comprueba la otra mitad del comportamiento:
   ```bash
   rm build/es.c && make all
   ```
   `Nothing to be done`: sigue siendo un intermedio, solo que no se borra. Provoca
   ahora un fallo del generador:
   ```bash
   touch msgs/es.txt && make all FALLAR=es
   ```
   ```
   [gen]  build/es.c: fallo simulado a mitad de escritura
   make: *** [Makefile:41: build/es.c] Error 1
   make: *** Deleting file 'build/es.c'
   ```
   `.DELETE_ON_ERROR` borra el archivo a medio escribir. Bien.

4. **`.PRECIOUS`.** Sustituye la línea del paso 3 por `.PRECIOUS: $(BUILD_DIR)/%.c`
   (acepta patrones; `.SECONDARY`, no). Repite:
   ```bash
   make clean && make all && ls build
   touch msgs/es.txt && make all FALLAR=es
   cat build/es.c
   ```
   Esta vez **no** hay `Deleting file`, y `build/es.c` contiene solo
   `const char *msg_es =`. Ejecuta `make all` sin `FALLAR`:
   ```
   [cc]   build/es.c
   build/es.c:1:1: error: expected expression at end of input
   ```
   El archivo corrupto es más nuevo que `msgs/es.txt`, así que Make lo da por bueno.
   `.PRECIOUS` anula `.DELETE_ON_ERROR`. Vuelve a `.SECONDARY: $(GEN_SRCS)` y ejecuta
   `make clean && make all`.

5. **Nombrarlos.** Un archivo deja de ser intermedio en cuanto aparece como target o
   prerrequisito en el Makefile. Como prueba, sustituye temporalmente `.SECONDARY` por
   una static pattern rule (semana 05) sin receta que nombre los `.c`:
   ```makefile
   $(GEN_SRCS:.c=.o): $(BUILD_DIR)/%.o: $(BUILD_DIR)/%.c
   ```
   `make clean && make all` ya no borra nada. Vuelve a `.SECONDARY`, que expresa la
   intención con más claridad.

   > [!NOTE]
   > **Make 4.4+.** `.NOTINTERMEDIATE: $(BUILD_DIR)/%.c` saca los archivos de la
   > categoría de intermedios y acepta patrones. En 4.3 no existe: es un target sin
   > efecto especial y los `.c` se siguen borrando. Si tienes 4.4 (`make --version`),
   > pruébalo en lugar de `.SECONDARY`.

6. **`.INTERMEDIATE` para temporales.** `make informe` concatena los mensajes en
   `build/todos.txt` y cuenta palabras en `build/informe.txt`. Ese `todos.txt` es
   basura útil solo durante el build. Completa el TODO del paso 6 con
   `.INTERMEDIATE: $(BUILD_DIR)/todos.txt`:
   ```bash
   make clean && make informe
   ```
   ```
   [cat]  msgs/es.txt msgs/en.txt
   [wc]   build/todos.txt
   palabras: 10
   rm build/todos.txt
   ```
   Un segundo `make informe` imprime `palabras: 10` sin regenerar nada, aunque
   `todos.txt` ya no exista. Tras `touch msgs/en.txt`, vuelve a crear y borrar el
   temporal.

## Criterios de éxito

- [ ] `make clean && make all` deja `build/es.c` y `build/en.c` en disco
- [ ] `touch msgs/es.txt && make all FALLAR=es` termina con `Deleting file 'build/es.c'`
- [ ] Puedes explicar con tus palabras por qué `.PRECIOUS` es peligroso para código generado
- [ ] `make clean && make informe` termina con `rm build/todos.txt`
- [ ] Un segundo `make informe` no imprime `[cat]`
- [ ] `make clean` deja `starter/` sin `build/`

## Reto extra

Añade `DEPFLAGS := -MMD -MP` a las dos reglas de compilación y `-include` de los `.d`.
Sin `.SECONDARY`, ejecuta `make clean && make all` dos veces tocando `msgs/es.txt`
entre medias. ¿Se borra `build/es.c` en la segunda pasada? ¿Por qué se regenera también
`build/en.c`, si no tocaste `msgs/en.txt`? Explica qué línea del `.d` cambió el
estatus de los dos archivos.
