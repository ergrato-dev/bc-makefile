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
- [ ] `rubrica-evaluacion.md` usa 30/40/30 con 10 preguntas de Conocimiento y 70% por evidencia
- [ ] `checks.json` existe, es válido; `./scripts/verificar-semana.sh NN` falla contra el starter y `ENTREGA=solucion ./scripts/verificar-semana.sh NN` pasa N/N
- [ ] README tiene `## 🔗 Navegación` y la semana figura en `bootcamp/README.md`
- [ ] Hay 6 labs en `2-practicas/`
- [ ] Cada lab tiene `README.md`, `starter/Makefile` y `solucion/Makefile`
- [ ] El proyecto tiene `README.md`, `starter/` y `solucion/`

**Calidad de Makefiles**
- [ ] Todos los Makefiles usan TABs (no espacios) en las recetas
- [ ] Targets no-archivo están declarados en `.PHONY`
- [ ] Existe target `help` en todos los Makefiles de solucion
- [ ] Variables en `UPPER_SNAKE_CASE`, targets en `lower-kebab-case`
- [ ] `.DEFAULT_GOAL` definido en Makefiles de solución

**Calidad de contenido**
- [ ] Cada archivo de `1-teoria/` tiene menos de 600 palabras de prosa
- [ ] La teoría no repite lo que los labs explican paso a paso
- [ ] Los labs tienen criterios de éxito verificables
- [ ] El proyecto toma ~3h (no más de 4, no menos de 2h)
- [ ] Soluciones desde la semana 03 usan preámbulo estricto; sin `for` recursivo, `export` global ni `rm -rf` sin guarda
- [ ] `./scripts/verificar-enlaces.sh` sale 0
- [ ] Idioma: prosa en español, código en inglés

**Progresión pedagógica**
- [ ] Lab 01 es el más sencillo, Lab 05/06 el más complejo
- [ ] El proyecto integra todos los conceptos de la semana
- [ ] No aparecen conceptos de semanas futuras sin advertencia

### Output esperado

Tabla con ✅ / ❌ / ⚠️ para cada ítem. Para los ❌ y ⚠️, describe exactamente qué falta o está mal y sugiere el fix.

Al final: resumen en 2-3 líneas del estado general de la semana.
