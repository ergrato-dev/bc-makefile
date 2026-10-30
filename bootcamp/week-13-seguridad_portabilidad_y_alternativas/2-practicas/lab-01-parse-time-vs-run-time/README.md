# Lab 01 — Parse-time vs run-time: lo que Make ejecuta sin que lo pidas

⏱ Duración estimada: ~60 min

## Objetivo

Eliminar todo lo que un Makefile ejecuta al cargarse, incluido el contenido de un `.env`, para que `make help` y `make -n` no tengan efectos.

## Contexto

- Make trabaja en dos fases: primero **lee** todo el Makefile (parse-time) y después **ejecuta** recetas (run-time). Un `:=` con `$(shell ...)` se ejecuta en la primera fase: con `make help`, con `make -n` y con cualquier target.
- `make -n` tampoco es inerte: expande las recetas para imprimirlas (así que corre cada `$(shell ...)` que haya en ellas) y **ejecuta** las líneas con `+` o con `$(MAKE)`.
- `include .env` no lee "variables": lee un Makefile. Cualquiera que pueda escribir ese archivo puede ejecutar código en tu máquina o en el CI.

## Instrucciones

Trabaja en `starter/`.

1. **Mide el parse-time.** Ejecuta:
   ```bash
   time make help
   ls -A
   ```
   La ayuda tarda unos 2 s y aparece una carpeta `.cache/` aunque no pediste construir nada. Las dos culpables son `LATEST := $(shell sleep 2; ...)` y `CACHE := $(shell mkdir -p ...)` (TODO 1 y 2).

2. **Comprueba que `-n` no es inerte.** Borra `.cache/` y simula una publicación:
   ```bash
   rm -rf .cache
   make -n publish
   ls -A .cache
   ```
   Make "solo" imprimió comandos, pero `.cache/last-publish` existe: el `$(shell mkdir ...)` corrió al parsear y la línea `+touch` se ejecutó de verdad.

3. **Mueve el trabajo a las recetas** (TODO 1 y 2):
   - Borra `LATEST`. La consulta pasa a ser shell dentro de la receta de `build`:
     `latest=$$(sleep 2; echo 1.4.2); echo "<h1>$(SITE_TITLE) $$latest</h1>" > ...`
     (las dos órdenes en la misma línea lógica, unidas con `; \`).
   - Sustituye `CACHE` por `CACHE_DIR := .cache` y crea las carpetas con una regla
     `$(OUT_DIR) $(CACHE_DIR): ; mkdir -p '$@'` usada como prerrequisito order-only (`| $(CACHE_DIR)`).

   Comprueba:
   ```bash
   make clean; time make help; ls -A
   ```
   Debes ver la ayuda en centésimas de segundo y ningún `.cache/`.

4. **Quita el `+`** (TODO 4). El prefijo `+` significa "ejecuta esta línea aunque estés en `-n`", y existe para las líneas que lanzan `$(MAKE)` (que ya lo llevan implícito). En un `touch` es un efecto secundario escondido. Después:
   ```bash
   make -n publish; ls -A
   ```
   Solo debe aparecer `Makefile`: ni `out/` ni `.cache/`. Fíjate en que `make -n` ahora muestra `latest=$(sleep 2; echo 1.4.2)` sin esperar 2 s: el shell de una receta no corre en `-n`; un `$(shell)` en la receta sí correría.

5. **Ataca tu `.env`.** Crea dos archivos de entorno "maliciosos" (los payloads son inofensivos):
   ```bash
   printf 'PWN := $(shell touch pwned.txt)\n' > malicioso.env
   make help ENV_FILE=malicioso.env; ls pwned.txt
   printf 'SHELL = /bin/echo\n' > shell.env
   make build ENV_FILE=shell.env
   ```
   El primero ejecuta código con un simple `make help`. El segundo cambia el intérprete de **todas** las recetas: `build` imprime `-eu -o pipefail -c mkdir -p out` en lugar de ejecutarlo. Con `/bin/echo` es inofensivo; con un script del atacante no lo sería.

6. **Valida antes de incluir** (TODO 3). Sustituye el `-include` por:
   ```makefile
   ENV_FILE ?= .env
   ifneq ($(wildcard $(ENV_FILE)),)
     ENV_BAD := $(shell grep -nvE '^(#.*|SITE_TITLE=[A-Za-z0-9_./:@+-]*)?$$' '$(ENV_FILE)' | cut -d: -f1)
     ifneq ($(ENV_BAD),)
       $(error $(ENV_FILE): líneas no permitidas: $(ENV_BAD). Formato: SITE_TITLE=valor)
     endif
     include $(ENV_FILE)
   endif
   ```
   Este `$(shell)` sí puede correr al parsear: solo lee, es barato y no ejecuta el contenido del archivo. El mensaje da números de línea y nunca el contenido, porque una línea mala puede llevar un secreto.

7. **Verifica todo:**
   ```bash
   rm -f pwned.txt
   make help ENV_FILE=malicioso.env; ls pwned.txt
   printf 'SITE_TITLE=Manual\n' > ok.env
   make publish ENV_FILE=ok.env && cat out/index.html
   make clean; rm -f malicioso.env shell.env ok.env
   ```
   Salida esperada (en ese orden): un error `malicioso.env: líneas no permitidas: 1`, un `ls` que dice que `pwned.txt` no existe, y `<h1>Manual 1.4.2</h1>`.

## Criterios de éxito

- [ ] `time make help` tarda menos de 0,5 s y no crea ningún archivo ni carpeta
- [ ] `make -n publish` en un directorio limpio no crea `out/` ni `.cache/`
- [ ] No queda ningún `+` en el Makefile
- [ ] `make help ENV_FILE=malicioso.env` falla con `líneas no permitidas: 1` y no crea `pwned.txt`
- [ ] `make build ENV_FILE=shell.env` falla en lugar de cambiar el intérprete
- [ ] `make publish ENV_FILE=ok.env` genera `out/index.html` con `<h1>Manual 1.4.2</h1>`

## Reto extra

Busca en un Makefile real que uses a diario (el de un proyecto tuyo o uno de
GitHub) todos los `:=` con `$(shell ...)` y clasifícalos: de solo lectura y
barato (déjalo), de solo lectura pero lento (pásalo a `=` o a la receta), o
con efectos (muévelo a una receta). Comprueba la diferencia con `time make help`.
