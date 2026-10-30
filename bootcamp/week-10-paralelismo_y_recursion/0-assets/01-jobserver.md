# El jobserver: un `-j` para todo el árbol de sub-makes

```mermaid
sequenceDiagram
    participant U as make -j4 (raíz)
    participant JS as Jobserver (4 fichas)
    participant A as $(MAKE) -C core
    participant B as $(MAKE) -C util
    U->>JS: crea la bolsa de fichas
    U->>A: lanza sub-make (pasa --jobserver-auth en MAKEFLAGS)
    U->>B: lanza sub-make (pasa --jobserver-auth en MAKEFLAGS)
    A->>JS: pide ficha para su 2.ª receta
    B->>JS: pide ficha para su 2.ª receta
    JS-->>A: ficha
    JS-->>B: ficha
    Note over JS: Con todas las fichas en uso,<br/>quien pida otra espera
    A->>JS: devuelve ficha al terminar
```

Con `make -j4`, el padre reparte 4 fichas entre todos los sub-makes: nunca hay más de 4 recetas en marcha en todo el árbol. Solo las líneas con `$(MAKE)` (o con prefijo `+`) reciben acceso a la bolsa. Un `make` literal en Make 4.3, o un `-j4` escrito dentro de la receta, rompe el reparto: el hijo cae a `-j1` o crea su propia bolsa.
