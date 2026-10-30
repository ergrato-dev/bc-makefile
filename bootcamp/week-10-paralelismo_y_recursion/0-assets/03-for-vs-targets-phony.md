# Bucle `for` frente a subdirectorios como targets

```mermaid
flowchart TD
    Q{"¿Cómo lanza el raíz<br/>los sub-makes?"}
    Q -->|"bucle for con $(MAKE) dentro"| F["Una sola receta"]
    Q -->|"core/build util/build ... como targets phony"| T["Un nodo por subdirectorio"]
    F --> F1["Sin -e: el exit es el del último<br/>(fallos tragados)"]
    F --> F2["-j no reparte nada<br/>-k no puede seguir"]
    F --> F3["Sin forma de decir<br/>app depende de core"]
    T --> T1["Un fallo detiene el build"]
    T --> T2["-j en paralelo, -k sigue<br/>con los independientes"]
    T --> T3["app/build: core/build<br/>es una línea más"]
```

El bucle `for` esconde los subdirectorios dentro de una receta, fuera del alcance de Make. Convertir cada pareja directorio/meta en un target phony (`$(MAKE) -C $(@D) $(@F)`) los devuelve al grafo, y con ellos vuelven `-j`, `-k`, la propagación de fallos y las dependencias entre paquetes.
