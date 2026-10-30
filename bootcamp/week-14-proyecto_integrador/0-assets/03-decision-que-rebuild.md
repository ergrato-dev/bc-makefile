# Decisión de Make: ¿Qué reconstruir?

```mermaid
flowchart TD
    START([make all]) --> CHECK_TARGET{¿Target existe<br/>como archivo?}
    CHECK_TARGET -->|No existe| BUILD[Ejecutar receta]
    CHECK_TARGET -->|Sí existe| CHECK_DEPS{¿Alguna dependencia<br/>más nueva que el target?}
    CHECK_DEPS -->|Sí| BUILD
    CHECK_DEPS -->|No| SKIP[Saltar — ya al día]
    BUILD --> DONE([Target actualizado])
    SKIP --> DONE

    CHECK_TARGET2{¿Target es .PHONY?} -->|Sí| BUILD
    CHECK_TARGET -->|Es .PHONY| CHECK_TARGET2

    style BUILD fill:#d62828,color:#fff
    style SKIP fill:#2d6a4f,color:#fff
    style DONE fill:#1b4332,color:#fff
```

Make compara timestamps: si el target es más nuevo que todas sus dependencias, no hay trabajo que hacer. Los targets `.PHONY` (como `clean`, `test`, `deploy`) nunca se consideran al día — siempre se ejecutan. Los archivos `.stamp` (archivos vacíos usados como marcadores de tiempo) permiten aplicar esta lógica a tareas que no producen un artefacto natural, como `pip install` o `npm install`.
