# Flujo del Pipeline CI Completo

```mermaid
sequenceDiagram
    participant DEV as Developer
    participant GIT as git commit
    participant HOOK as pre-commit hook
    participant MAKE as make ci
    participant LINT as make lint
    participant TEST as make test
    participant BUILD as make build-image
    participant PUSH as make push

    DEV->>GIT: git commit -m "feat: nueva API"
    GIT->>HOOK: ejecuta .git/hooks/pre-commit
    HOOK->>MAKE: make check (lint + unit tests)
    MAKE->>LINT: flake8 / eslint
    alt lint falla
        LINT-->>DEV: ✗ Error de estilo — commit abortado
    end
    LINT->>TEST: pytest / jest
    alt test falla
        TEST-->>DEV: ✗ Tests fallidos — commit abortado
    end
    TEST-->>GIT: ✓ Checks OK — commit creado
    GIT-->>DEV: commit aceptado

    DEV->>MAKE: make ci (pipeline completo)
    MAKE->>LINT: lint todos los servicios
    MAKE->>TEST: test todos los servicios
    MAKE->>BUILD: docker build --tag imagen:sha
    BUILD->>PUSH: docker push (solo en CI=true)
    PUSH-->>DEV: ✓ Pipeline completo
```

El pipeline local replica lo que ejecutaría CI en la nube. Si `make ci` pasa localmente, tiene alta probabilidad de pasar en GitHub Actions o GitLab CI. Los git hooks garantizan que los checks básicos corren antes de cada commit, sin depender de la plataforma CI.
