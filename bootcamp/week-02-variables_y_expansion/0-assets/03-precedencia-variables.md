# Precedencia de variables: quién gana cuando hay conflicto

```mermaid
graph TD
    A["1. override VAR := x<br/>origin: override"] -->|"gana a"| B
    B["2. make VAR=x<br/>origin: command line"] -->|"gana a"| C
    C["3. VAR = x · VAR := x · VAR != cmd<br/>origin: file"] -->|"gana a"| D
    D["4. VAR=x make (entorno)<br/>origin: environment"] -->|"gana a"| E
    E["5. VAR ?= x<br/>solo si nadie la definió antes"]

    style A fill:#d4edda,stroke:#28a745
    style B fill:#cce5ff,stroke:#004085
    style C fill:#fff3cd,stroke:#856404
    style D fill:#e2e3e5,stroke:#6c757d
    style E fill:#f8d7da,stroke:#842029
```

Una asignación normal del Makefile (3) gana a la variable de entorno (4): por eso los valores configurables se definen con `?=`, que solo actúa si ni la CLI ni el entorno trajeron valor. `$(origin VAR)` te dice en qué caja cayó el valor que estás viendo, y `make -e` intercambia las cajas 3 y 4 (no lo uses como arreglo).
