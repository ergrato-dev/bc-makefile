# Flujo de resolución de stem en Make

```mermaid
flowchart TD
    A["Make necesita construir: build/calc.o"]
    B{"¿Existe regla\nexplícita para\nbuild/calc.o?"}
    C{"¿Coincide alguna\nstatic pattern rule?"}
    D{"¿Coincide alguna\nregla de patrón?"}
    E{"¿Existe regla\nimplícita interna?"}
    F["Error: No rule to make target"]

    R1["Usa regla explícita"]
    R2["Usa static pattern rule<br/>stem = calc"]
    R3["Usa regla de patrón<br/>build/%.o: src/%.c<br/>stem = calc"]
    R4["Usa regla implícita"]

    A --> B
    B -->|Sí| R1
    B -->|No| C
    C -->|Sí| R2
    C -->|No| D
    D -->|Sí| R3
    D -->|No| E
    E -->|Sí| R4
    E -->|No| F
```

Make busca reglas de mayor a menor especificidad. La regla explícita siempre gana. Las reglas implícitas internas (como `%.o: %.c` que Make conoce de fábrica) son la última opción antes del error. Definir tus propias reglas de patrón anula las implícitas.
