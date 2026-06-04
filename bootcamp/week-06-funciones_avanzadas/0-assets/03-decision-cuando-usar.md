# ¿Cuándo usar cada función avanzada?

```mermaid
flowchart TD
    A{¿Qué necesitas?} --> B{Generar una lista\nde strings a partir\nde otra lista}
    A --> C{Reutilizar un bloque\nde código con\ndistintos parámetros}
    A --> D{Crear una regla Make\ncon prerrequisitos\ny receta reales}
    A --> E{Obtener datos\ndel sistema en\ntiempo de carga}

    B --> F["$(foreach var,list,text)\nEjemplo:\n$(foreach m,auth logger,build/$(m).o)"]
    C --> G["define fn\n...\nendef\n$(call fn,arg1,arg2)"]
    D --> H["$(eval texto_makefile)\nUsualmente con call+foreach"]
    E --> I["$(shell comando)\nEjemplo:\n$(shell git rev-parse --short HEAD)"]

    F --> J["String: build/auth.o build/logger.o"]
    G --> K["Plantilla expandida\ncon $1, $2..."]
    H --> L["Nueva regla o variable\nen memoria de Make"]
    I --> M["stdout del comando\ncomo string Make"]
```

Regla práctica: `$(foreach)` para generar listas de texto, `$(call)` para reutilizar plantillas, `$(eval)` cuando el resultado de la plantilla debe ser una *regla con prerrequisitos y receta*, y `$(shell)` para incorporar datos del entorno (git, fecha, OS) que no puedes conocer al escribir el Makefile.
