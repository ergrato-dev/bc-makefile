# Guardas de un clean seguro

```mermaid
flowchart TD
    C["make clean (o make -n clean)"] --> E["Make expande TODAS las líneas<br/>de la receta antes de ejecutar ninguna"]
    E --> G1{"$(if $(BUILD_DIR),,...)<br/>¿BUILD_DIR vacía?"}
    G1 -- sí --> X1["$(error) BUILD_DIR vacía:<br/>rm -rf no se ejecuta. Stop."]
    G1 -- no --> G2{"$(filter $(CURDIR)/%,$(abspath ...))<br/>¿dentro del proyecto?"}
    G2 -- no --> X2["$(error) ... está fuera del proyecto. Stop."]
    G2 -- sí --> R["rm -rf -- '$(BUILD_DIR)'<br/>(con -n: solo se imprime)"]
```

Las guardas son funciones de Make, no comandos de shell: se evalúan al expandir la receta, así que paran el `clean` también en una previsualización con `make -n`. Las comillas simples y el `--` protegen de rutas con espacios o que empiezan por `-`.
