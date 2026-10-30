# ¿Make u otra herramienta?

```mermaid
flowchart TD
    A{"¿Generas archivos a partir<br/>de otros archivos?"} -->|Sí| B{"¿C/C++ multiplataforma<br/>o IDEs y MSVC?"}
    A -->|"No: solo tareas"| E{"¿Windows sin WSL<br/>o sin bash?"}
    B -->|Sí| CM["CMake + Ninja"]
    B -->|No| C{"¿Monorepo grande con<br/>varios lenguajes y CI lento?"}
    C -->|Sí| BZ["Bazel"]
    C -->|No| MK1["Make"]
    E -->|Sí| TK["Task"]
    E -->|No| F{"¿Recetas con argumentos<br/>posicionales a diario?"}
    F -->|Sí| JS["just"]
    F -->|No| MK2["Make<br/>(fachada de tareas)"]

    style MK1 fill:#d4edda,stroke:#28a745
    style MK2 fill:#d4edda,stroke:#28a745
```

La primera pregunta separa build systems de command runners: si no hay archivos que rehacer, el modelo de Make no aporta y just o Task pueden ser más cómodos. Si los hay, Make cubre la mayoría de casos; CMake y Bazel resuelven problemas de escala o de plataforma que tienen un coste de adopción real.
