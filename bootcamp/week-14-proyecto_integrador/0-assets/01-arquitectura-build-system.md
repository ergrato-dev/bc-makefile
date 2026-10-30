# Arquitectura de un Build System Multi-Lenguaje con Make

```mermaid
graph TD
    ROOT["Makefile raíz<br/>modo estricto · SERVICE_TARGETS"]
    ROOT -->|"backend/ci<br/>$(MAKE) -C backend ci"| BE["backend/Makefile<br/>solo variables + include"]
    ROOT -->|"frontend/ci"| FE["frontend/Makefile"]
    ROOT -->|"infra/ci"| INF["infra/Makefile"]

    BE --> PY["python.mk<br/>stamp: uv sync --locked"]
    FE --> NODE["node.mk<br/>stamp: pnpm install --frozen-lockfile"]
    INF --> C["c.mk<br/>-MMD -MP · obj/ order-only"]

    BE & FE & INF --> COMMON["build.mk · test.mk · ci.mk · deploy.mk<br/>(docker.mk solo backend y frontend)"]

    style ROOT fill:#2d6a4f,color:#fff
    style PY fill:#1b4332,color:#fff
    style NODE fill:#1b4332,color:#fff
    style C fill:#1b4332,color:#fff
    style COMMON fill:#1b4332,color:#fff
```

El Makefile raíz no sabe compilar Python, Node.js ni C: solo convierte cada `servicio/meta` en un nodo del grafo y delega con `$(MAKE)`, así que `-j3` comparte el jobserver y un fallo llega hasta arriba. Cada servicio importa `build.mk` primero (define `BUILD_DIR` y `STAMPS`), luego su módulo de lenguaje y después los genéricos. Las metas `lint` y `test` son comunes; lo que cambia por stack es `LINT_CMD`, `TEST_CMD` y el stamp de dependencias.
