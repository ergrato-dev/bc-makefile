# Lab 02 — Order-only y directorios de salida

⏱ Duración estimada: ~60 min

## Objetivo

Conseguir que crear o modificar directorios de salida nunca provoque recompilaciones, usando prerrequisitos order-only y `.SECONDEXPANSION` para crear cada subdirectorio de `build/`.

## Contexto

- El starter declara `build/` como prerrequisito **normal** de los objetos y del binario. Parece razonable: "para compilar necesito el directorio". El resultado es un build que nunca termina de estar al día.
- Después añadirás fuentes en `src/net/`, y los objetos tendrán que ir a `build/net/`: una regla de directorio fija ya no alcanza.
- Teoría: [02-order-only-y-vpath.md](../../1-teoria/02-order-only-y-vpath.md).

## Instrucciones

Trabaja dentro de `starter/`.

1. **El síntoma.** Compila tres veces seguidas:
   ```bash
   make all
   make all
   make all
   ```
   Las tres veces verás:
   ```
   [cc]   src/lexer.c
   [cc]   src/main.c
   [cc]   src/parser.c
   [link] build/app
   ```
   (La primera, además, `[mkdir] build`.)

2. **El diagnóstico.** Mira las fechas:
   ```bash
   ls -l --time-style=full-iso -d build build/main.o build/app
   ```
   `build/` es más nuevo que `main.o`: al enlazar, el linker crea `build/app` y eso
   cambia la fecha del directorio. Como `main.o` depende de `build/`, queda "viejo";
   recompilarlo vuelve a tocar `build/`... y así para siempre. Fíjate también en que
   la receta de enlace usa `$(OBJS)` y no `$^`: con el directorio en la lista,
   `$^` le pasaría `build` al linker.

3. **Order-only.** Completa los TODO del paso 3: mueve `$(BUILD_DIR)` detrás de un
   `|` en las dos reglas, y cambia `$(OBJS)` por `$^` en el enlace. Comprueba:
   ```bash
   make clean && make all
   make all
   ```
   ```
   make: Nothing to be done for 'all'.
   ```

4. **Crear archivos en `build/` no cuenta.** Con el arreglo del paso 3:
   ```bash
   touch build/notas.txt
   make all
   ```
   ```
   make: Nothing to be done for 'all'.
   ```

5. **Subdirectorios de salida.** Completa el TODO de `SRCS` para incluir
   `$(SRC_DIR)/*/*.c`:
   ```bash
   make all
   ```
   ```
   [cc]   src/net/http.c
   src/net/http.c:3:1: fatal error: opening dependency file build/net/http.d: No such file or directory
   ```
   `build/net/` no existe. En vez de añadir `mkdir -p` a la receta, haz que cada
   objeto dependa (order-only) de **su** directorio:

   a. Declara `.SECONDEXPANSION:` al principio.

   b. En la regla de compilación, cambia `| $(BUILD_DIR)` por `| $$(@D)/`.

   c. Sustituye la regla `$(BUILD_DIR):` por una regla de patrón para cualquier
      directorio, con `.PRECIOUS: %/` debajo:
      ```makefile
      %/:
      	@echo "[mkdir] $@"
      	@mkdir -p $@
      .PRECIOUS: %/
      ```

   d. En la regla del binario, usa también `| $$(@D)/`.

   ```bash
   make clean && make all
   ```
   ```
   [mkdir] build/
   [cc]   src/lexer.c
   [cc]   src/main.c
   [cc]   src/parser.c
   [mkdir] build/net/
   [cc]   src/net/http.c
   [link] build/app
   ```

6. **Por qué `.PRECIOUS: %/`.** Los directorios los crea una regla de patrón y ningún
   Makefile los nombra: para Make son **intermedios** (lab 05). Comenta
   temporalmente `.PRECIOUS: %/` y la línea `-include $(DEPS)`, y ejecuta
   `make clean && make all`. En Make 4.3 el build termina con:
   ```
   rm build/net/make: unlink: build/net/: Is a directory
    build/make: unlink: build/: Is a directory
   ```
   Make intentó borrar los directorios como si fueran archivos intermedios. No falla,
   pero ensucia la salida y depende de detalles del Makefile (con `-include` no
   aparece). Vuelve a dejar las dos líneas.

7. **`$^` frente a `$|`.** Añade temporalmente esta línea a la receta de compilación:
   ```makefile
   	@echo "      normales: $^ | order-only: $|"
   ```
   Con `make -B all` verás, por ejemplo,
   `normales: src/net/http.c | order-only: build/net/`. Quítala al terminar.

## Criterios de éxito

- [ ] Dos `make all` seguidos: el segundo imprime `Nothing to be done for 'all'.`
- [ ] `touch build/notas.txt && make all` no recompila nada
- [ ] `make clean && make all` compila `src/net/http.c` en `build/net/http.o`
- [ ] Ninguna receta contiene `mkdir`, salvo la regla `%/`
- [ ] La receta de enlace usa `$^`
- [ ] `make clean` deja `starter/` sin `build/`

## Reto extra

Añade `src/net/tls/cert.c` (una función que devuelva `"tls"`). Sin tocar las reglas,
amplía `SRCS` con un nivel más y comprueba que `build/net/tls/` se crea solo. ¿Por qué
`mkdir -p build/net/tls/` no necesita que antes exista `build/net/`, y por qué Make
igualmente nunca intenta crear `build/net/` dos veces con `-j8`?
