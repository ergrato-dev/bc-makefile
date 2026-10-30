# Lab 06 — Make no recursivo

⏱ Duración estimada: ~60 min

## Objetivo

Construir un proyecto de dos directorios con un solo Make que incluye un `module.mk` por directorio, para que todo el build sea un único grafo.

## Contexto

- Con recursión, cada sub-make ve solo su trozo del grafo. Si `app/` enlaza con `../lib/libgreet.a`, `make -C app` no sabe reconstruir la librería: si cambiaste `lib/greet.c` y no pasaste antes por `lib`, enlaza con la versión vieja sin avisar. Es el argumento central de *Recursive Make Considered Harmful* (Peter Miller, 1997).
- La alternativa: cada directorio describe sus reglas en un `module.mk` y el Makefile raíz los **incluye**. No hay sub-makes: hay un solo Make, con todas las reglas, todas las dependencias y un solo jobserver.
- El precio: las rutas de cada `module.mk` son relativas a la raíz, los nombres de variable no pueden chocar (`LIB_OBJS`, `APP_OBJS`) y el orden de inclusión importa.

## Instrucciones

1. Copia el starter y mira la estructura:
   ```bash
   cp -r starter/ mi-lab-06 && cd mi-lab-06
   find . -type f | sort
   cat lib/module.mk
   ```
   `lib/module.mk` está completo: úsalo de modelo. Fíjate en que dice `lib/greet.c`, no `greet.c`.

2. Implementa el **TODO 1** (incluir los `module.mk` en el raíz) y el **TODO 2** (`app/module.mk`). Después:
   ```bash
   make -j4 all && make run
   ```
   Debes ver:
   ```
   [cc] app/main.c
   [cc] lib/greet.c
   [ar] build/lib/libgreet.a
   [ld] build/app/hola
   Hola desde un solo grafo
   ```
   Los dos `[cc]` pueden salir en otro orden: con `-j4` compilan a la vez.

3. Cambia la librería y reconstruye **solo la aplicación**:
   ```bash
   touch lib/greet.c && make build/app/hola
   ```
   Debes ver `[cc] lib/greet.c`, `[ar]` y `[ld]`. Pediste el ejecutable y Make reconstruyó la librería porque está en el mismo grafo. Con un `app/Makefile` recursivo, esto habría enlazado con la librería vieja.

4. Implementa el **TODO 3** (incluir los `.d`) y cambia el header:
   ```bash
   make all
   touch lib/greet.h && make all
   ```
   Deben recompilarse `app/main.c` y `lib/greet.c`: `build/app/main.d` dice que `main.o` depende de `lib/greet.h`, una dependencia **entre directorios** que un Makefile recursivo no ve.

5. Rompe el orden a propósito. Cambia `MODULES := lib app` por `MODULES := app lib` y ejecuta:
   ```bash
   make clean && make all; echo "exit=$?"
   ```
   Falla con `undefined reference to 'greet'` (con las comillas que use tu enlazador). La línea `$(APP): $(APP_OBJS) $(LIB)` se expande al leerla, y cuando se lee `app/module.mk`, `LIB` todavía no existe: el enlace no incluye la librería. Restaura el orden y deja un comentario en el Makefile raíz que explique por qué.

6. Comprueba que no hay sub-makes ni trabajo repetido:
   ```bash
   make all
   make -n -B all | grep -c 'make'
   ```
   La primera línea imprime `make: Nothing to be done for 'all'.` (sin `Entering directory` de nadie). La segunda imprime `0`: el plan completo no contiene ni un sub-make.

## Criterios de éxito

- [ ] `make -j4 all && make run` imprime `Hola desde un solo grafo`
- [ ] `touch lib/greet.c && make build/app/hola` recompila la librería y vuelve a enlazar
- [ ] `touch lib/greet.h && make all` recompila los dos `.c`
- [ ] Una segunda ejecución de `make all` imprime `Nothing to be done for 'all'.`
- [ ] `make clean BUILD_DIR=` se niega a borrar
- [ ] Hay un comentario que explica por qué `lib` va antes que `app` en `MODULES`

## Reto extra

Añade un tercer módulo `tools/` con un ejecutable `build/tools/version` que también use `libgreet.a`. Solo puedes crear `tools/module.mk` y `tools/version.c`, y tocar una línea del Makefile raíz. Lee después la sección "The Big Picture" de [Recursive Make Considered Harmful](https://accu.org/journals/overload/14/71/miller_2004/) y compara su `module.mk` con el tuyo.
