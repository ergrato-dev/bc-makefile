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

Lee `CLAUDE.md` antes de generar. Usa exactamente las convenciones definidas ahí.

Genera los siguientes archivos para la semana `$ARGUMENTS`:

### 1. `bootcamp/<carpeta>/README.md`
- Sigue la estructura de README de semana definida en CLAUDE.md
- Incluye tabla de contenidos con tiempos (30min teoría / 5h labs / 2h30 proyecto)
- Lista objetivos con verbos de acción concretos (Escribir, Depurar, Construir, etc.)

### 2. `bootcamp/<carpeta>/rubrica-evaluacion.md`
- Puntaje total: 100 pts
- Distribución: 50 labs + 30 proyecto + 20 calidad Makefile
- Tabla con criterios específicos al tema de la semana

### 3. `bootcamp/<carpeta>/1-teoria/01-contexto.md`
- Máximo 600 palabras
- Comienza con "¿Por qué importa esto?" (1 párrafo)
- Referencia rápida: tabla o snippet de los conceptos clave
- Termina con "Ahora ve al lab-01 y ponlo en práctica"
- Cero relleno, cero historia de Unix

### 4. `bootcamp/<carpeta>/2-practicas/README.md`
- Índice de los 5–6 labs con duración y objetivo en una línea

### 5. `bootcamp/<carpeta>/2-practicas/lab-01-<nombre>/README.md`
Con estructura: Título/duración → Objetivo → Contexto → Instrucciones → Criterios de éxito → Reto extra

### 6. `bootcamp/<carpeta>/2-practicas/lab-01-<nombre>/starter/Makefile`
Makefile con TODOs comentados (`# TODO: ...`). Debe tener scaffolding real, no un archivo vacío.

### 7. `bootcamp/<carpeta>/2-practicas/lab-01-<nombre>/solucion/Makefile`
Solución completa y funcional del lab-01.

### 8. `bootcamp/<carpeta>/3-proyecto/README.md`
- Enunciado del proyecto semanal
- Contexto de negocio/técnico concreto (no abstracto)
- Lista de entregables verificables
- Criterios de éxito: comandos exactos que deben funcionar

### 9. `bootcamp/<carpeta>/3-proyecto/starter/Makefile`
Punto de partida con estructura definida y TODOs.

### 10. `bootcamp/<carpeta>/5-glosario/README.md`
Tabla: Término | Definición en una línea | Ejemplo de uso en Makefile

### 11. `bootcamp/<carpeta>/4-recursos/webgrafia/README.md`
3–5 enlaces reales a documentación oficial de GNU Make o recursos de calidad.

---

Genera todos los archivos en secuencia. Confirma al final cuántos archivos creaste y lista sus rutas.
