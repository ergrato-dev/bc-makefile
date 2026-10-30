# El grafo completo de un objeto

```mermaid
graph LR
    SRC["src/main.c"] --> OBJ["build/main.o"]
    H1["include/calc.h"] -->|"-MMD (.d)"| OBJ
    H2["build/gen/version.h"] -->|"-MMD (.d)"| OBJ
    STAMP["build/compile-flags.txt"] -->|"stamp de flags"| OBJ
    DIR["build/"] -.->|"order-only"| OBJ
    H2 -.->|"order-only (primer build)"| OBJ
    GEN["tools/gen-version.sh + VERSION"] -->|"&: una ejecución"| H2
    GEN -->|"&: una ejecución"| VC["build/gen/version.c"]
```

Las flechas continuas son prerrequisitos normales: si su fecha es más nueva, `main.o` se recompila. Las discontinuas son order-only: solo tienen que existir. El header generado aparece dos veces a propósito: order-only para que exista en el primer build, y normal a través del `.d` a partir del segundo.
