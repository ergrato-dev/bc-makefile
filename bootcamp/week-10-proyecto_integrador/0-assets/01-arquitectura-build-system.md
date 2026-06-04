# Arquitectura de un Build System Multi-Lenguaje con Make

```mermaid
graph TD
    ROOT["Makefile raíz<br/>(orquestador)"]
    ROOT -->|"$(MAKE) -C backend"| BE["backend/Makefile"]
    ROOT -->|"$(MAKE) -C frontend"| FE["frontend/Makefile"]
    ROOT -->|"$(MAKE) -C infra"| INF["infra/Makefile"]

    BE -->|include| MK1["shared-mk/build.mk"]
    BE -->|include| MK2["shared-mk/test.mk"]
    BE -->|include| MK3["shared-mk/docker.mk"]

    FE -->|include| MK1
    FE -->|include| MK2
    FE -->|include| MK3

    INF -->|include| MK4["shared-mk/deploy.mk"]
    INF -->|include| MK5["shared-mk/ci.mk"]

    MK1 --> ART1["artefactos de build"]
    MK2 --> ART2["reportes de test"]
    MK3 --> ART3["Docker images"]
    MK4 --> ART4["entornos desplegados"]
    MK5 --> ART5["pipeline CI/CD"]

    style ROOT fill:#2d6a4f,color:#fff
    style MK1 fill:#1b4332,color:#fff
    style MK2 fill:#1b4332,color:#fff
    style MK3 fill:#1b4332,color:#fff
    style MK4 fill:#1b4332,color:#fff
    style MK5 fill:#1b4332,color:#fff
```

El Makefile raíz no sabe cómo compilar Python ni Node.js — solo orquesta. Cada servicio importa los módulos `.mk` compartidos y define sus variables locales. La librería `shared-mk/` es el único lugar donde se actualiza la lógica de build, test y deploy.
