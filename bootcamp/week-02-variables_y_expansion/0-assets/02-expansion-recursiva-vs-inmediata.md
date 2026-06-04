# Expansión recursiva (=) vs. inmediata (:=)

```mermaid
sequenceDiagram
    participant F as Makefile
    participant M as Make engine

    Note over F,M: FASE 1 — Carga del Makefile

    F->>M: MSG = Hola $(NOMBRE)
    M-->>M: Almacena literal "Hola $(NOMBRE)"

    F->>M: NOMBRE := Mundo
    M-->>M: Expande ahora → NOMBRE = "Mundo"

    Note over F,M: FASE 2 — Ejecución de receta (@echo $(MSG))

    M-->>M: Necesita expandir $(MSG)
    M-->>M: Expande "Hola $(NOMBRE)" → lee NOMBRE = "Mundo"
    M-->>M: Resultado: "Hola Mundo"
```

Con `=`, Make almacena la expresión sin evaluarla y la expande en el momento de uso. Esto permite que `MSG` referencie `NOMBRE` aunque `NOMBRE` se defina después en el archivo. Con `:=`, `MSG` capturaría el valor de `NOMBRE` al momento de definir `MSG` — si `NOMBRE` no está definido aún, `MSG` quedaría vacío.
