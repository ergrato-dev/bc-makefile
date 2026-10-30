# Auditoría del Makefile de notify

> Una fila por hallazgo. Severidad: Alta / Media / Baja. Todas las pruebas
> usan payloads inofensivos: un `touch` en una carpeta de `mktemp -d`.

| ID | Hallazgo | Severidad | Prueba (antes) | Corrección |
|----|----------|-----------|----------------|------------|
| H1 | Sin guarda de versión: con el make 3.81 de macOS `.SHELLFLAGS` se ignora en silencio y se pierde `pipefail` | Media | `make --version` en macOS; la receta `false \| true` sigue | `MIN_MAKE_VERSION` + `$(error)` al principio, con sintaxis 3.81 |
| H2 | Sin modo estricto: un fallo a mitad de receta no detiene el build | Media | `make package` con `tar` fallando sigue a `echo` | `SHELL := bash`, `.SHELLFLAGS := -eu -o pipefail -c`, `.DELETE_ON_ERROR:` |
| H3 | `BUILD_STAMP := $(shell mkdir ... \| tee ...)` escribe en disco al parsear, también con `make help` y `make -n` | Media | `rm -rf build; make help; ls build` | Eliminado. El único `$(shell)` al parsear es `git rev-parse` (solo lectura) |
| H4 | `-include .env` lo parsea como Makefile: un `$(shell ...)` o un `SHELL=` dentro se ejecuta | Alta | `.env` con `PWN := $(shell touch $D/pwned)` y `make help` | Lista blanca de claves y caracteres con `grep` antes del `include`; errores por número de línea, sin contenido |
| H5 | `export` a secas: el token llega a `tar`, `curl`, `fmt-tool` y a cualquier subproceso | Alta | `make --eval 'CANARIO := x' --eval '__probe: ; @env \| grep -c ^CANARIO=' __probe` da 1 | Sin `export` global; `unexport DEPLOY_TOKEN` y `export` específico solo en `build/curl-auth.conf` |
| H6 | `curl ... \| sh`: se ejecuta lo que sirva la URL, sin verificar | Alta | `make install-tools TOOL_URL=file://$D/inst.sh` con un `touch` dentro | Descargar a archivo, verificar SHA-256 fijado (`sha256sum` o `shasum -a 256`) y solo entonces ejecutar |
| H7 | `VERSION` se pega sin comillas en `tar` y `echo`: un tag con `` ` `` o `;` ejecuta código | Alta | `make package 'VERSION=1.0.0`touch $D/pwned`'` | Validación en Make con `$(value VERSION)`: una palabra, solo dígitos y puntos |
| H8 | `BRANCH` dentro de comillas dobles: `` ` `` y `$(...)` se ejecutan | Alta | `make package 'BRANCH=feat`touch $D/pwned`'` | Se toma literal con `override BRANCH := $(value BRANCH)` y llega a la receta como `"$$BRANCH"` |
| H9 | El token va en el texto del comando: sale en `make -n`, en el log del CI y en el argv de `bash` que ve `ps` | Alta | `make -n deploy DEPLOY_TOKEN=canario` muestra `canario` | La receta lee `"$$DEPLOY_TOKEN"` del entorno; `make -n` muestra `$DEPLOY_TOKEN` |
| H10 | `build/curl-auth.conf` nace con permisos 644 y queda en disco tras el deploy | Media | `ls -l build/curl-auth.conf` → `-rw-r--r--` | `umask 077` en la misma línea que lo escribe; `deploy` lo borra aunque `curl` falle |
| H11 | `rm -rf $(BUILD_DIR)/*` sin guarda: `BUILD_DIR=` borra `/*` | Alta | `make -n clean BUILD_DIR=` imprime `rm -rf /*` | Guardas de vacío, ruta absoluta, `..` y caracteres; `rm -rf -- '$(BUILD_DIR)'` |
| H12 | `package` es phony: se rehace siempre y `make -q` nunca puede decir "al día" | Baja | `make package; make -q build/notify-0.1.0.tar.gz` sin regla | Target de archivo `$(TARBALL): $(SRCS)`; `package` es un alias |
| H13 | Variables indefinidas (`CI_JOB_ID`, `DEPLOY_ENV`): un typo se expande a vacío sin avisar | Baja | `make --warn-undefined-variables -n package deploy` | Eliminadas; toda variable usada tiene valor por defecto, aunque sea vacío |
| H14 | `stat -c %s` solo existe en GNU coreutils: rompe en macOS/BSD | Baja | `stat -c %s archivo` en macOS falla | `wc -c < archivo \| tr -d ' '` |
| H15 | Sin autoprueba: nada impide que una regresión reabra H4–H11 | Media | `make check` sale con 1 sin probar nada | `make check` prueba avisos, inyección, dry-run, guardas y `make -q` |

## Riesgos aceptados

- `make deploy DEPLOY_TOKEN=...` deja el token en el argv de `make` (visible en
  `ps`). El Makefile no puede evitarlo: la documentación pide pasarlo por
  entorno (`DEPLOY_TOKEN=... make deploy`) o en `.env`.
- El token está en el entorno del proceso `make`; lo leen procesos del mismo
  usuario (`/proc/PID/environ`), no los de otros usuarios.
- La guarda de versión compara texto con `$(sort)`: fallaría con una
  hipotética Make 4.10. Se revisará si llega a existir.

## Cómo verificarlo

```bash
make check                                          # autoprueba completa
make -n deploy DEPLOY_TOKEN=canario | grep canario   # no imprime nada
make --warn-undefined-variables -n package deploy   # sin avisos
./scripts/verificar-semana.sh 13                     # desde la raíz del repo
```
