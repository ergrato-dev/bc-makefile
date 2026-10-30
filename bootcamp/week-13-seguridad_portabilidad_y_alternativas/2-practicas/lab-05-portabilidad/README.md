# Lab 05 — Portabilidad: versiones de Make, comandos y POSIX

⏱ Duración estimada: ~60 min

## Objetivo

Hacer que un Makefile falle con un mensaje claro en un Make demasiado viejo, sustituir cinco comandos exclusivos de GNU y reescribir un Makefile auxiliar en make POSIX que funcione también con bmake.

## Contexto

- macOS trae GNU Make **3.81** (2006). No da error con un Makefile moderno: lo ejecuta **mal**. `.SHELLFLAGS` llegó en 3.82, así que 3.81 la trata como una variable más y tus recetas pierden `pipefail` sin avisar. `$(file <)` (4.2) devuelve vacío.
- El Makefile es solo la mitad: `sed -i`, `stat -c`, `date --iso-8601`, `sha256sum` y `echo -e` son de GNU coreutils o de bash, y en macOS/BSD fallan o hacen otra cosa.
- POSIX.1-2024 amplió make (`::=`, `?=`, `+=`, `!=`, `$^`, `.PHONY`, `-include`), pero sigue sin `:=`, condicionales, `$(shell)`, funciones ni reglas `%`. BSD make (bmake) es la prueba real.

## Instrucciones

Trabaja en `starter/`. Hay dos archivos: `Makefile` (el principal, GNU Make ≥ 4.3) y `Makefile.posix` (el auxiliar que debe ser portable).

1. **Guarda de versión.** Añade esto como **primeras líneas** del `Makefile`, antes del preámbulo estricto:
   ```makefile
   MIN_MAKE_VERSION := 4.3
   ifneq ($(MIN_MAKE_VERSION),$(firstword $(sort $(MAKE_VERSION) $(MIN_MAKE_VERSION))))
     $(error Se requiere GNU Make >= $(MIN_MAKE_VERSION); tienes $(MAKE_VERSION). En macOS: brew install make y usa gmake)
   endif
   ```
   `$(sort)` ordena como texto: si la versión mínima no sale primera, la tuya es menor. Solo usa sintaxis que 3.81 entiende, para que el make viejo pueda leerla y explicar el problema. (Ordenar texto fallaría con una hipotética 4.10; anótalo en un comentario.) Simula una versión antigua:
   ```bash
   make help MIN_MAKE_VERSION=9.9
   ```
   Debe parar con `Se requiere GNU Make >= 9.9; tienes 4.3`.

   > Si tienes Docker, puedes verlo con un 3.81 real: `docker run --rm -v "$PWD":/w -w /w ubuntu:14.04 bash -c 'apt-get update -qq && apt-get install -y -qq make >/dev/null && make help'`.

2. **Detecta features, no versiones.** Lista lo que soporta tu Make:
   ```bash
   make -p -f /dev/null 2>/dev/null | grep '^.FEATURES'
   ```
   En 4.3 verás `output-sync`, `grouped-target`, `extra-prereqs`…; en 3.81, solo siete palabras. Activa `--output-sync` únicamente si existe (TODO del paso 2):
   ```makefile
   ifneq ($(filter output-sync,$(.FEATURES)),)
     MAKEFLAGS += --output-sync=target
   endif
   ```
   Comprueba con `make -p __nada__ 2>/dev/null | grep '^MAKEFLAGS'`: debe aparecer `-Otarget`.

3. **Cinco comandos no portables.** Sustitúyelos (TODO del paso 3) y explica cada cambio con un `# FIX:`:

   | En el starter | Problema en macOS/BSD | Portable |
   |---|---|---|
   | `sed -i 's/…/…/' f` | `-i` exige un sufijo de backup: toma el script como sufijo | `sed 's/…/…/' f > f.tmp` y `mv f.tmp f` en la línea siguiente |
   | `echo -e "a\tb"` | Depende del shell: `dash` imprime `-e` literal | `printf 'a\t%s\n' …` |
   | `stat -c %s f` | BSD usa `stat -f %z` | `wc -c < f \| tr -d ' '` |
   | `sha256sum f` | No viene en todas las versiones de macOS | `SHA256SUM = $(if $(shell command -v sha256sum 2>/dev/null),sha256sum,shasum -a 256)` |
   | `date --iso-8601=seconds` | Opción larga solo de GNU | `date -u +%Y-%m-%dT%H:%M:%SZ` |

   Verifica:
   ```bash
   make info
   make stamp-docs && head -3 docs/intro.md
   ```
   `info` imprime `Artefacto`, `Tamaño`, `SHA-256` y `Fecha`; `docs/intro.md` dice `Versión: 1.4.2`.

4. **Reescribe `Makefile.posix` en POSIX.** Cuenta primero sus extensiones GNU (hay seis: `:=` ×2, `$(wildcard)`, `$(patsubst)`, la regla `%` y el `ifeq`). Sustitúyelas:
   - `.POSIX:` como **primera** línea que no sea comentario. En GNU Make además ejecuta cada receta como con `sh -e`: el primer comando que falla la detiene.
   - `.SUFFIXES:` (vacía la lista) y `.SUFFIXES: .md .html`.
   - `DOCS = docs/intro.md docs/uso.md` (lista explícita) y `HTML = $(DOCS:.md=.html)` (sustitución de sufijo).
   - La regla de patrón pasa a regla de inferencia `.md.html:`, con la misma receta. En ella `$<` sí está definido por POSIX.
   - El `ifeq ($(VERBOSE),1)` desaparece: POSIX no tiene condicionales.
   - `.PHONY: all clean` al final (POSIX desde 2024).

   ```bash
   make posix && cat docs/uso.html
   ```
   Debe mostrar `<h1>Uso</h1>`.

5. **Un linter de portabilidad.** Implementa `portability-check`: un `grep -nE` con un `-e` por familia de extensiones GNU, que imprima las líneas culpables y falle si encuentra alguna:
   ```makefile
   GNUISMS := -e '^[[:space:]]*(ifeq|ifneq|ifdef|ifndef|else|endif|define|endef|override|export|unexport|vpath)([[:space:]]|$$)' \
              -e '[$$]\((shell|wildcard|patsubst|subst|foreach|call|if|or|and|filter|filter-out|sort|dir|notdir|basename|addprefix|addsuffix|eval|file|info|warning|error)[[:space:]]' \
              -e '^[^\#[:space:]=]*%[^=]*:' \
              -e '(^|[^:])[:]='
   ```
   Ojo con `\#`: un `#` sin escapar dentro de una variable empieza un comentario y corta la expresión. La última expresión detecta `:=` pero no `::=` ni `:::=`, que sí son POSIX. Pruébalo con el `Makefile.posix` original (`git stash` o una copia) y con el tuyo:
   ```bash
   make portability-check
   ```
   Con el original lista las líneas 5, 6, 12, 13 y 15 y falla; con el tuyo imprime `Makefile.posix: sin extensiones GNU conocidas`.

6. **Limpia:** `make clean` borra `dist/` y los `.html` (llama a `Makefile.posix clean`).

## Criterios de éxito

- [ ] `make help MIN_MAKE_VERSION=9.9` falla con `Se requiere GNU Make >= 9.9`
- [ ] `make -p __nada__ 2>/dev/null | grep '^MAKEFLAGS'` muestra `-Otarget`
- [ ] Ningún `sed -i`, `echo -e`, `stat -c`, `sha256sum` a secas ni `date --iso-8601` en el `Makefile`
- [ ] `make info` y `make stamp-docs` funcionan
- [ ] `make posix` genera `docs/intro.html` y `docs/uso.html`
- [ ] `make portability-check` pasa con tu `Makefile.posix` y falla con el original

## Reto extra

Pruébalo con un make que no sea GNU, en un contenedor:

```bash
docker run --rm -v "$PWD":/w -w /w debian:13 \
  bash -c 'apt-get update -qq && apt-get install -y -qq bmake >/dev/null && bmake -f Makefile.posix && bmake -f Makefile.posix clean'
```

Con tu versión, bmake genera los HTML. Con el original falla en el `ifeq`
(`Missing dependency operator`). Después ejecuta `bmake -f Makefile help` y
explica por qué el Makefile principal **no** tiene que ser portable a bmake.
