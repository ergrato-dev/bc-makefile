# Precedencia de variables: quién gana cuando hay conflicto

```mermaid
graph TD
    A["override VAR := x<br/>(declarado en Makefile)"] --> Z["Valor final de VAR"]
    B["make VAR=x<br/>(argumento de línea de comandos)"] --> Z
    C["export VAR=x<br/>(variable de entorno del shell)"] --> Z
    D["VAR = x  o  VAR := x<br/>(asignación normal en Makefile)"] --> Z
    E["VAR ?= x<br/>(solo aplica si nadie más la definió)"] --> Z

    style A fill:#d4edda,stroke:#28a745
    style B fill:#cce5ff,stroke:#004085
    style C fill:#e2e3e5,stroke:#6c757d
    style D fill:#fff3cd,stroke:#856404
    style E fill:#f8d7da,stroke:#842029
```

**Flujo práctico:**

- `?=` → valor por defecto que cualquiera puede sobreescribir
- `= / :=` → valor interno del Makefile (pierde ante CLI y entorno)
- CLI `make VAR=x` → sobreescribe todo excepto `override`
- `override` → el Makefile impone su valor sin importar qué pase desde afuera (raro, úsalo con cuidado)

El patrón más común es: `?=` para defaults + CLI para configurar = Makefile flexible sin editar.
