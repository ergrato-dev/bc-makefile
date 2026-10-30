# Flujo del Pipeline: del commit a CI

```mermaid
sequenceDiagram
    participant DEV as Desarrollador
    participant GIT as git commit
    participant HOOK as hooks/pre-commit
    participant MAKE as Makefile raíz
    participant CI as Runner de CI

    DEV->>GIT: git commit
    GIT->>HOOK: core.hooksPath apunta a hooks/
    HOOK->>MAKE: exec make check
    MAKE->>MAKE: backend/lint · frontend/lint · infra/lint
    alt algún lint falla
        MAKE-->>DEV: ✗ commit abortado
    else todo OK
        MAKE-->>GIT: ✓ commit creado
    end
    Note over DEV,GIT: git commit --no-verify salta el hook

    GIT->>CI: push
    CI->>MAKE: make ci (el mismo comando)
    MAKE->>MAKE: por servicio: deps → lint → test → build
    alt un servicio falla
        MAKE-->>CI: exit ≠ 0, pipeline en rojo
    else todo OK
        CI->>MAKE: make push CI=true
    end
```

El hook es rápido (solo lint) y es una ayuda: `--no-verify` lo salta. El control real es `make ci` en el runner, que ejecuta exactamente lo mismo que en tu máquina. `push` solo se intenta en CI, y su guarda `CI=true` evita accidentes; el acceso lo controlan las credenciales del registry, que solo tiene el runner.
