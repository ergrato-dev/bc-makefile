# Condicionales en Make

```mermaid
flowchart TD
    A[Make evalúa variable] --> B{¿Tipo de condicional?}
    B --> C[ifeq / ifneq]
    B --> D[ifdef / ifndef]
    C --> E{¿Valores son iguales?}
    D --> F{¿Variable definida?}
    E -->|sí| G[Rama 'then']
    E -->|no| H[Rama 'else']
    F -->|sí| I[Rama 'then']
    F -->|no| J[Rama 'else']
    G --> K[Expansión de reglas]
    H --> K
    I --> K
    J --> K
    K --> L[Make ejecuta receta]
```

Los condicionales en Make se evalúan **en tiempo de lectura** (parsing), no en tiempo de ejecución. Esto significa que `ifeq` no puede depender de la salida de un comando en la receta — para eso se usa `$(shell ...)` antes del condicional. La elección entre `ifeq`/`ifneq` (compara valores) y `ifdef`/`ifndef` (compara existencia) determina qué tipo de condición puedes expresar.
