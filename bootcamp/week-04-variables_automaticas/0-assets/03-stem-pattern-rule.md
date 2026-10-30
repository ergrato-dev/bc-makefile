# El stem `$*` en reglas de patrón

```mermaid
flowchart LR
    PAT["Regla de patrón\n%.o: %.c\n    gcc -c $&lt; -o $@"]

    PAT -->|"target: main.o"| A["$* = main\n$@ = main.o\n$< = main.c"]
    PAT -->|"target: utils.o"| B["$* = utils\n$@ = utils.o\n$< = utils.c"]
    PAT -->|"target: calc.o"| C["$* = calc\n$@ = calc.o\n$< = calc.c"]

    style A fill:#d4edda,stroke:#28a745
    style B fill:#cce5ff,stroke:#004085
    style C fill:#fff3cd,stroke:#856404
```

El `%` en una regla de patrón actúa como wildcard. El texto que coincide con `%` se llama **stem** y se expone en `$*`. En el ejemplo, el stem es el nombre del módulo sin extensión. `$*` es útil cuando necesitas derivar otras rutas a partir del stem: `$(BUILD)/$*.d` para archivos de dependencias, o `$(DOCS)/$*.html` para documentación generada. Fuera de una regla de patrón, `$*` siempre expande a cadena vacía.
