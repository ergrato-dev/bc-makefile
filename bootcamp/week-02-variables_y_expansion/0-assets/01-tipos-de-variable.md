# Tipos de variable en Make: los operadores de asignación

```mermaid
graph TD
    A["Variable en Makefile"] --> B{Operador de asignación}
    B -->|"="| C["Recursiva / lazy"]
    B -->|":="| D["Simple / inmediata"]
    B -->|"?="| E["Condicional"]
    B -->|"+="| F["Acumulación / append"]
    B -->|"!="| G["Asignación con shell"]

    C --> C1["Se expande cada vez\nque se usa la variable"]
    D --> D1["Se expande una sola vez\nal momento de asignar"]
    E --> E1["Solo asigna si la variable\nno está definida aún"]
    F --> F1["Agrega al valor existente\nseparado por un espacio"]
    G --> G1["Ejecuta el comando al asignar;\nguarda la salida como recursiva"]

    style C fill:#fff3cd,stroke:#856404
    style D fill:#d4edda,stroke:#28a745
    style E fill:#cce5ff,stroke:#004085
    style F fill:#e2e3e5,stroke:#383d41
```

El operador `:=` es el más predecible y el recomendado como default: evalúa una vez y el resultado no cambia. El operador `=` es poderoso pero riesgoso: puede causar recursión infinita si una variable se referencia a sí misma. Usa `?=` para defaults que el usuario pueda sobreescribir desde CLI sin editar el archivo. `$(flavor VAR)` confirma el tipo resultante: `simple` solo para `:=`; `recursive` para el resto.
