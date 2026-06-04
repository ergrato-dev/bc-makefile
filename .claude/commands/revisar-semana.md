# /revisar-semana

Audita una semana generada para verificar consistencia, calidad y adherencia a los estándares del bootcamp.

## Uso

```
/revisar-semana <semana-carpeta>
```

**Ejemplo:**
```
/revisar-semana week-01-tu_primer_makefile
```

---

## Instrucciones para Claude

Lee `CLAUDE.md` y luego revisa todos los archivos de `bootcamp/<semana>/`. Reporta:

### Checklist a verificar

**Estructura**
- [ ] Existen todos los directorios: `0-assets/`, `1-teoria/`, `2-practicas/`, `3-proyecto/`, `4-recursos/`, `5-glosario/`
- [ ] `README.md` de la semana tiene todas las secciones requeridas
- [ ] `rubrica-evaluacion.md` existe y suma 100 pts correctamente
- [ ] Hay entre 5 y 6 labs en `2-practicas/`
- [ ] Cada lab tiene `README.md`, `starter/Makefile` y `solucion/Makefile`
- [ ] El proyecto tiene `README.md`, `starter/` y `solucion/`

**Calidad de Makefiles**
- [ ] Todos los Makefiles usan TABs (no espacios) en las recetas
- [ ] Targets no-archivo están declarados en `.PHONY`
- [ ] Existe target `help` en todos los Makefiles de solucion
- [ ] Variables en `UPPER_SNAKE_CASE`, targets en `lower-kebab-case`
- [ ] `.DEFAULT_GOAL` definido en Makefiles de solución

**Calidad de contenido**
- [ ] `1-teoria/01-contexto.md` tiene menos de 600 palabras
- [ ] La teoría no repite lo que los labs explican paso a paso
- [ ] Los labs tienen criterios de éxito verificables
- [ ] El proyecto toma ~2h30 (no más de 4, no menos de 1h30)
- [ ] Idioma: prosa en español, código en inglés

**Progresión pedagógica**
- [ ] Lab 01 es el más sencillo, Lab 05/06 el más complejo
- [ ] El proyecto integra todos los conceptos de la semana
- [ ] No aparecen conceptos de semanas futuras sin advertencia

### Output esperado

Tabla con ✅ / ❌ / ⚠️ para cada ítem. Para los ❌ y ⚠️, describe exactamente qué falta o está mal y sugiere el fix.

Al final: resumen en 2-3 líneas del estado general de la semana.
