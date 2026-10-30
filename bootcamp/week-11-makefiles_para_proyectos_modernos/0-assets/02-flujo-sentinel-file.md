# Flujo del Sentinel File (Archivo Testigo)

```mermaid
flowchart TD
    A[make install] --> B{¿Existe .venv/.installed?}
    B -->|No| C[python3 -m venv .venv]
    B -->|Sí| D{¿requirements.txt más nuevo\nque .venv/.installed?}
    C --> E[pip install -r requirements.txt]
    E --> F[touch .venv/.installed]
    F --> G[✓ Instalación completa]
    D -->|Sí — requirements cambió| E
    D -->|No — ya está al día| H[Nothing to be done for 'install']
    G --> I[make test puede ejecutarse]
    H --> I
```

El sentinel file (`.venv/.installed`) es un archivo vacío cuya única función es registrar cuándo se ejecutó `pip install` por última vez. Make compara su fecha de modificación con la de `requirements.txt`: si `requirements.txt` es más reciente, la instalación se repite; si no, Make la omite. Este patrón evita reinstalar dependencias en cada `make test`, lo que puede ahorrar minutos por ejecución en proyectos con muchas dependencias.
