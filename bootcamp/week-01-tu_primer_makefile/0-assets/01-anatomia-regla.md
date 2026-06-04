# Anatomía de una regla Make

```mermaid
graph TD
    A["<b>target</b><br/>nombre del artefacto o acción"]
    B["<b>dependencias</b><br/>qué debe existir antes"]
    C["<b>receta</b><br/>comandos de shell<br/><i>indentado con TAB obligatorio</i>"]

    A -->|depende de| B
    A -->|ejecuta| C
    B -->|si no existen| D["Make los construye primero<br/>(busca reglas para ellos)"]
    B -->|si ya existen y están al día| E["Make omite la receta<br/><i>solo si target = archivo real</i>"]

    style A fill:#2d6a4f,color:#fff
    style B fill:#1d3557,color:#fff
    style C fill:#8b0000,color:#fff
```

```makefile
# Ejemplo de la anatomía completa:
#
#   target  :  dependencia1  dependencia2
#   [TAB]      receta_línea_1
#   [TAB]      receta_línea_2
#
build: src/main.c src/utils.c
	gcc -o programa src/main.c src/utils.c
	echo "Build completo"
```

El **TAB** es el único separador válido entre el margen izquierdo y la receta. Espacios producen `missing separator. Stop.`
