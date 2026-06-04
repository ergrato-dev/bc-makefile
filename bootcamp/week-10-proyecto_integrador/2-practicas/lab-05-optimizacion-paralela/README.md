# Lab 05 — Optimización con Builds Paralelas y Stamps

**Duración estimada:** 50 min

## Objetivo

Optimizar un build system lento usando paralelismo Make (`-j`), archivos stamp para evitar tareas redundantes, y dependencias correctas para que la paralelización sea segura.

## Contexto

Un build que instala dependencias en cada ejecución, aunque no hayan cambiado, es lento. Un build que no puede paralelizarse porque sus dependencias están mal declaradas tampoco escala. Dos técnicas resuelven esto:

- **Stamps:** archivo vacío que se crea al terminar una tarea; Make compara su timestamp con las dependencias reales
- **Paralelismo correcto:** las dependencias entre targets deben ser exactas — ni más (serializa innecesariamente) ni menos (condición de carrera)

El starter tiene un Makefile que reconstruye todo siempre. Tu tarea es hacerlo inteligente.

## Instrucciones

1. Copia el starter:
   ```bash
   cp -r starter/ mi-lab-05 && cd mi-lab-05
   ```

2. Observa el comportamiento sin optimizar:
   ```bash
   time make all  # primera vez
   time make all  # segunda vez: mismo tiempo — ineficiente
   ```

3. Implementa stamps para `deps-python` y `deps-node`:
   ```bash
   make all       # primera vez: instala deps + genera artefactos
   make all       # segunda vez: Nothing to be done
   touch requirements.txt
   make all       # solo reinstala deps Python, no Node
   ```

4. Declara dependencias correctas entre `build-backend` y `build-frontend` (son independientes):
   ```bash
   make -j2 all   # deben ejecutarse en paralelo sin errores
   ```

5. Verifica que `make -j4 all` es más rápido que `make all`:
   ```bash
   time make clean && time make all
   time make clean && time make -j4 all
   ```

## Criterios de éxito

- [ ] `make all` segunda vez → `make: Nothing to be done for 'all'`
- [ ] `touch requirements.txt && make all` → solo reinstala deps Python
- [ ] `touch package.json && make all` → solo reinstala deps Node
- [ ] `make -j2 all` produce el mismo resultado que `make all` (no hay condiciones de carrera)
- [ ] `make clean` elimina stamps y artefactos
- [ ] Con `-j4`, `make all` tarda menos que sin paralelismo (observable con `time`)

## Reto extra

Agrega un target `bench` que ejecute `time make clean && time make all` y `time make clean && time make -j4 all`, comparando los tiempos e imprimiendo el speedup obtenido.
