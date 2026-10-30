# Reglas de serie: con y sin `-r`

```mermaid
flowchart LR
    T["make hola<br/>(el Makefile no menciona hola)"]
    T --> Q{"¿MAKEFLAGS += -r?"}
    Q -->|No| B["Regla de serie %: %.c<br/>cc hola.c -o hola"]
    B --> S["Se construye algo que nadie pidió,<br/>con flags que no elegiste"]
    Q -->|Sí| N["No rule to make target 'hola'"]
    N --> V["El error aparece donde está el bug"]
```

GNU Make trae unas noventa reglas de patrón de fábrica (`make -p -f /dev/null` las lista). `-r` las elimina junto con los sufijos antiguos (`.c.o:`); `-R` además elimina variables como `CC` y `CFLAGS`. Tus propias reglas de patrón siguen funcionando.
