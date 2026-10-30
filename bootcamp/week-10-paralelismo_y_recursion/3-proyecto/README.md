# Proyecto Semana 10 — Monorepo con build paralelo y recursión segura

⏱ Duración estimada: ~3 h

## Contexto

Tu equipo mantiene un monorepo con cuatro paquetes: `core` y `util` son librerías internas, `docs` genera la documentación y `app` empaqueta la aplicación, que **consume** los artefactos de `core` y `util`. Cada paquete tiene su propio Makefile y se construye con `make -C packages/<paquete> build`.

El Makefile raíz actual (`legacy-all`) recorre los paquetes con un bucle `for` y `make` literal. Tarda la suma de todos los paquetes, y el mes pasado el CI quedó en verde con `docs` roto, porque el bucle devolvió el código de salida de `app`, el último. Tu tarea es reescribir el Makefile raíz para que el build sea paralelo, falle cuando debe y no dependa del orden en que se listan los paquetes.

Los paquetes simulan su build con `sleep` (un segundo cada uno, variable `DELAY`) para que el paralelismo se note. No hace falta compilador.

## Estructura del proyecto

```
starter/
├── Makefile              ← aquí trabajas
└── packages/
    ├── package.mk        ← reglas comunes de los paquetes (no se toca)
    ├── core/Makefile
    ├── util/Makefile
    ├── docs/Makefile
    └── app/Makefile      ← DEPS := core util
```

Cada paquete entiende tres variables desde la línea de comandos:

| Variable | Efecto |
|---|---|
| `FAIL=<paquete>` | Ese paquete falla a propósito |
| `TRACE=<archivo>` | Cada paquete escribe `start <pkg>` y `end <pkg>` en ese archivo |
| `DELAY=<segundos>` | Duración simulada del build (por defecto 1) |

## Lo que debes construir

Antes de tocar nada, comprueba el problema:

```bash
cd starter
make legacy-all FAIL=docs; echo "exit=$?"
```

Verás `[docs] FALLÓ` y, aun así, `exit=0`.

### 1. Preámbulo y salida agrupada (TODO 1 y 2)

Preámbulo estricto de la semana 03, y `OUTPUT_SYNC ?= target` añadido a `MAKEFLAGS` para que `make -j4 all` salga agrupado por paquete sin escribir `-O`.

### 2. Un target por paquete (TODO 3 y 4)

`PKG_TARGETS` contiene `packages/core/build`, `packages/core/clean`, `packages/util/build`... y una sola regla los resuelve con `$(MAKE) --no-print-directory -C $(@D) $(@F)`:

```bash
make packages/util/build
```
```
[util] inicio
[util] fin
```

### 3. `all`, `clean` y el grafo entre paquetes (TODO 5)

`all` y `clean` sin receta, solo prerrequisitos. Y una línea que declare que `packages/app/build` depende de `packages/core/build` y `packages/util/build`. Desde cero, `make all` termina con:

```bash
cat packages/app/dist/app.txt
```
```
app 1.0
  core 1.0
  util 1.0
```

Sin esa línea, `make all` funciona en serie (por el orden de `PACKAGES`), pero `make -j8 all` lanza `app` antes de que existan sus entradas y falla con `[app] falta ../core/dist/core.txt`.

### 4. `rebuild` seguro con `-j` (TODO 6)

`make -j8 rebuild` borra y reconstruye los cuatro paquetes. `rebuild: clean all` no sirve: con `-j`, `clean` y `all` corren a la vez.

### 5. Adiós al bucle (TODO 7)

Borra `legacy-all`. El Makefile raíz no puede contener ningún bucle `for` ni ninguna llamada a `make` literal.

## Verificación

Desde `starter/`:

```bash
make clean && time make all              # unos 4 s: en serie
make clean && time make -j4 all          # unos 2 s: core, util y docs a la vez, después app
make clean && make -j4 all TRACE=$PWD/trace.log && cat trace.log && rm trace.log
make -j4 all OUTPUT_SYNC=none            # salida cruda, entrelazada
make all FAIL=docs; echo "exit=$?"       # exit=2
make -k all FAIL=core                    # util y docs se construyen; app no
make -n all                              # el plan de cada paquete, sin construir nada
make -j8 rebuild
make clean DIST_DIR=                     # DIST_DIR vacía: rm -rf no se ejecuta
```

Y desde la raíz del repositorio:

```bash
./scripts/verificar-semana.sh 10
```

## ✅ Requisitos verificables

Los comprueba `./scripts/verificar-semana.sh 10` desde la raíz del repositorio
(60 de los 100 puntos del Producto). Los otros 40 son de calidad: ver la
[rúbrica](../rubrica-evaluacion.md#-producto-30).

- [ ] make all desde cero construye app con el trabajo de core y util
- [ ] make packages/util/build construye util y nada más
- [ ] Con make -j8 all desde cero, app se construye después de core y util
- [ ] Con make -j4 all, al menos dos paquetes se construyen a la vez
- [ ] Si un paquete falla, make all sale con error aunque el último paquete pase
- [ ] Con make -k all FAIL=core, util y docs se construyen y app no
- [ ] El Makefile raíz no recorre los paquetes con un bucle for
- [ ] Los sub-makes se invocan con $(MAKE), nunca con make literal
- [ ] make -n all llega hasta las recetas de los paquetes sin construir nada
- [ ] Con make -j4 all la salida de cada paquete sale agrupada sin pasar -O
- [ ] make -j8 rebuild rehace los cuatro paquetes y deja app construida
- [ ] make clean borra el dist/ de todos los paquetes
- [ ] make clean DIST_DIR= se niega a borrar porque la variable llega a cada paquete
- [ ] El Makefile raíz ejecuta las recetas con bash -eu -o pipefail
- [ ] El Makefile raíz declara .DELETE_ON_ERROR

El autograding tarda alrededor de medio minuto: muchas comprobaciones construyen el monorepo desde cero.

## Reto extra

Convierte el monorepo en **no recursivo** como en el [lab-06](../2-practicas/lab-06-no-recursivo/README.md): un `module.mk` por paquete incluido desde el raíz, sin sub-makes. Explica en el README qué ganas (un solo grafo: `app` depende directamente de `core/dist/core.txt`) y qué pierdes (`make -C packages/core build` deja de funcionar por sí solo).

## Entrega

Commit con el mensaje:
```
feat(week-10): proyecto - monorepo con build paralelo y recursión segura
```
