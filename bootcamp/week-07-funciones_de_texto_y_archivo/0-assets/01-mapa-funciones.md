# Mapa de Funciones de Texto y Archivo

```mermaid
graph TD
    A[Funciones de Make] --> B[Descubrimiento]
    A --> C[Transformación]
    A --> D[Filtrado]
    A --> E[Rutas]
    A --> F[Utilidades]

    B --> B1["$(wildcard pat)"]
    B1 --> B1a["Lista archivos\nen disco"]

    C --> C1["$(patsubst pat,rep,text)"]
    C --> C2["$(subst from,to,text)"]
    C --> C3["$(addprefix pre,names)"]
    C --> C4["$(addsuffix suf,names)"]
    C1 --> C1a["Con comodín %"]
    C2 --> C2a["Literal"]

    D --> D1["$(filter pat,text)"]
    D --> D2["$(filter-out pat,text)"]
    D1 --> D1a["Conserva coincidencias"]
    D2 --> D2a["Elimina coincidencias"]

    E --> E1["$(dir names)"]
    E --> E2["$(notdir names)"]
    E --> E3["$(basename names)"]
    E --> E4["$(suffix names)"]
    E1 --> E1a["src/ ← src/main.c"]
    E2 --> E2a["main.c ← src/main.c"]
    E3 --> E3a["src/main ← src/main.c"]
    E4 --> E4a[".c ← src/main.c"]

    F --> F1["$(sort list)"]
    F --> F2["$(words list)"]
    F1 --> F1a["Ordena + deduplica"]
    F2 --> F2a["Cuenta palabras"]
```

Las funciones se agrupan en cuatro categorías según su propósito: descubrimiento (en disco), transformación (cambio de forma), filtrado (selección de subconjuntos) y manipulación de rutas (extracción de partes del path). En la práctica siempre se combinan: `wildcard` descubre, `patsubst` transforma, `filter` refina.
