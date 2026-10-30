# Árbol de decisión: ¿qué función usar?

```mermaid
flowchart TD
    A{¿Qué necesito hacer?} --> B{¿Necesito encontrar\narchivos en disco?}
    B -->|Sí| C["$(wildcard pattern)\n\nEjemplo:\n$(wildcard src/*.c)"]
    B -->|No, tengo una lista| D{¿Quiero cambiar\nla forma de las palabras?}

    D -->|Sí, con comodín %| E["$(patsubst from,to,text)\n\nEjemplo:\n$(patsubst %.c,%.o,$(SRCS))"]
    D -->|Sí, sustitución literal| F["$(subst from,to,text)\n\nEjemplo:\n$(subst src,build,$(SRCS))"]
    D -->|Sí, agregar prefijo| G["$(addprefix pre,names)\n\nEjemplo:\n$(addprefix -I,$(DIRS))"]
    D -->|Sí, agregar sufijo| H["$(addsuffix suf,names)\n\nEjemplo:\n$(addsuffix /,$(DIRS))"]
    D -->|No| I{¿Quiero seleccionar\nun subconjunto?}

    I -->|Conservar coincidencias| J["$(filter pattern,text)\n\nEjemplo:\n$(filter %.c,$(FILES))"]
    I -->|Eliminar coincidencias| K["$(filter-out pattern,text)\n\nEjemplo:\n$(filter-out %.h,$(FILES))"]
    I -->|No| L{¿Quiero extraer\nparte de una ruta?}

    L -->|Directorio| M["$(dir names)\nsrc/main.c → src/"]
    L -->|Nombre de archivo| N["$(notdir names)\nsrc/main.c → main.c"]
    L -->|Sin extensión| O["$(basename names)\nsrc/main.c → src/main"]
    L -->|Solo extensión| P["$(suffix names)\nsrc/main.c → .c"]
    L -->|Ordenar/contar| Q["$(sort list)\n$(words list)"]

    style C fill:#c8e6c9
    style E fill:#fff9c4
    style F fill:#fff9c4
    style G fill:#fff9c4
    style H fill:#fff9c4
    style J fill:#bbdefb
    style K fill:#bbdefb
    style M fill:#f3e5f5
    style N fill:#f3e5f5
    style O fill:#f3e5f5
    style P fill:#f3e5f5
```

La pregunta clave es el punto de partida: **¿necesito archivos del disco o ya tengo una lista?** `$(wildcard)` es la única función que consulta el sistema de archivos — todas las demás operan sobre strings. Combina `wildcard` primero, luego `patsubst` para transformar, y `filter` para refinar.
