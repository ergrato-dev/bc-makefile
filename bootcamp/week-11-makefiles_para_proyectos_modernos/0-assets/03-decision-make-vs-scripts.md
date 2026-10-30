# ¿Cuándo usar Make vs scripts vs herramientas nativas?

```mermaid
flowchart TD
    Q1{¿La operación involucra\nmúltiples herramientas?} -->|Sí| MAKE[Usar Make]
    Q1 -->|No| Q2{¿Necesita rastrear\ndependencias entre archivos?}
    Q2 -->|Sí| MAKE
    Q2 -->|No| Q3{¿El equipo ya usa\nun task runner propio?}
    Q3 -->|npm scripts / tox / invoke| NATIVE[Herramienta nativa del stack]
    Q3 -->|No hay convención| Q4{¿Lógica compleja\ncon condicionales?}
    Q4 -->|Sí, muchas ramas| SHELL[Script shell o Python]
    Q4 -->|No| MAKE

    MAKE --> E1["✓ make test<br/>✓ make build<br/>✓ make deploy"]
    NATIVE --> E2["✓ npm test<br/>✓ tox<br/>✓ invoke build"]
    SHELL --> E3["✓ ./scripts/deploy.sh<br/>llamado desde Make"]

    style MAKE fill:#27ae60,stroke:#1e8449,color:#fff
    style NATIVE fill:#2980b9,stroke:#1f618d,color:#fff
    style SHELL fill:#8e44ad,stroke:#6c3483,color:#fff
```

La regla práctica: usa Make como orquestador principal y llama herramientas nativas desde sus recetas. Un Makefile puede llamar `npm test` o `pytest` directamente — no tiene que reemplazarlos, solo tiene que envolverlos en una interfaz consistente. Los scripts shell complejos deben vivir en `scripts/` y ser llamados desde Make, no embebidos en recetas largas.
