# Cada línea de receta, un shell nuevo

```mermaid
sequenceDiagram
    participant M as make
    participant S1 as bash (línea 1)
    participant S2 as bash (línea 2)
    participant S3 as bash (línea 3)
    M->>S1: cd build
    S1-->>M: exit 0 (el cd muere aquí)
    M->>S2: tar -czf r.tar.gz *.txt
    S2-->>M: exit 2: está en el directorio del Makefile
    M->>S3: cd build && tar -czf r.tar.gz *.txt
    S3-->>M: exit 0: mismo shell, mismo directorio
```

Make expande `$(...)` y `$$` y lanza un proceso de shell por cada línea de receta. Directorio actual, variables de shell y `export` no sobreviven al final de la línea. Para compartir estado, encadena con `&&` o une líneas con `\`; `.ONESHELL` lo hace para todo el Makefile, con sus trampas.
