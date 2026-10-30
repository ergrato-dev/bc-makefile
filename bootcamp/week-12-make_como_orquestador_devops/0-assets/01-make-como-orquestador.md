# Make como orquestador DevOps

```mermaid
graph TD
    DEV[Desarrollador] -->|git commit| HOOK[pre-commit: rechaza .env*]
    DEV -.->|git commit --no-verify| SKIP[Hooks saltados]
    HOOK -->|OK| HOOK2[pre-push: make lint]
    HOOK -->|.env en staging| FAIL1[❌ Commit bloqueado]
    HOOK2 -->|falla| FAIL2[❌ Push bloqueado]
    HOOK2 -->|OK| PUSH[git push]
    SKIP --> PUSH
    PUSH --> GHA[GitHub Actions]
    GHA -->|único paso: make ci| CI[make ci]
    LOCAL[Tu máquina] -->|make ci| CI
    CI --> ENV[env-check] --> LINT[lint] --> TEST[test] --> BUILD[build] --> REPORT[report]

    style FAIL1 fill:#ff6b6b,color:#fff
    style FAIL2 fill:#ff6b6b,color:#fff
    style SKIP fill:#ffd43b
    style GHA fill:#339af0,color:#fff
```

Los hooks detectan errores pronto en la máquina del desarrollador, pero `--no-verify` los salta: son una ayuda. El control que no se puede saltar es el workflow de CI, y ese workflow solo ejecuta `make ci`, el mismo comando que corres en local.
