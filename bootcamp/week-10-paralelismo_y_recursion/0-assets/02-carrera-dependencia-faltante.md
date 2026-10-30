# Una carrera es una dependencia que falta

```mermaid
flowchart LR
    subgraph serie["make (en serie)"]
        direction TB
        S1["config.txt"] --> S2["page.txt<br/>lee config.txt"]
        S2 --> S3["✅ funciona por el orden de la lista"]
    end
    subgraph paralelo["make -j2"]
        direction TB
        P1["config.txt<br/>(tarda 1 s)"]
        P2["page.txt<br/>lee config.txt"]
        P2 --> P3["❌ No such file or directory"]
    end
    subgraph arreglo["page.txt: config.txt"]
        direction TB
        F1["config.txt"] -->|"arista declarada"| F2["page.txt"]
        F2 --> F3["✅ correcto con cualquier -j"]
    end
    serie ~~~ paralelo ~~~ arreglo
```

En serie, Make sigue el orden en que escribiste los prerrequisitos, y eso tapa la dependencia que falta. Con `-j` solo respeta las aristas del grafo, así que `page.txt` arranca a la vez que `config.txt`. El arreglo nunca es quitar `-j` ni añadir `.NOTPARALLEL`: es declarar la arista que faltaba.
