# Glosario — Semana 13: Seguridad, portabilidad y alternativas

| Término | Definición en una línea | Ejemplo en Makefile |
|---------|------------------------|---------------------|
| Parse-time | Fase en la que Make lee el Makefile completo; lo que se ejecuta aquí corre con cualquier target, también con `make help` | `STAMP := $(shell date)` |
| Run-time | Fase en la que Make ejecuta las recetas de los targets pedidos | `build: ; date > stamp` |
| Prefijo `+` | Ejecuta la línea aunque Make esté en `-n`, `-q` o `-t`; pensado para sub-makes | `+$(MAKE) -C lib` |
| Inyección de comandos | Un valor externo que, pegado en una receta, se interpreta como código | `echo '$(VERSION)'` con `VERSION="1'; id; '"` |
| Lista blanca | Validar aceptando solo caracteres o claves conocidos, en vez de buscar los peligrosos | `$(call safe-word,$(value VERSION),$(DIGITS) .)` |
| `$(value VAR)` | Devuelve el texto de una variable sin expandirlo | `override NOTE := $(value NOTE)` |
| Paso por entorno | Llevar un dato a la receta como variable de entorno y leerlo con `"$$VAR"`, para que el shell nunca lo trate como código | `export BRANCH` + `printf '%s' "$$BRANCH"` |
| `unexport` | Quita una variable del entorno de las recetas, aunque venga del entorno o de la línea de comandos | `unexport API_TOKEN` |
| Export por target | Exporta una variable solo a un target (y a sus prerrequisitos) | `deploy: export TOKEN := $(TOKEN)` |
| `umask 077` | Máscara que hace que los archivos nuevos solo los pueda leer su dueño | `umask 077; printf ... > creds.conf` |
| Checksum fijado | Hash SHA-256 escrito en el Makefile que un archivo descargado debe cumplir antes de usarse | `echo '$(SHA)  f' \| sha256sum -c -` |
| `--warn-undefined-variables` | Avisa cada vez que se expande una variable que no existe | `make --warn-undefined-variables -n all` |
| `make -q` | Pregunta si un target está al día: sale con 0 (sí), 1 (no) o 2 (error) | `make -q build/app.tar.gz` |
| `--shuffle` | Make 4.4+: construye los prerrequisitos en orden aleatorio para destapar dependencias que faltan | `make --shuffle=reverse all` |
| `.POSIX` | Target especial que pide comportamiento POSIX; en GNU Make, entre otras cosas, recetas como con `sh -e` | `.POSIX:` |
