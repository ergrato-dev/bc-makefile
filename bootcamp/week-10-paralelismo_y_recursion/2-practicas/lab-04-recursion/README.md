# Lab 04 — Recursión que no se traga los fallos

⏱ Duración estimada: ~60 min

## Objetivo

Coordinar un repositorio multi-módulo con `$(MAKE) -C` de forma que un fallo en cualquier módulo detenga el build, que `-j` y `-k` funcionen y que las variables lleguen a los sub-makes que las necesitan.

## Contexto

- `$(MAKE) -C dir meta` entra en `dir` y ejecuta su Makefile. Usa siempre `$(MAKE)`, nunca `make`: hereda el binario, los flags y el jobserver del padre (lo verás en el [lab-05](../lab-05-jobserver/README.md)).
- El patrón que verás en muchos repos, `for d in $(MODULES); do $(MAKE) -C $$d test; done`, **está roto**: sin `-e`, el código de salida del bucle es el del último módulo, y si `api` falla y `frontend` pasa, el CI queda en verde. Con `-e` se detiene en el primero, pero sigue siendo una sola receta: `-j` no puede paralelizarla y `-k` no puede seguir con los demás.
- La solución es convertir cada pareja módulo/meta en un **target phony**: `api/test`, `worker/test`. Make los trata como nodos del grafo: un fallo detiene el build, `-k` sigue con los independientes y `-j` los ejecuta en paralelo.

## Instrucciones

1. Copia el starter:
   ```bash
   cp -r starter/ mi-lab-04 && cd mi-lab-04
   ```

2. Comprueba que cada módulo funciona solo y que `FAIL` simula un fallo:
   ```bash
   make -C api test
   make -C api test FAIL=api; echo "exit=$?"
   ```
   El segundo comando debe terminar con `exit=2`.

3. Implementa los **TODO 1 y 2** del Makefile raíz: `MODULE_TARGETS` y la regla única que llama a `$(MAKE) --no-print-directory -C $(@D) $(@F)`.
   ```bash
   make api/build
   ```
   Debes ver `[api] build (STAGE=)`. `STAGE` sale vacía: lo arreglas en el paso 7. `make worker/build` construye solo `worker`: cada módulo es un target que puedes pedir por separado.

4. Implementa el **TODO 3**: `all`, `clean` y `test` solo con prerrequisitos.
   ```bash
   make all
   make test
   make clean
   ```
   `make all` crea `api/dist/`, `worker/dist/` y `frontend/dist/`; `make clean` las borra y cada módulo imprime su `[módulo] clean`.

5. Comprueba que un fallo se propaga. Este es el paso que importa:
   ```bash
   make test FAIL=worker; echo "exit=$?"
   ```
   Debes ver `[worker] test FALLÓ`, `make: *** [Makefile:NN: worker/test] Error 2` y `exit=2`. `frontend` ni siquiera se ejecuta: Make se detiene en el primer error.

6. Ejecuta en paralelo y sin detenerte en el primer error:
   ```bash
   make -j3 -k test FAIL=worker; echo "exit=$?"
   ```
   `api` y `frontend` se ejecutan igual; Make termina con `make: Target 'test' not remade because of errors.` y `exit=2`.

7. **Qué variables llegan a un sub-make.** Primero, una de línea de comandos:
   ```bash
   make clean DIST_DIR=; echo "exit=$?"
   ```
   El sub-make de `api` se niega con `DIST_DIR vacía: rm -rf no se ejecuta`. Tú no tocaste los módulos: las variables de la línea de comandos viajan solas dentro de `MAKEFLAGS` a todos los sub-makes. Por eso cada nivel necesita su propia guarda.

   Ahora implementa el **TODO 4**: `STAGE ?= dev` y `export STAGE`.
   ```bash
   make all
   make all STAGE=prod
   ```
   Debes ver `(STAGE=dev)` y después `(STAGE=prod)` en los tres módulos. Quita el `export` y repite: vuelve a salir `(STAGE=)`. Una variable del Makefile **no** pasa al sub-make salvo que la exportes, y se exporta por nombre: `export` a secas exporta todas, incluidas las que no deberían salir de este Makefile.

8. Implementa el **TODO 5** (`status`).
   ```bash
   make status
   ```
   Debes ver `✓ api`, `✓ worker` y `✓ frontend`.

## Criterios de éxito

- [ ] `make all` imprime `[api] build (STAGE=dev)`, `[worker] build (STAGE=dev)`, `[frontend] build (STAGE=dev)`
- [ ] `make all STAGE=prod` imprime `STAGE=prod` en los tres módulos
- [ ] `make test FAIL=api` imprime `[api] test FALLÓ` y sale distinto de 0
- [ ] `make -j3 -k test FAIL=worker` ejecuta los tests de `api` y `frontend` y sale distinto de 0
- [ ] `make clean DIST_DIR=` sale distinto de 0 sin borrar nada
- [ ] `make -C api build` funciona sin el Makefile raíz
- [ ] El Makefile raíz no contiene ningún bucle `for`

## Reto extra

Añade la meta `lint` a los tres módulos y al raíz cambiando solo la variable `GOALS` y una línea nueva. Si necesitas tocar más, la regla genérica no es tan genérica como crees.
