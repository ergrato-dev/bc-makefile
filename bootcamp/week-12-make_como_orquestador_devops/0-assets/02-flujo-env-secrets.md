# Flujo de variables de entorno y secretos

```mermaid
flowchart TD
    A[".env.example<br/>versionado, sin valores"] -->|cp| B[".env<br/>ignorado por git"]
    B -->|"-include .env<br/>(se parsea como Makefile)"| C[Variables de Make]
    I["GitHub Actions<br/>env: + secrets"] -->|variables de entorno| C
    C --> D{"guard-% en Make<br/>¿existe la variable?"}
    D -->|No| E["$(error) con el nombre<br/>de la variable"]
    D -->|Sí| F["export DB_URL SECRET_KEY<br/>(solo la lista)"]
    F --> G["Recetas leen $$SECRET_KEY<br/>como variable de entorno"]

    style E fill:#ff6b6b,color:#fff
    style F fill:#51cf66,color:#fff
    style B fill:#ff8c00,color:#fff
```

En local los valores llegan de `.env`; en CI, del entorno que pone el runner, y `-include` hace que el mismo Makefile funcione en ambos casos. La validación ocurre dentro de Make (`$(if)` + `$(error)`), y las recetas leen el secreto como variable de entorno: nunca se pega en el texto de un comando.
