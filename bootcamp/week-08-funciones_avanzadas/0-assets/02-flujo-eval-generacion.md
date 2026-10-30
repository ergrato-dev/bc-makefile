# Flujo de Generación Dinámica con eval + call + foreach

```mermaid
sequenceDiagram
    participant M as Makefile (parse)
    participant F as $(foreach)
    participant C as $(call)
    participant E as $(eval)
    participant R as Reglas internas de Make

    M->>F: $(foreach svc, api worker, ...)
    loop para cada svc
        F->>C: $(call SERVICE_RULE, api)
        Note over C: Expande plantilla<br/>$1 → api<br/>$$< → $<<br/>$$@ → $@
        C-->>E: texto de la regla para api
        E->>R: Parsea como sintaxis Make
        Note over R: Nueva regla disponible:<br/>api: services/api/main.c<br/>    gcc $< -o $@
    end
    R-->>M: Targets api, worker ya existen
```

El ciclo `foreach → call → eval` es el núcleo del meta-Makefile. Define la plantilla una sola vez y la instancia N veces. El doble `$$` dentro de la plantilla es esencial: `$$<` sobrevive a la expansión de `call` como `$<`, que luego actúa como variable automática al ejecutar la receta.
