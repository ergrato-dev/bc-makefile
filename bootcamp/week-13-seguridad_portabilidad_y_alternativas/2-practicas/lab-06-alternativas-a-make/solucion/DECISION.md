# Decisión: ¿Make, just, Task, ninja, CMake o Bazel?

## 1. Escenarios

| # | Escenario | Herramienta | Por qué |
|---|-----------|-------------|---------|
| 1 | Repo Python con uv: `test`, `lint` y `release` que llaman a uv; Linux y macOS | Make | Fachada de tareas sobre uv, ya instalado en ambos sistemas; `uv.lock` como prerrequisito evita reinstalar |
| 2 | Librería C++ de 300 archivos que se compila en Linux, macOS y Windows (MSVC) y se abre en IDEs | CMake + Ninja | CMake genera el build para cada plataforma e IDE; Ninja lo ejecuta rápido |
| 3 | Monorepo de 50 servicios en 4 lenguajes; CI de 40 min; se quiere caché remota compartida | Bazel | Builds herméticos y caché remota: el coste de adopción se amortiza a esta escala |
| 4 | Equipo con desarrolladores en Windows sin WSL; tareas de desarrollo (`docker compose up`, cargar datos) | Task | Binario único multiplataforma con su propio intérprete de shell: no exige bash ni GNU Make |
| 5 | Generar 2.000 PDFs desde Markdown e imágenes; rehacer solo los que cambian | Make | Grafo de archivos con fechas y reglas de patrón: es justo para lo que existe Make |
| 6 | Scripts de operación con argumentos (`deploy staging`, `logs api 100`) sin artefactos | just | Recetas con parámetros de verdad y sin la semántica de archivos de Make, que aquí estorba |

## 2. Lo que se pierde y se gana al traducir este Makefile

Con just se pierde el build incremental: `just build` concatena siempre,
mientras que `make build` no hace nada si `src/` no cambió; a cambio, `release`
recibe la versión como argumento real y `just --list` sustituye al `help` con
grep/awk. Task recupera el incremental con `sources:`/`generates:` (por
checksum, guardado en `.task/`) y añade `requires:`, pero cambia un Makefile
por YAML y una herramienta que hay que instalar. En los dos, interpolar
(`{{version}}`, `{{.VERSION}}`) pega texto en el comando igual que `$(VERSION)`
en Make: hace falta `quote()` en just o pasar la variable por `env:` en Task.
