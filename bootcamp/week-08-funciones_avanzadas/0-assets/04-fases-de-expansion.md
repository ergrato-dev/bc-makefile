# Cuándo se expande cada función

```mermaid
flowchart LR
    subgraph L["Fase 1: lectura del Makefile (siempre, incluso con make -n o make help)"]
        A["VAR := $(shell ...)<br/>se ejecuta una vez"]
        B["$(eval $(call PLANTILLA,x))<br/>crea reglas nuevas"]
        C["VAR = $(shell ...)<br/>todavía no se ejecuta"]
    end
    subgraph R["Fase 2: ejecución del target pedido"]
        D["Make expande la receta entera<br/>$(file ...), $(info ...), $(VAR)"]
        E["El shell ejecuta las líneas<br/>(se omite con make -n)"]
    end
    A --> D
    B --> D
    C -->|"$(shell) en cada referencia"| D
    D --> E
```

`:=` y `$(eval)` actúan en la lectura, pidas el target que pidas: un `$(shell)` lento o con una variable de fuera cuesta y se ejecuta incluso en `make -n help`. `$(file)` e `$(info)` actúan al expandir la receta, antes de su primera línea y también con `-n`; solo el shell de la receta queda protegido por `-n`.
