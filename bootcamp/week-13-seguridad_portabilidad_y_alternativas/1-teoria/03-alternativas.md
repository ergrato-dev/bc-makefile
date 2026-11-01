# Alternativas a Make: cuándo cambiar y cuándo no

## ¿Por qué importa esto?

Tarde o temprano alguien en tu equipo propone "migrar a just" o "pasarnos a Bazel". A veces tiene razón y a veces cambia un problema conocido por otro nuevo. Para decidir hay que saber qué resuelve cada herramienta, qué cuesta adoptarla y qué hace Make mejor que ninguna.

## Qué es cada una

| Herramienta | Qué es | ¿Sabe si algo está al día? | Archivo |
|---|---|---|---|
| **GNU Make** | Motor de reglas archivo → archivo, más un runner de tareas | Sí, por fechas de archivos | `Makefile` |
| **just** | Command runner: recetas con argumentos, sin semántica de archivos | No: cada receta se ejecuta siempre | `justfile` |
| **Task** (go-task) | Runner en YAML, binario Go multiplataforma con su propio intérprete de shell | Sí, por checksum de `sources` (estado en `.task/`) | `Taskfile.yml` |
| **Ninja** | Ejecutor de bajo nivel, muy rápido; su archivo no se escribe a mano | Sí, y lleva registro de los comandos | `build.ninja` (generado) |
| **CMake** / **Meson** | Generadores: describen el proyecto y producen Makefiles o `build.ninja` | A través del backend | `CMakeLists.txt`, `meson.build` |
| **Bazel** | Builds herméticos y reproducibles con caché remota, para monorepos grandes | Sí, por contenido, y comparte resultados entre máquinas | `BUILD`, `MODULE.bazel` |

## Tabla de decisión

| Si tu situación es… | Usa | Por qué |
|---|---|---|
| Fachada de tareas (`test`, `lint`, `release`) sobre uv, pnpm o docker, en Linux/macOS | **Make** | Ya está instalado; `make help` es la convención que todos conocen |
| Archivos que se generan de otros archivos y solo hay que rehacer lo que cambió | **Make** | Es exactamente su modelo: grafo de archivos con fechas |
| Recetas con argumentos posicionales (`deploy staging`, `logs api 100`), sin artefactos | **just** | Parámetros reales, mejores mensajes, sin trampas de `.PHONY` ni TAB |
| Equipo con Windows sin WSL, o que no quiere depender de bash ni de GNU Make | **Task** | Un binario, YAML, mismo comportamiento en los tres sistemas |
| C/C++ multiplataforma, MSVC, integración con IDEs, dependencias externas | **CMake + Ninja** | CMake genera para cada plataforma; Ninja compila rápido |
| Monorepo grande, varios lenguajes, CI lento, se quiere caché compartida | **Bazel** | Hermeticidad y caché remota; el coste de adopción solo se amortiza a esta escala |

Make sigue siendo la elección correcta si el Makefile cabe en una o dos pantallas, sus targets llaman a otras herramientas y el CI corre en Linux. Deja de serlo si necesitas Windows nativo, pasas `ARGS="..."` a diario o generas reglas con `$(eval)` para emular módulos.

## Lo que no cambia al cambiar de herramienta

- **La inyección.** `{{version}}` en just y `{{.VERSION}}` en Task pegan texto en el comando igual que `$(VERSION)`. just tiene `quote()`; en Task, pasa el valor por `env:` y léelo como `"$VERSION"`.
- **Los secretos.** Todo runner que imprime los comandos los filtra si van en el texto.
- **`curl | sh`**, permisos y `rm -rf`. Son problemas del shell, no de Make.

## Ejemplo mínimo funcional

Lo que just no hace y Make sí: no repetir trabajo. Pega esto y ejecuta `make` dos veces.

```makefile
SHELL       := bash
.SHELLFLAGS := -eu -o pipefail -c
.PHONY: all

all: out/manual.txt

out/manual.txt: intro.txt uso.txt
	mkdir -p $(@D)
	cat $^ > $@
	@echo "manual regenerado"

intro.txt uso.txt:
	printf '%s\n' "Capítulo $@" > $@
```

La primera vez genera todo; la segunda responde `Nothing to be done for 'all'`; tras `touch uso.txt`, regenera solo `out/manual.txt`. Su equivalente en just ejecutaría `cat` cada vez:

```just
build:
    mkdir -p out
    cat intro.txt uso.txt > out/manual.txt
```

---

Listo. Ve al [lab-06](../2-practicas/lab-06-alternativas-a-make/README.md) y ponlo en práctica.
