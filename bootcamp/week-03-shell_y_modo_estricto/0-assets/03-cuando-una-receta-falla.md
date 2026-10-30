# Qué hace Make cuando una receta falla

```mermaid
flowchart TD
    F["Una línea de receta sale con código ≠ 0"] --> P{"¿Prefijo - en la línea<br/>o make -i?"}
    P -- sí --> I["Error (ignored)<br/>sigue como si nada<br/>el target a medias SOBREVIVE"]
    P -- no --> D{"¿.DELETE_ON_ERROR?"}
    D -- sí --> X["Borra el target"]
    D -- no --> Q["El target a medias queda<br/>con fecha nueva: 'al día'"]
    X --> K{"¿make -k?"}
    Q --> K
    K -- sí --> KK["Construye los targets que no dependen<br/>del fallo y termina con código 2"]
    K -- no --> S["Para y termina con código 2"]
```

`.DELETE_ON_ERROR` evita que un archivo a medio escribir pase por bueno en la siguiente ejecución. El prefijo `-` y `make -i` anulan el error, y con él la limpieza: úsalos solo donde el fallo no cambia el resultado. `make -k` es seguro: sigue con lo independiente, pero el código de salida sigue siendo de error.
