# Make recursivo frente a no recursivo

```mermaid
graph LR
    subgraph rec["Recursivo: un grafo por directorio"]
        R["Makefile raíz"] -->|"$(MAKE) -C lib"| RL["lib/Makefile<br/>greet.o → libgreet.a"]
        R -->|"$(MAKE) -C app"| RA["app/Makefile<br/>main.o → hola"]
        RA -.->|"../lib/libgreet.a<br/>(no sabe reconstruirla)"| RL
    end
    subgraph norec["No recursivo: un solo grafo"]
        N["Makefile raíz<br/>include lib/module.mk app/module.mk"]
        N --> G["greet.o → libgreet.a"]
        N --> M["main.o"]
        G --> H["hola"]
        M --> H
    end
```

En el modelo recursivo, cada sub-make solo conoce su directorio: la flecha punteada es una dependencia que `app/Makefile` no puede satisfacer por sí mismo. En el no recursivo, los `module.mk` se incluyen en un único Make, así que todas las aristas (también las de headers entre directorios) están en el mismo grafo y `-j`, `-n` e incrementales funcionan sin sub-makes.
