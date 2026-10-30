# Lab 02 — bash frente a /bin/sh, y `.SHELLFLAGS`

⏱ Duración estimada: ~60 min

## Objetivo

Fijar `SHELL := bash` y `.SHELLFLAGS := -eu -o pipefail -c` después de ver, uno por uno, los fallos que provoca no hacerlo.

## Contexto

- Si el Makefile no dice nada, Make ejecuta las recetas con `/bin/sh`. En Debian, Ubuntu y casi todas las imágenes Docker y runners de CI, `/bin/sh` es **dash**: no tiene `[[ ]]`, ni `{a,b}`, ni `pipefail`. Tu terminal (bash o zsh) no cuenta: Make ignora la variable `SHELL` del entorno.
- Make invoca cada línea como `$(SHELL) $(.SHELLFLAGS) "línea"`. El valor por defecto de `.SHELLFLAGS` es `-c`; si lo cambias, el `-c` es tuyo.
- En macOS `/bin/sh` es bash en modo POSIX y los pasos 1 a 3 "funcionan". Para ver lo que verá tu CI, añade `SHELL=/bin/dash` a esos comandos (macOS trae dash desde Catalina): `make mode ENV=prod SHELL=/bin/dash`.

## Instrucciones

Trabaja en `starter/`.

1. ¿Quién ejecuta tus recetas?
   ```bash
   cd starter
   make which-shell
   ```
   ```
   Las recetas las ejecuta: /bin/sh
   ```

2. Ejecuta `make mode ENV=prod`:
   ```
   /bin/sh: 1: [[: not found
   modo desarrollo
   ```
   Dos problemas: dash no conoce `[[` y, como el `if` toma el fallo como "falso", ejecuta la rama `else`. Comprueba `echo $?` después: **0**. Un Makefile que despliega en desarrollo cuando pediste producción, y sale con éxito.

3. Ejecuta `make dirs` y luego `make pipe`:
   ```
   mkdir -p build/{logs,tmp}
   ls build
   {logs,tmp}
   ```
   ```
   /bin/sh: 1: set: Illegal option -o pipefail
   make: *** [Makefile:32: pipe] Error 2
   ```
   dash no expande llaves: creó **un** directorio llamado `{logs,tmp}`. Y no tiene `pipefail`. Borra el resultado con `make clean`.

4. Sustituye `# TODO (paso 4)` por:
   ```makefile
   SHELL := bash
   ```
   Repite los pasos 1 a 3. Ahora `which-shell` dice `bash`, `mode ENV=prod` dice `modo producción`, `dirs` lista `logs` y `tmp`, y `pipe` imprime `pipefail activo`. Comprueba que Make lo ve:
   ```bash
   make -p __nada__ 2>/dev/null | grep '^SHELL'
   ```
   ```
   SHELL := bash
   ```

5. Ejecuta `make check-config`: imprime `config OK` aunque `build/config.ini` no existe. Make sí comprueba el código de salida de cada línea, pero esa línea tiene dos comandos separados por `;` y solo cuenta el último. Sustituye `# TODO (paso 5)` por:
   ```makefile
   .SHELLFLAGS := -e -c
   ```
   `make check-config` termina ahora con `make: *** [Makefile:35: check-config] Error 1`. Con `-e`, bash para en el primer comando que falla, aunque no sea el último de la línea.

6. Ejecuta `make publish`: imprime `publicando en /app`. `DEST_DIR` no existe y el shell la sustituye por nada. Cambia `.SHELLFLAGS` a la forma completa, pero **olvida el `-c` a propósito**:
   ```makefile
   .SHELLFLAGS := -eu -o pipefail
   ```
   ```
   bash: echo "publicando en $DEST_DIR/app": No such file or directory
   make: *** [Makefile:38: publish] Error 1
   ```
   Sin `-c`, bash interpreta la receta como el nombre de un script. Añade el `-c` al final:
   ```makefile
   .SHELLFLAGS := -eu -o pipefail -c
   ```
   ```
   bash: line 1: DEST_DIR: unbound variable
   make: *** [Makefile:38: publish] Error 1
   ```
   Eso es `-u`: un fallo ruidoso en vez de publicar en `/app`. Pásale el valor: `make publish DEST_DIR=/srv/www` imprime `publicando en /srv/www/app`. Las variables de la línea de comandos llegan al entorno de las recetas.

7. Completa el preámbulo con `.DELETE_ON_ERROR:` debajo de `.SHELLFLAGS` (lo verás en acción en el lab-04) y añade encima de cada línea un comentario que explique qué hace cada flag. Comprueba que nada se ha roto con `make dirs` y `make clean`.

## Criterios de éxito

- [ ] `make which-shell` imprime `Las recetas las ejecuta: bash`
- [ ] `make mode ENV=prod` imprime `modo producción` y `make dirs` crea `build/logs` y `build/tmp`
- [ ] `make pipe` imprime `pipefail activo`
- [ ] `make check-config` termina con error mientras no exista `build/config.ini`
- [ ] `make publish` falla con `DEST_DIR: unbound variable`; `make publish DEST_DIR=/srv/www` funciona
- [ ] Puedes explicar qué pasa si `.SHELLFLAGS` no termina en `-c`

## Reto extra

A veces una variable de entorno es opcional de verdad. Haz que `make publish` use `build/dist` si no se define `DEST_DIR`, sin quitar `-u`, con la expansión de bash `$${DEST_DIR:-$(BUILD_DIR)/dist}`. Explica en un comentario por qué el `$$` es imprescindible y qué parte expande Make y qué parte el shell.
