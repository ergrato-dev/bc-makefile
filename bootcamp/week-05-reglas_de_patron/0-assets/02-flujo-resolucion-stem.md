# Cómo elige Make la regla de un target

```mermaid
flowchart TD
    A["Make necesita construir: build/calc.o"]
    B{"¿Alguna regla explícita<br/>(o static pattern rule)<br/>le da receta?"}
    R1["Usa esa receta<br/>(si hay dos: la última, con aviso)"]
    C["Reúne reglas de patrón que casan con el nombre:<br/>primero las tuyas, luego las de serie"]
    D{"¿Alguna tiene sus prerrequisitos<br/>existentes o construibles?"}
    E["Elige la de stem más corto<br/>(empate: la primera del Makefile)"]
    F["Error: No rule to make target"]

    A --> B
    B -->|Sí| R1
    B -->|"No (o solo prerrequisitos)"| C
    C --> D
    D -->|Sí| E
    D -->|No| F
```

Una regla explícita sin receta (`main.o: config.h`) no detiene la búsqueda: solo añade prerrequisitos a la regla de patrón que se elija. Las reglas de serie (`%.o: %.c`, `%: %.c`, `%: %.sh`…) entran en la misma búsqueda, por detrás de las tuyas; con `MAKEFLAGS += -r` desaparecen.
