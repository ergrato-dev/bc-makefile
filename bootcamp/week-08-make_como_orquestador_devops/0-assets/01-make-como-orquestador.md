# Make como Orquestador DevOps

```mermaid
graph TD
    DEV[Desarrollador] -->|git commit| HOOK[pre-commit hook]
    HOOK -->|make lint| LINT{¿Lint OK?}
    LINT -->|No| FAIL1[❌ Commit bloqueado]
    LINT -->|Sí| HOOK2[pre-push hook]
    HOOK2 -->|make test| TEST{¿Tests OK?}
    TEST -->|No| FAIL2[❌ Push bloqueado]
    TEST -->|Sí| PUSH[git push]
    PUSH --> CI[CI Remoto]
    CI -->|make ci| PIPELINE[Pipeline completo]
    PIPELINE --> LINT2[lint]
    PIPELINE --> TEST2[test]
    PIPELINE --> BUILD[build]
    PIPELINE --> REPORT[report]

    style FAIL1 fill:#ff6b6b,color:#fff
    style FAIL2 fill:#ff6b6b,color:#fff
    style PUSH fill:#51cf66,color:#fff
    style CI fill:#339af0,color:#fff
```

Make actúa como dispatcher: el desarrollador ejecuta un solo comando y Make orquesta lint, tests, build y reporte en el orden correcto. Los git hooks extienden este modelo al nivel del repositorio, bloqueando código que no pasa el pipeline antes de que llegue al servidor remoto.
