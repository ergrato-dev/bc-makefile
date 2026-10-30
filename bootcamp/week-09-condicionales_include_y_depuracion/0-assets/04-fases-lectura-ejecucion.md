# Fases de Make: lectura y ejecución

```mermaid
flowchart TD
    A[make target] --> B[Fase 1: lectura del Makefile]
    B --> C[Asignaciones := ?= +=]
    B --> D[ifeq / ifdef se evalúan]
    B --> E[include y -include]
    B --> F["$(info) $(warning) $(error) a nivel de archivo"]
    E --> G{¿Algún incluido desactualizado<br/>con regla?}
    G -->|sí| H[Rehacerlo y releer todo]
    H --> B
    G -->|no| I[Fase 2: ejecución]
    I --> J[Decidir qué targets rehacer<br/>--debug, --trace]
    J --> K["Expandir la receta: variables de target,<br/>$(info) y $(error) de receta"]
    K --> L[Ejecutar los comandos en el shell]
```

Casi todos los fallos de esta semana son de fase: un `ifeq` que no ve una
variable de target (se evaluó en la fase 1), un `$(error)` de archivo que rompe
`make help`, o un `$(info)` que se imprime con `make -n` porque expandir la
receta es parte de la fase 2 aunque no se ejecute nada.
