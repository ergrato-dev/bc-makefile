# Lab 03 — Secretos sin fugas y descargas verificadas

⏱ Duración estimada: ~60 min

## Objetivo

Cerrar las seis salidas por las que un token se filtra desde un Makefile y sustituir un `curl | sh` por una descarga verificada con SHA-256.

## Contexto

- En la Semana 12 viste `export` selectivo y `guard-%`. Aquí vas más lejos: **dónde** acaba un secreto que pegas en una receta. Make ejecuta cada línea como `bash -c '<línea expandida>'`, así que lo que escribas con `$(TOKEN)` queda en el argv de un proceso (lo ve cualquier usuario con `ps`), en la salida de `make -n` y en el log del CI.
- Un archivo de credenciales hereda el `umask` del proceso: con el habitual `022` nace legible por todos.
- `curl URL | sh` ejecuta lo que el servidor sirva en ese momento, sin que nadie lo vea. Si el dominio, el CDN o la cuenta caen, tu CI ejecuta código ajeno.

## Instrucciones

Trabaja en `starter/`. El "servidor" es `build/remote/` y la herramienta se descarga de `vendor/` por `file://`: no hace falta red. Crea primero el secreto de prueba:

```bash
printf 'API_TOKEN=s3cr3t-lab03\n' > .env
```

1. **`export` a secas.** Ejecuta `make lint`: imprime `lint: veo API_TOKEN`. Un linter de terceros (o cualquier `postinstall`) recibe el token sin necesitarlo. Borra la línea `export`. Repite: ahora debe decir `lint: no veo API_TOKEN`.

2. **El entorno también cuenta.** Borra `.env` y ejecuta `API_TOKEN=s3cr3t-env make lint`: vuelve a decir `veo`. Las variables que vienen del entorno o de la línea de comandos se exportan siempre. Para cortar eso, añade en el Makefile:
   ```makefile
   unexport API_TOKEN
   $(AUTH_FILE): export API_TOKEN := $(API_TOKEN)
   ```
   `unexport` lo quita de **todas** las recetas; el export específico de target se lo devuelve solo a la que escribe las credenciales (y a sus prerrequisitos). Vuelve a crear `.env` y comprueba que `make lint` dice `no veo` en los dos casos.

3. **Lo que ve `ps`.** Ejecuta `make spy`. La línea imprime el argv del bash que la ejecuta, tal como lo vería otro usuario con `ps aux`:
   ```
   bash -eu -o pipefail -c echo "token=s3cr3t-lab03" >/dev/null; ps -o args= -p $$; true
   ```
   El `@` y el `>/dev/null` no protegen nada: el token está en la línea de comandos. Cambia `$(API_TOKEN)` por `$$API_TOKEN` (bash lo lee de su entorno) y añade `spy: export API_TOKEN := $(API_TOKEN)`. Ahora `make spy` muestra `echo "token=$API_TOKEN"`.

4. **Lo que ve `make -n`.**
   ```bash
   make -n upload | grep -c s3cr3t
   ```
   Imprime `2`: la receta de credenciales y el log de depuración pegan el valor. En la receta de `$(AUTH_FILE)` escribe el token con `printf 'header = "Authorization: Bearer %s"\n' "$$API_TOKEN" > '$@'`. El conteo debe bajar a `1` (el log, que arreglas en el paso 6).

5. **Permisos del archivo de credenciales.**
   ```bash
   make upload; ls -l build/auth.conf
   ```
   Sale `-rw-r--r--`. Pon `umask 077;` delante del `printf`, **en la misma línea** (cada línea es un shell distinto y el `umask` no sobrevive a la siguiente). Tras `make clean; make upload`, `ls -l` debe mostrar `-rw-------`.

6. **Enmascarar la salida de una herramienta.** La línea `curl-debug` simula una herramienta que imprime el token en su log. Captura su salida y tacha el valor con bash puro:
   ```makefile
   upload: export API_TOKEN := $(API_TOKEN)
   ```
   ```makefile
   	out=$$(printf 'curl-debug: usando token %s\n' "$$API_TOKEN"); \
   	printf '%s\n' "$${out//"$$API_TOKEN"/****}"
   ```
   No uses `sed "s/$$API_TOKEN/****/"`: el token iría en el argv de `sed`, y volverías al paso 3. Ahora `make -n upload | grep -c s3cr3t` imprime `0` y `make upload` muestra `curl-debug: usando token ****`.

7. **Sustituye `curl | sh`.** Primero comprueba el riesgo con un instalador "alterado" (payload inofensivo):
   ```bash
   printf 'touch pwned.txt\n' > evil.sh
   make install-tool TOOL_URL=file://$PWD/evil.sh; ls pwned.txt
   ```
   El instalador se ejecutó sin que nadie lo mirase. Reescribe `install-tool` como alias de un target de archivo `$(TOOLS_DIR)/hello` que:
   - descarga a un archivo con `curl -fsSL -o '$(BUILD_DIR)/install-hello.sh' "$$TOOL_URL"` (con `export TOOL_URL` específico del target);
   - verifica el hash fijado (calcúlalo una vez con `sha256sum vendor/install-hello.sh`, o `shasum -a 256` en macOS):
     ```makefile
     TOOL_SHA256 := <hash>
     SHA256SUM    = $(if $(shell command -v sha256sum 2>/dev/null),sha256sum,shasum -a 256)
     ```
     ```makefile
     	echo '$(TOOL_SHA256)  $(BUILD_DIR)/install-hello.sh' | $(SHA256SUM) -c - >/dev/null \
     		|| { rm -f -- '$(BUILD_DIR)/install-hello.sh'; echo "SHA-256 incorrecto: el instalador no se ejecuta" >&2; exit 1; }
     ```
   - y solo entonces lo ejecuta con `PREFIX='$(TOOLS_DIR)' sh '$(BUILD_DIR)/install-hello.sh'`.

   `SHA256SUM` usa `=` (perezoso) para que el `$(shell)` no corra en `make help`.

8. **Verificación final.**
   ```bash
   rm -f pwned.txt; make clean
   make install-tool TOOL_URL=file://$PWD/evil.sh; ls pwned.txt
   make install-tool && build/tools/hello
   make clean; rm -f .env evil.sh
   ```
   Debes ver `SHA-256 incorrecto: el instalador no se ejecuta`, un `ls` que no encuentra `pwned.txt` y `hola desde hello 2.0.1`.

## Criterios de éxito

- [ ] `make lint` dice `no veo API_TOKEN` tanto con `.env` como con `API_TOKEN=x make lint`
- [ ] `make spy` muestra `$API_TOKEN`, nunca el valor
- [ ] `make -n upload | grep -c s3cr3t` imprime `0`
- [ ] `build/auth.conf` tiene permisos `-rw-------`
- [ ] `make upload` imprime `curl-debug: usando token ****`
- [ ] Un instalador con otro hash no se ejecuta; el bueno instala `build/tools/hello`

## Reto extra

`build/auth.conf` sigue en disco después de `make upload`. Haz que `upload` lo
borre aunque `curl` falle, en una sola línea:
`st=0; curl ... || st=$$?; rm -f -- '$(AUTH_FILE)'; exit "$$st"`. Comprueba que
funciona forzando un fallo con una URL `file://` a una carpeta inexistente.
