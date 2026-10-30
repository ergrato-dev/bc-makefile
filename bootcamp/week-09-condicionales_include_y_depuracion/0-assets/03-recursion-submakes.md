# Recursión y Submakes

```mermaid
sequenceDiagram
    participant R as Make raíz
    participant A as make -C modulo-a
    participant B as make -C modulo-b
    participant C as make -C modulo-c

    R->>A: $(MAKE) -C modulo-a build
    A-->>R: exit 0
    R->>B: $(MAKE) -C modulo-b build
    B-->>R: exit 0
    R->>C: $(MAKE) -C modulo-c build
    C-->>R: exit 0
    R-->>R: all completado
```

`$(MAKE) -C directorio target` cambia al directorio y ejecuta el `Makefile` de allí. Usar `$(MAKE)` (no `make` literal) garantiza que se usa el mismo binario y flags que el proceso padre. Las variables definidas en el Makefile del padre **no** se heredan solas: llegan las de la línea de comandos (vía `MAKEFLAGS`), las del entorno, las exportadas por nombre (`export VAR`) y las pasadas como argumento (`ENV=$(ENV)`). Esto es intencional: cada submake debe ser autónomo y ejecutable de forma independiente.
