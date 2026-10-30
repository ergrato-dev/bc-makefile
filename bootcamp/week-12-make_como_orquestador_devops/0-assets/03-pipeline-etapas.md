# Etapas del Pipeline CI/CD Local

```mermaid
sequenceDiagram
    participant DEV as Desarrollador
    participant MAKE as Make
    participant LINT as lint
    participant TEST as test
    participant BUILD as build
    participant REPORT as report

    DEV->>MAKE: make ci
    MAKE->>LINT: ejecutar linters
    alt Lint falla
        LINT-->>MAKE: exit code ≠ 0
        MAKE-->>DEV: ❌ Pipeline abortado en lint
    else Lint OK
        LINT-->>MAKE: exit code 0
        MAKE->>TEST: ejecutar tests
    end
    alt Tests fallan
        TEST-->>MAKE: exit code ≠ 0
        MAKE-->>DEV: ❌ Pipeline abortado en test
    else Tests OK
        TEST-->>MAKE: exit code 0
        MAKE->>BUILD: construir artefactos
        BUILD-->>MAKE: artefactos generados
        MAKE->>REPORT: generar reporte
        REPORT-->>DEV: ✅ Pipeline OK — resumen de resultados
    end
```

Make ejecuta las etapas como dependencias en cadena. Si cualquier etapa retorna un código de salida distinto de cero, Make aborta inmediatamente — el mismo comportamiento que un pipeline CI remoto. El target `ci` agrega un target padre que encadena: `ci: lint test build report`.
