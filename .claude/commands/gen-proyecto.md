# /gen-proyecto

Genera el proyecto semanal integrador de una semana del bootcamp.

## Uso

```
/gen-proyecto <semana-carpeta> "<Título del proyecto>" "<contexto técnico en una línea>"
```

**Ejemplo:**
```
/gen-proyecto week-04-variables_automaticas "Build System para Calculadora CLI" "proyecto C multi-archivo con main.c, operaciones.c, operaciones.h"
```

---

## Instrucciones para Claude

Lee `CLAUDE.md`. El proyecto debe integrar **todos** los conceptos de la semana, no solo uno.

### Archivos a crear

**`bootcamp/<semana>/3-proyecto/README.md`**

Secciones obligatorias:
1. `# Proyecto Semana NN — Título`
2. `## Contexto` — situación concreta (empresa ficticia, caso técnico real), 2-3 párrafos
3. `## Estructura del proyecto` — árbol de archivos que el estudiante recibirá en `starter/`
4. `## Lo que debes construir` — lista numerada de entregables concretos
5. `## Verificación` — comandos exactos que deben funcionar al terminar:
   ```bash
   make           # debe imprimir ayuda o ejecutar all
   make build     # debe compilar/procesar sin errores
   make clean     # debe limpiar sin errores
   make test      # debe ejecutar verificaciones básicas
   ```
6. `## Rúbrica del proyecto` — tabla con los 30 puntos distribuidos por criterio
7. `## Entrega` — instrucciones de commit y qué archivos entregar

**`bootcamp/<semana>/3-proyecto/starter/Makefile`**

- Estructura definida con secciones comentadas
- Variables con valores placeholder (`# TODO: ajusta según tu sistema`)
- Targets declarados con `.PHONY` pero con cuerpo vacío o `@echo "TODO: implementa <target>"`
- Debe tener `help` funcional desde el inicio
- Incluir archivos de soporte mínimos si aplica (`.c`, `.py`, `Dockerfile` ficticios pero realistas)

**`bootcamp/<semana>/3-proyecto/solucion/Makefile`**

- Solución completa al 100%
- Código profesional, sin atajos
- Comentarios explicando decisiones de diseño no obvias
- El `make help` debe ser informativo y completo

### Criterio de calidad del proyecto

- Debe tomar ~3h para alguien que completó los labs de la semana
- Si se puede completar en 1h, es demasiado simple — agregar complejidad
- Escribe primero (o actualiza) `checks.json` de la semana; el README del proyecto copia sus `descripcion` en `✅ Requisitos verificables`
- El contexto debe ser real (no "haz un Makefile para ejercicio.c")
- Los criterios de éxito deben ser binarios: funciona o no funciona
