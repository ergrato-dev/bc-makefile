# Flujo del Sentinel File (Archivo Testigo)

```mermaid
flowchart TD
    A[make install] --> B{¿Existe .venv/.installed?}
    B -->|No| E
    B -->|Sí| D{¿pyproject.toml o uv.lock más nuevo\nque .venv/.installed?}
    E[uv sync --locked]
    E --> F[touch .venv/.installed]
    F --> G[✓ Instalación completa]
    D -->|Sí — dependencias cambiaron| E
    D -->|No — ya está al día| H[Nothing to be done for 'install']
    G --> I[make test puede ejecutarse]
    H --> I
```

El sentinel file (`.venv/.installed`) es un archivo vacío cuya única función es registrar cuándo se ejecutó `uv sync` por última vez. Make compara su fecha de modificación con la de `pyproject.toml` y `uv.lock`: si alguno es más reciente, la instalación se repite; si no, Make la omite. Este patrón evita reinstalar dependencias en cada `make test`, lo que puede ahorrar minutos por ejecución en proyectos con muchas dependencias.
