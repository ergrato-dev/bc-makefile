# Lógica de timestamps en Make

```mermaid
sequenceDiagram
    participant Dev as Desarrollador
    participant Make
    participant FS as Filesystem

    Dev->>Make: make reporte.txt
    Make->>FS: ¿existe reporte.txt?
    FS-->>Make: Sí (modificado: 10:00)
    Make->>FS: ¿existe datos.csv? (dependencia)
    FS-->>Make: Sí (modificado: 09:45)
    Make->>Make: 09:45 < 10:00 → target al día
    Make-->>Dev: 'reporte.txt' is up to date

    Note over Dev,FS: El desarrollador modifica datos.csv

    Dev->>Make: make reporte.txt
    Make->>FS: ¿existe reporte.txt?
    FS-->>Make: Sí (modificado: 10:00)
    Make->>FS: ¿existe datos.csv?
    FS-->>Make: Sí (modificado: 10:05)
    Make->>Make: 10:05 > 10:00 → dependencia más nueva
    Make->>FS: Ejecuta receta → regenera reporte.txt
    Make-->>Dev: reporte.txt generado.
```

Make **no rastrea contenido**, solo timestamps (`mtime`). Si necesitas forzar re-ejecución aunque nada cambió:

```bash
make -B reporte.txt   # --always-make: ignora timestamps
touch datos.csv       # actualiza mtime de la dependencia
```
