# /gen-semana

Genera el contenido completo de una semana del bootcamp bc-makefile.

## Uso

```
/gen-semana <NN> <carpeta> "<Título del tema>"
```

**Ejemplo:**
```
/gen-semana 02 week-02-variables_y_expansion "Variables y Expansión en Make"
```

---

## Instrucciones para Claude

Lee `CLAUDE.md` antes de generar. Respeta todas las convenciones definidas ahí.

Genera **todos** los archivos listados abajo para la semana `$ARGUMENTS`. No omitas ninguna sección.

---

### 1. `bootcamp/<carpeta>/README.md`
- Título, descripción (2-3 oraciones), objetivos (verbos de acción), prerrequisitos
- Tabla de contenidos con tiempos: 30min teoría / 5h labs (~6×50min) / 2h30 proyecto
- Sección "Verificación de completitud" con comandos exactos

### 2. `bootcamp/<carpeta>/rubrica-evaluacion.md`
- Total: 100 pts. Distribución: 50 labs + 30 proyecto + 20 calidad Makefile
- Tabla con criterios específicos al tema de la semana

### 3. `bootcamp/<carpeta>/0-assets/` — Diagramas Mermaid (mínimo 3 archivos)

Crea un archivo `.md` por diagrama. Cada archivo tiene: título H1, bloque ```mermaid```, y 2-3 líneas de explicación.

Diagramas mínimos por semana (adapta el contenido al tema):
- `01-concepto-principal.md` — diagrama del concepto central de la semana
- `02-flujo-ejecucion.md` — cómo Make procesa/ejecuta el concepto
- `03-decision-o-comparacion.md` — diagrama de decisión o comparación de variantes

Usa diagramas `graph TD`, `flowchart`, o `sequenceDiagram` según aplique.

### 4. `bootcamp/<carpeta>/1-teoria/01-contexto.md`
- Máximo 600 palabras
- Abre con "¿Por qué importa esto?" (1 párrafo directo)
- Referencia rápida: tabla o snippet con los conceptos clave
- Ejemplo mínimo funcional de Makefile (autoejecutable con solo `make`)
- Termina con enlace al lab-01: "Listo. Ve al [lab-01](../2-practicas/lab-01-.../README.md) y ponlo en práctica."

### 5. `bootcamp/<carpeta>/2-practicas/README.md`
- Tabla con 5–6 labs: número, nombre, objetivo en una línea, duración estimada

### 6–17. `bootcamp/<carpeta>/2-practicas/lab-0N-<nombre>/` — Todos los labs (5 o 6)

Para **cada** lab genera 3 archivos:

**`README.md`** con secciones en orden:
1. Título + duración estimada
2. Objetivo (verbo en infinitivo, una oración)
3. Contexto (máx. 3 párrafos/bullets)
4. Instrucciones (pasos numerados con comandos exactos y outputs esperados)
5. Criterios de éxito (checklist con `make <target>` → output esperado)
6. Reto extra (opcional)

**`starter/Makefile`** con:
- Scaffolding real (variables, `.PHONY`, `.DEFAULT_GOAL`)
- TODOs comentados (`# TODO: ...`) donde el estudiante debe implementar
- Target `help` funcional desde el inicio

**`solucion/Makefile`** con:
- Solución completa y funcional, sin TODOs
- Estándares del repo (TABs, PHONY, help, UPPER_SNAKE_CASE, lower-kebab-case)

### 18. `bootcamp/<carpeta>/3-proyecto/README.md`
- Contexto de negocio/técnico concreto (no abstracto)
- Árbol de archivos del starter
- Lista de entregables numerados
- Comandos exactos de verificación con outputs esperados
- Rúbrica del proyecto (30 pts distribuidos)
- Instrucciones de entrega (mensaje de commit)

### 19. `bootcamp/<carpeta>/3-proyecto/starter/Makefile`
- Estructura definida con secciones comentadas
- TODOs en cada target a implementar
- `help` funcional desde el inicio

### 20. `bootcamp/<carpeta>/3-proyecto/solucion/Makefile`
- Solución completa y profesional

### 21. `bootcamp/<carpeta>/4-recursos/ebooks-free/README.md`
Tabla con libros/documentos gratuitos descargables o legibles online (mínimo 2):
```
| Título | Formato | Descripción | Enlace |
```

### 22. `bootcamp/<carpeta>/4-recursos/videografia/README.md`
Tabla con videos de YouTube u otras plataformas abiertas (mínimo 3):
```
| Título | Canal | Duración | Enlace |
```
Preferir en español; complementar con inglés si no hay suficientes de calidad.

### 23. `bootcamp/<carpeta>/4-recursos/webgrafia/README.md`
Tabla con documentación oficial y artículos de calidad (3–5 recursos):
```
| Recurso | Descripción |
```

### 24. `bootcamp/<carpeta>/5-glosario/README.md`
Tabla con 8–15 términos nuevos de la semana:
```
| Término | Definición en una línea | Ejemplo en Makefile |
```

---

Al terminar, confirma cuántos archivos creaste y lista sus rutas.
