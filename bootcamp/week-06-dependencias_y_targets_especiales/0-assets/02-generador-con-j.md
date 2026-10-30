# Un generador, dos targets y `make -j`

```mermaid
sequenceDiagram
    participant M as make -j4
    participant G1 as generador (job 1)
    participant G2 as generador (job 2)
    Note over M: Regla "a.c a.h : def" (dos reglas independientes)
    M->>G1: construir a.c
    M->>G2: construir a.h
    G1-->>M: escribe a.c y a.h
    G2-->>M: escribe a.c y a.h otra vez, a la vez
    Note over M: Regla "a.c a.h &: def" (grouped target)
    M->>G1: construir a.c y a.h
    G1-->>M: escribe a.c y a.h
    Note over M: a.h ya está hecho: no lanza otro job
```

Con `:` cada target tiene "su" copia de la receta y en paralelo Make lanza las dos. Con `&:` Make sabe que una ejecución actualiza todo el grupo. En serie el bug casi nunca se ve, por eso llega a producción.
