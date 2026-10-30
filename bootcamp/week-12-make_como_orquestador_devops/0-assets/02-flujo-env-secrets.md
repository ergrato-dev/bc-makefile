# Flujo de Variables de Entorno y Secretos

```mermaid
flowchart TD
    A[.env.example\ncommiteado al repo] -->|copia manual| B[.env\nNO commiteado]
    B -->|-include .env| C[Make carga variables]
    C --> D{¿Todas las vars\nrequeridas existen?}
    D -->|No| E[make env-check\nmuestra error]
    D -->|Sí| F[Pipeline continúa]
    F --> G[Recetas reciben vars\nvía export]
    G --> H[Scripts/herramientas\nleen vars del entorno]

    I[CI/CD Remoto] -->|secrets del sistema| J[Vars de entorno\npor el CI runner]
    J --> K[make ci ejecuta\nsin .env local]

    style E fill:#ff6b6b,color:#fff
    style F fill:#51cf66,color:#fff
    style A fill:#ffd43b
    style B fill:#ff8c00,color:#fff
```

El patrón fundamental: `.env.example` va al repositorio como plantilla, `.env` contiene los valores reales y se ignora en `.gitignore`. Make carga el `.env` local con `-include` (no falla si no existe) y expone las variables al shell con `export`. En CI, las variables llegan directamente del runner sin necesitar `.env`.
