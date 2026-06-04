# Include y Makefiles Modulares

```mermaid
graph TD
    A[Makefile principal] -->|include mk/build.mk| B[mk/build.mk]
    A -->|include mk/test.mk| C[mk/test.mk]
    A -->|-include mk/local.mk| D[mk/local.mk<br/>opcional]
    B --> E[targets: build, compile, link]
    C --> F[targets: test, coverage, bench]
    D --> G[targets: overrides locales<br/>no en git]
    E --> H[make all]
    F --> H
    G --> H
```

`include` detiene Make con error si el archivo no existe. `-include` (con guion) lo ignora silenciosamente — ideal para archivos opcionales como configuración local o `.env`. Un módulo `.mk` es un Makefile parcial: define variables y targets pero no tiene `.DEFAULT_GOAL`. El Makefile principal orquesta qué módulos carga y en qué orden, controlando qué target es el predeterminado.
