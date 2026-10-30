# Flujo de compilación C con variables automáticas

```mermaid
graph TD
    subgraph "src/"
        MC["main.c"]
        GC["greet.c"]
        CC["calc.c"]
    end

    subgraph "build/"
        MO["main.o"]
        GO["greet.o"]
        CO["calc.o"]
        APP["app"]
    end

    MC -->|"%.o: %.c\ngcc -c $< -o $@\nmkdir -p $(@D)"| MO
    GC -->|"%.o: %.c\ngcc -c $< -o $@\nmkdir -p $(@D)"| GO
    CC -->|"%.o: %.c\ngcc -c $< -o $@\nmkdir -p $(@D)"| CO

    MO & GO & CO -->|"app: $(OBJS)\ngcc $^ -o $@"| APP

    style APP fill:#d4edda,stroke:#28a745
    style MO fill:#e8f4f8,stroke:#17a2b8
    style GO fill:#e8f4f8,stroke:#17a2b8
    style CO fill:#e8f4f8,stroke:#17a2b8
```

Una sola regla de patrón `$(BUILD)/%.o: $(SRC)/%.c` compila los tres archivos. Make aplica la misma regla tres veces, sustituyendo el stem (`main`, `greet`, `calc`) en cada invocación. `$(@D)` = `build` en los tres casos; `mkdir -p $(@D)` crea el directorio una sola vez y no falla si ya existe.
