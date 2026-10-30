# ¿Cuándo usar cada función avanzada?

```mermaid
flowchart TD
    A{¿Qué necesitas?} --> B{Generar una lista<br/>de strings a partir<br/>de otra lista}
    A --> C{Reutilizar un bloque<br/>de código con<br/>distintos parámetros}
    A --> D{Crear una regla Make<br/>con prerrequisitos<br/>y receta reales}
    A --> E{Obtener datos<br/>del sistema en<br/>tiempo de carga}

    B --> F["$(foreach var,list,text)<br/>Ejemplo:<br/>$(foreach m,auth logger,build/$(m).o)"]
    C --> G["define fn<br/>...<br/>endef<br/>$(call fn,arg1,arg2)"]
    D --> H["$(eval texto_makefile)<br/>Usualmente con call+foreach"]
    E --> I["$(shell comando)<br/>Ejemplo:<br/>$(shell git rev-parse --short HEAD)"]

    F --> J["String: build/auth.o build/logger.o"]
    G --> K["Plantilla expandida<br/>con $1, $2..."]
    H --> L["Nueva regla o variable<br/>en memoria de Make"]
    I --> M["stdout del comando<br/>como string Make"]
```

Regla práctica: `$(foreach)` para generar listas de texto, `$(call)` para reutilizar plantillas, `$(eval)` cuando el resultado de la plantilla debe ser una *regla con prerrequisitos y receta*, y `$(shell)` para incorporar datos del entorno (git, fecha, OS) que no puedes conocer al escribir el Makefile.
