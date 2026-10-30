# Decisión: ¿Make, just, Task, ninja, CMake o Bazel?

## 1. Escenarios

Elige UNA herramienta por escenario y justifícala en una línea con un criterio
de la tabla de decisión de `1-teoria/03-alternativas.md`.

| # | Escenario | Herramienta | Por qué |
|---|-----------|-------------|---------|
| 1 | Repo Python con uv: `test`, `lint` y `release` que llaman a uv; Linux y macOS | TODO | TODO |
| 2 | Librería C++ de 300 archivos que se compila en Linux, macOS y Windows (MSVC) y se abre en IDEs | TODO | TODO |
| 3 | Monorepo de 50 servicios en 4 lenguajes; CI de 40 min; se quiere caché remota compartida | TODO | TODO |
| 4 | Equipo con desarrolladores en Windows sin WSL; tareas de desarrollo (`docker compose up`, cargar datos) | TODO | TODO |
| 5 | Generar 2.000 PDFs desde Markdown e imágenes; rehacer solo los que cambian | TODO | TODO |
| 6 | Scripts de operación con argumentos (`deploy staging`, `logs api 100`) sin artefactos | TODO | TODO |

## 2. Lo que se pierde y se gana al traducir este Makefile

TODO: tres frases. Pista: ejecuta `make build` dos veces y piensa qué haría
`just build` la segunda vez; mira qué hace `sources:` en Task; y qué pasa con
`{{version}}` sin `quote()`.
