# Lab 05 — Optimización con Builds Paralelas y Stamps

⏱ Duración estimada: ~60 min

## Objetivo

Optimizar un build system lento usando paralelismo Make (`-j`), archivos stamp para evitar tareas redundantes, y dependencias correctas para que la paralelización sea segura.

## Contexto

Un build que instala dependencias en cada ejecución, aunque no hayan cambiado, es lento. Un build que no puede paralelizarse porque sus dependencias están mal declaradas tampoco escala. Dos técnicas resuelven esto:

- **Stamps:** archivo vacío que se crea al terminar una tarea; Make compara su timestamp con las dependencias reales
- **Paralelismo correcto:** las dependencias entre targets deben ser exactas — ni más (serializa innecesariamente) ni menos (condición de carrera)

El starter tiene un Makefile que reconstruye todo siempre. Tu tarea es hacerlo inteligente. Las instalaciones se simulan con `sleep 1` para que el lab no necesite red; en un proyecto real serían `uv sync --locked` y `pnpm install --frozen-lockfile`, y los stamps dependerían exactamente de los mismos archivos (`uv.lock`, `pnpm-lock.yaml`).

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
   touch pyproject.toml
   make all       # solo reinstala deps Python, no Node
   touch pnpm-lock.yaml
   make all       # solo reinstala deps Node
   ```

4. Declara dependencias correctas entre `build-backend` y `build-frontend` (son independientes):
   ```bash
   make -j2 all   # deben ejecutarse en paralelo sin errores
   ```

5. Verifica que `make -j4 all` es más rápido que `make all`:
   ```bash
   make clean && time make all       # ~2 s: las dos instalaciones en serie
   make clean && time make -j4 all   # ~1 s: en paralelo
   ```

6. Mira la salida de `make clean && make -j2 all`: las líneas de backend y
   frontend salen mezcladas (`==> Instalando deps Python ...` seguida de
   `==> Instalando deps Node ...`). En un CI con logs largos eso es ilegible.
   Repite con salida sincronizada:
   ```bash
   make clean && make -j2 -O all
   ```
   Ahora cada receta imprime su bloque completo (`==> Instalando deps Python ...`
   seguido de su `touch .stamps/deps-python`). `-O` (`--output-sync`) agrupa la
   salida por target sin perder paralelismo.

7. Rompe la paralelización a propósito para ver una condición de carrera:
   - en la receta de `$(DIST_DIR)/frontend.out` añade `cat $(DIST_DIR)/backend.out >> $@`
     (el frontend "embebe" la versión del backend) **sin** declararlo;
   - sube el `sleep` de `deps-python` a `2`.

   ```bash
   make clean && make all; echo "exit=$?"       # exit=0
   make clean && make -j2 all; echo "exit=$?"   # cat: dist/backend.out: No such file or directory ... exit=2
   ```
   En serie funciona porque `build-backend` va antes en la lista; en paralelo
   el frontend termina primero y lee un archivo que aún no existe. Añade
   `$(DIST_DIR)/backend.out` a los prerrequisitos de `$(DIST_DIR)/frontend.out`
   y repite con `-j2`: `exit=0`. El orden de la lista nunca es una
   dependencia; la dependencia declarada sí. Deshaz los cambios.

## Criterios de éxito

- [ ] `make all` segunda vez → `make: Nothing to be done for 'all'`
- [ ] `touch pyproject.toml && make all` → solo reinstala deps Python
- [ ] `touch package.json && make all` → solo reinstala deps Node (igual con `pnpm-lock.yaml`)
- [ ] `make -j2 all` produce el mismo resultado que `make all` (no hay condiciones de carrera)
- [ ] `make clean` elimina stamps y artefactos
- [ ] Con `-j4`, `make all` tarda menos que sin paralelismo (observable con `time`)
- [ ] `make -j2 -O all` imprime la salida de cada receta agrupada
- [ ] Con la lectura cruzada del paso 7, `make -j2 all` falla y declarar la dependencia lo arregla

## Reto extra

Agrega un target `bench` que ejecute `time make clean && time make all` y `time make clean && time make -j4 all`, comparando los tiempos e imprimiendo el speedup obtenido.
