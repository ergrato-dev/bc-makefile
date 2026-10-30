# Parse-time vs run-time, y qué hace `make -n`

```mermaid
sequenceDiagram
    participant U as Usuario
    participant M as Make
    participant S as bash

    U->>M: make -n deploy
    Note over M: FASE 1: leer el Makefile
    M->>S: X := $(shell ...) se ejecuta
    M->>M: include .env (todo su contenido)
    Note over M: FASE 2: recetas de deploy
    M->>M: expande la receta: corre cada $(shell) que tenga
    M-->>U: imprime la línea (no la ejecuta)
    M->>S: pero SÍ ejecuta las líneas con + o $(MAKE)
```

La fase 1 ocurre siempre, también con `make help` y con `make -n`. En la fase 2, `-n` imprime las recetas en lugar de ejecutarlas, pero para imprimirlas tiene que expandirlas, y las líneas con `+` o `$(MAKE)` se ejecutan de todos modos. Lo que es shell dentro de la receta (`$$(cmd)`) es lo único que `-n` no toca.
