# Regla de patrón vs static pattern rule

```mermaid
graph LR
    subgraph "Regla de patrón genérica"
        GP["%.o: %.c<br/>$(CC) -c $&lt; -o $@"]
        GA["Aplica a CUALQUIER .o<br/>que tenga .c correspondiente"]
        GP --> GA
    end

    subgraph "Static pattern rule"
        SP["$(LIB_OBJS): build/%.o: src/%.c<br/>$(CC) -c $&lt; -o $@"]
        SA["Solo aplica a los targets<br/>listados en $(LIB_OBJS)"]
        SP --> SA
    end

    subgraph "Diferencia clave"
        D1["Patrón genérico: Make decide\nqué targets califican"]
        D2["Static pattern: tú decides\nexactamente qué targets"]
    end
```

La static pattern rule `$(TARGETS): patrón-target: patrón-prerreq` tiene tres partes: lista de targets, patrón del target, patrón del prerrequisito. Es más predecible que el patrón genérico porque no aplica a targets inesperados que accidentalmente coincidan con el patrón.
