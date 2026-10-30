# Mapa de Funciones Avanzadas de Make

```mermaid
graph TD
    A[Funciones Avanzadas de Make] --> B["$(foreach)"]
    A --> C["$(call)"]
    A --> D["$(eval)"]
    A --> E["$(shell)"]

    B --> B1["Itera una lista<br/>y expande texto"]
    B --> B2["Resultado: string<br/>concatenado"]

    C --> C1["Llama función<br/>definida por usuario"]
    C --> C2["Args: $1 $2 $3..."]

    D --> D1["Parsea texto como<br/>sintaxis Makefile"]
    D --> D2["Crea reglas y vars<br/>en tiempo de carga"]

    E --> E1["Ejecuta comando<br/>en el shell"]
    E --> E2["Captura stdout<br/>como string"]

    B -->|"genera texto"| D
    C -->|"produce texto"| D
    E -->|"datos del sistema"| B
```

`$(foreach)` genera texto iterando una lista. `$(call)` invoca plantillas con argumentos nombrados. `$(eval)` convierte ese texto en reglas Make reales. `$(shell)` trae datos del sistema operativo al Makefile. Las cuatro juntas permiten construir Makefiles que se configuran solos.
