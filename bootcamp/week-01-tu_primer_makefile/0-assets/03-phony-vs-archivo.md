# PHONY vs Target de archivo

```mermaid
flowchart TD
    A["make &lt;target&gt;"] --> B{"¿Está declarado\nen .PHONY?"}
    B -- Sí --> E["Ejecuta la receta\nsiempre"]
    B -- No --> C{"¿Existe un archivo\ncon ese nombre?"}
    C -- No --> E
    C -- Sí --> D{"¿El archivo es más\nnuevo que sus deps?"}
    D -- Sí --> F["'target' is up to date\nNo ejecuta nada"]
    D -- No --> E

    style E fill:#2d6a4f,color:#fff
    style F fill:#8b0000,color:#fff
```

**Regla práctica:** si un target no produce un archivo con su mismo nombre, decláralo `.PHONY`. Siempre.

```makefile
.PHONY: build clean test help   ← estos no producen archivos llamados
                                  'build', 'clean', 'test' ni 'help'

reporte.txt: datos.csv          ← este SÍ produce 'reporte.txt';
	cat datos.csv > reporte.txt   no va en .PHONY
```
