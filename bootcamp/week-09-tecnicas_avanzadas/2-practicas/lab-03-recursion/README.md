# Lab 03 — Builds Recursivos con $(MAKE)

**Duración estimada:** 50 min

## Objetivo

Coordinar un repositorio multi-módulo donde el Makefile raíz orquesta builds independientes en subdirectorios (`api/`, `worker/`, `frontend/`) usando `$(MAKE) -C`.

## Contexto

Los monorepos y proyectos multi-componente necesitan builds coordinados. Make resuelve esto con recursión:

- `$(MAKE) -C directorio` cambia al directorio y ejecuta su Makefile
- Cada submódulo tiene su propio Makefile independiente y ejecutable por separado
- El Makefile raíz solo orquesta; no duplica lógica de los hijos
- Siempre usa `$(MAKE)` (no `make`): garantiza el mismo binario, flags y MAKEFLAGS del padre

El anti-patrón es tener un Makefile raíz que hace todo y los subdirectorios no tienen Makefile propio. Eso elimina la posibilidad de trabajar en un módulo de forma aislada.

## Instrucciones

1. Copia el starter:
   ```bash
   cp -r starter/ mi-lab-03 && cd mi-lab-03
   ```

2. Explora la estructura:
   ```bash
   find . -name Makefile | sort
   ```

3. Implementa el target `all` en el Makefile raíz para que construya los tres módulos:
   ```bash
   make all
   ```

4. Implementa el target `clean` recursivo:
   ```bash
   make clean
   ```

5. Implementa el target `test` que ejecuta tests en todos los módulos:
   ```bash
   make test
   ```

6. Implementa el target `status` que muestra el estado de cada módulo sin construirlo:
   ```bash
   make status
   ```

7. Verifica que cada módulo funciona de forma independiente:
   ```bash
   make -C api build
   make -C worker build
   make -C frontend build
   ```

## Criterios de éxito

- [ ] `make all` → imprime `[api] build`, `[worker] build`, `[frontend] build` (en ese orden)
- [ ] `make clean` → imprime `[api] clean`, `[worker] clean`, `[frontend] clean`
- [ ] `make test` → imprime `[api] test`, `[worker] test`, `[frontend] test`
- [ ] `make -C api build` → funciona de forma autónoma sin el Makefile raíz
- [ ] `make status` → lista los tres módulos con su estado

## Reto extra

Implementa `make build-parallel` que construya los tres módulos en paralelo usando `$(MAKE) -j3` y que imprima el tiempo total con `time`.
