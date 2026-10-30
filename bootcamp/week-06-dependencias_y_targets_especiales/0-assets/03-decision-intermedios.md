# ¿Make va a borrar este archivo?

```mermaid
flowchart TD
    A["Make construye X"] --> B{"¿X aparece como target o prerrequisito en el Makefile?"}
    B -->|Sí| N["No es intermedio: se queda"]
    B -->|"No: lo dedujo encadenando reglas de patrón"| C{"¿Está marcado?"}
    C -->|".SECONDARY: X"| S["Se queda. Si falta, no fuerza rebuild"]
    C -->|".PRECIOUS: X o patrón"| P["Se queda. Tampoco se borra si la receta falla"]
    C -->|".NOTINTERMEDIATE: X (Make 4.4+)"| N
    C -->|"Nada"| D["Intermedio: rm X al terminar"]
    B -->|"Sí, pero en .INTERMEDIATE"| D
```

Un archivo es intermedio cuando Make lo necesitó para una cadena de reglas de patrón pero nadie lo nombró. Elige la marca por el efecto que quieres: `.SECONDARY` conserva, `.PRECIOUS` conserva incluso tras un fallo (y anula `.DELETE_ON_ERROR`), `.NOTINTERMEDIATE` lo saca de la categoría.
