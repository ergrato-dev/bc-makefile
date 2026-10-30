# Lab 06 — Alternativas a Make: traducir y decidir

⏱ Duración estimada: ~60 min

## Objetivo

Traducir un Makefile a `justfile` y a `Taskfile.yml`, identificar qué se gana y qué se pierde en cada traducción, y decidir la herramienta adecuada para seis escenarios reales.

## Contexto

- just es un **command runner**: recetas con argumentos, sin fechas de archivos. Task (go-task) es un runner en YAML que sí decide si una tarea está al día, por checksums. Ninja es un ejecutor de bajo nivel que casi nunca se escribe a mano: lo genera CMake o Meson. Bazel apuesta por builds herméticos y caché remota.
- Este lab es "en papel": escribes los archivos y `make verify` comprueba su estructura con `grep`. **No necesitas instalar just ni Task**; si los tienes, el reto extra los ejecuta.
- Ninguna alternativa te libra de la Semana 13: `{{version}}` en just y `{{.VERSION}}` en Task pegan texto en el comando exactamente igual que `$(VERSION)` en Make.

## Instrucciones

Trabaja en `starter/`.

1. **Estudia el original.** Ejecuta:
   ```bash
   make build; make build
   make release VERSION=1.2.3
   make release "VERSION=1;touch pwned'"; ls
   ```
   La segunda `make build` dice `Nothing to be done`: Make compara fechas. La release inválida falla en la validación y no crea `pwned`. Fíjate en el comentario sobre `mkdir -p '$(@D)'`: una regla `$(BUILD_DIR):` se llamaría `build`, igual que el target, y Make avisaría de una dependencia circular.

2. **Escribe `justfile`.** Traduce `build`, `test` (que depende de `build`), `release` y `clean`, con estas condiciones:
   - Primera línea útil: `set shell := ["bash", "-euo", "pipefail", "-c"]` (el equivalente al preámbulo estricto).
   - Una receta `default` con `@just --list`: es el `help` de just, y usa como descripción el comentario que precede a cada receta.
   - `release` recibe la versión como parámetro (`release version: test`) y la valida citándola con `{{quote(version)}}`, la función de just equivalente a `$(call q,...)` del lab 02:
     ```just
     release version: test
         [[ {{quote(version)}} =~ ^[0-9]+[.][0-9]+[.][0-9]+$ ]] || { echo "Versión inválida" >&2; exit 1; }
         tar -czf build/manual-{{version}}.tar.gz -C build manual.txt
     ```
   Las recetas de just se indentan con espacios o tabuladores (de forma consistente), no obligatoriamente con TAB.

3. **Escribe `Taskfile.yml`.** Mismo contenido, en YAML:
   - `version: '3'` y un bloque `tasks:`.
   - `build` declara `sources: [src/*.txt]` y `generates: [build/manual.txt]`: con eso Task salta la tarea si las fuentes no cambiaron.
   - `test` con `deps: [build]`.
   - `release` con `requires: { vars: [VERSION] }` y la variable **por entorno**, no interpolada:
     ```yaml
     release:
       deps: [test]
       requires:
         vars: [VERSION]
       env:
         VERSION: '{{.VERSION}}'
       cmds:
         - '[[ "$VERSION" =~ ^[0-9]+[.][0-9]+[.][0-9]+$ ]] || { echo "Versión inválida" >&2; exit 1; }'
         - tar -czf "build/manual-$VERSION.tar.gz" -C build manual.txt
     ```
   Es la defensa 2 del lab 02: el valor viaja como dato y `"$VERSION"` nunca es código.

4. **Compara.** Escribe en una tabla (para ti, no se entrega) cómo resuelve cada herramienta: "¿está al día?", argumentos, ayuda, modo estricto, dependencias entre tareas y qué hay que instalar. Usa la tabla de `1-teoria/03-alternativas.md`.

5. **Rellena `DECISION.md`.** Para cada uno de los seis escenarios elige **una** herramienta (Make, just, Task, CMake + Ninja, Bazel) y justifícala en una línea con un criterio concreto: incremental por archivos, argumentos, multiplataforma sin bash, generación para IDEs, caché remota, coste de adopción. En la sección 2 escribe tres frases sobre lo que se pierde y se gana al traducir este Makefile.

6. **Verifica.**
   ```bash
   make verify
   ```
   Debe terminar con `verify: OK`. Si falta algo, el mensaje dice qué (`FALTA en justfile: quote(version) para citar el argumento`).

## Criterios de éxito

- [ ] `make verify` imprime `verify: OK`
- [ ] `justfile` tiene `set shell` estricto, `default` con `just --list` y `release version` con `quote()`
- [ ] `Taskfile.yml` usa `sources`/`generates` en `build` y `requires` + `env` en `release`
- [ ] `DECISION.md` elige una herramienta por escenario con un criterio verificable, sin `TODO`
- [ ] La sección 2 menciona el build incremental y la interpolación de variables

## Reto extra

Instala just y Task (o usa un contenedor) y ejecuta tus traducciones:

```bash
just --list && just release 1.2.3 && just release "1;touch pwned"
task --list && task release VERSION=1.2.3 && task build
```

Comprueba que `task build` responde `Task "build" is up to date` y que
`just build` vuelve a concatenar. Después quita `quote()` de tu `justfile`,
ejecuta `just release "1 ]] && touch pwned; [[ 1"` y explica por qué aparece
`pwned` aunque la release falla con `Versión inválida`.
