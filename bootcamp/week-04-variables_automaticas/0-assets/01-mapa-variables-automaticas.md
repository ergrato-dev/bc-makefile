# Variables automáticas: de dónde viene cada una

```mermaid
graph TD
    RULE["app: main.o utils.o math.o\n    gcc $^ -o $@"]

    RULE --> AT["$@\n→ app\n(nombre del target)"]
    RULE --> FP["$<\n→ main.o\n(primer prerrequisito)"]
    RULE --> AP["$^\n→ main.o utils.o math.o\n(todos, deduplicado)"]
    RULE --> NP["$?\n→ solo los prerreqs\nmás nuevos que app"]

    style AT fill:#d4edda,stroke:#28a745
    style FP fill:#cce5ff,stroke:#004085
    style AP fill:#fff3cd,stroke:#856404
    style NP fill:#f8d7da,stroke:#721c24
```

Make inyecta estas variables en la receta en el momento de ejecución. `$@` y `$<` son las más usadas en compilación: `$<` es el único archivo fuente para `gcc -c`, y `$@` es el archivo objeto de salida. `$^` va al linker porque necesita todos los `.o`. `$?` solo tiene sentido en targets reales (no `.PHONY`): lista los prerrequisitos modificados desde el último build.
