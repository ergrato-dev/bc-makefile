# Flujo: wildcard → patsubst → compilación

```mermaid
flowchart TD
    FS[("Disco\nsrc/main.c\nsrc/utils.c\nsrc/calc.c")]

    FS -->|"$(wildcard src/*.c)"| SRCS

    subgraph VAR ["Variables Make"]
        SRCS["SRCS =\nsrc/main.c\nsrc/utils.c\nsrc/calc.c"]
        OBJS["OBJS =\nbuild/main.o\nbuild/utils.o\nbuild/calc.o"]
    end

    SRCS -->|"$(patsubst src/%.c,build/%.o,...)"| OBJS

    OBJS --> RULE

    subgraph BUILD ["Compilación"]
        RULE["Pattern rule\nbuild/%.o: src/%.c"]
        O1["build/main.o"]
        O2["build/utils.o"]
        O3["build/calc.o"]
        LINK["Enlazado\nbuild/programa"]
    end

    RULE --> O1
    RULE --> O2
    RULE --> O3
    O1 & O2 & O3 --> LINK

    style FS fill:#e8f5e9
    style SRCS fill:#fff3e0
    style OBJS fill:#fff3e0
    style LINK fill:#e3f2fd
```

El flujo tiene tres fases: `$(wildcard)` consulta el disco y genera una lista de rutas reales; `$(patsubst)` transforma esa lista de `.c` a `.o` sin tocar el disco; el pattern rule usa la lista de objetos para disparar la compilación de cada par `src/*.c → build/*.o`. Agregar un nuevo `.c` en `src/` hace que la cadena completa se actualice sola en la siguiente ejecución de `make`.
