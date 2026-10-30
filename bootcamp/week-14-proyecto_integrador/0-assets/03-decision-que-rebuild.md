# Decisión de Make: ¿Qué reconstruir?

```mermaid
flowchart TD
    START([make target]) --> PHONY{¿Está en .PHONY?}
    PHONY -->|Sí| BUILD[Ejecutar receta]
    PHONY -->|No| EXISTS{¿Existe el archivo?}
    EXISTS -->|No| BUILD
    EXISTS -->|Sí| NEWER{¿Algún prerrequisito normal<br/>es más nuevo?}
    NEWER -->|Sí| BUILD
    NEWER -->|No| SKIP[Al día: no hace nada]
    OO["Prerrequisito order-only<br/>build/obj/"] -.->|solo tiene que existir| EXISTS
    DEP["build/obj/main.d<br/>(-MMD -MP)"] -.->|añade los headers| NEWER

    style BUILD fill:#d62828,color:#fff
    style SKIP fill:#2d6a4f,color:#fff
```

Make compara fechas: si el archivo existe y ningún prerrequisito normal es más nuevo, no hay trabajo. Los targets `.PHONY` siempre se ejecutan, por eso `deps` es un phony sin receta que depende de un stamp con fecha (`.stamps/deps: uv.lock`). Los directorios van como order-only porque su fecha cambia cada vez que se escribe dentro, y los `.d` de `-MMD -MP` añaden los headers a la comparación.
