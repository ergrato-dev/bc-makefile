# Lab 01 — Recursión que no se traga los fallos

**Duración estimada:** 60 min

## Objetivo

Coordinar un repositorio multi-módulo con `$(MAKE) -C` de forma que un fallo en cualquier módulo detenga el build y que `-j` pueda paralelizarlo.

## Contexto

- `$(MAKE) -C dir meta` entra en `dir` y ejecuta su Makefile. Usa siempre `$(MAKE)`, nunca `make`: hereda el binario, los flags y el jobserver del padre.
- El patrón que verás en muchos repos, `for d in $(MODULES); do $(MAKE) -C $$d test; done`, **está roto**: el código de salida del bucle es el del último módulo. Si `api` falla y `frontend` pasa, `make test` sale con 0 y el CI queda en verde.
- La solución es convertir cada pareja módulo/meta en un **target phony**: `api/test`, `worker/test`. Make los trata como nodos del grafo: un fallo detiene el build, `-k` sigue con los demás y `-j` los ejecuta en paralelo.

## Instrucciones

1. Copia el starter:
   ```bash
   cp -r starter/ mi-lab-01 && cd mi-lab-01
   ```

2. Comprueba que cada módulo funciona solo y que `FAIL` simula un fallo:
   ```bash
   make -C api test
   make -C api test FAIL=api; echo "exit=$?"
   ```
   El segundo comando debe terminar con `exit=2`.

3. Implementa los **TODO 1 y 2** del Makefile raíz: `MODULE_TARGETS` y la regla única que llama a `$(MAKE) -C $(@D) $(@F)`.
   ```bash
   make api/build
   ```
   Debes ver `[api] build`.

4. Implementa el **TODO 3**: `all`, `clean` y `test` solo con prerrequisitos.
   ```bash
   make all
   make test
   ```

5. Comprueba que un fallo se propaga. Este es el paso que importa:
   ```bash
   make test FAIL=worker; echo "exit=$?"
   ```
   Debes ver `[worker] test FALLÓ` y `exit=2`. `FAIL` llega a los sub-makes porque las variables de la línea de comandos viajan en `MAKEFLAGS`.

6. Ejecuta en paralelo y sin detenerte en el primer error:
   ```bash
   make -j3 -k test FAIL=worker
   ```
   `api` y `frontend` se ejecutan igual; Make termina con `Target 'test' not remade because of errors.`

7. Implementa el **TODO 4** (`status`).

## Criterios de éxito

- [ ] `make all` imprime `[api] build`, `[worker] build`, `[frontend] build`
- [ ] `make test` sale con 0
- [ ] `make test FAIL=api` imprime `[api] test FALLÓ` y sale distinto de 0
- [ ] `make -j3 -k test FAIL=worker` ejecuta los tests de `api` y `frontend` y sale distinto de 0
- [ ] `make -C api build` funciona sin el Makefile raíz
- [ ] El Makefile raíz no contiene ningún bucle `for`

## Reto extra

Añade la meta `lint` a los tres módulos y al raíz cambiando solo la variable `GOALS` y una línea nueva. Si necesitas tocar más, la regla genérica no es tan genérica como crees.
