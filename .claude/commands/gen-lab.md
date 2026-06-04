# /gen-lab

Genera un lab individual (ejercicio práctico) para una semana del bootcamp.

## Uso

```
/gen-lab <semana-carpeta> <NN> "<nombre-kebab>" "<Objetivo del lab>"
```

**Ejemplo:**
```
/gen-lab week-02-variables_y_expansion 03 "override-desde-cli" "Sobrescribir variables desde la línea de comandos con make VAR=valor"
```

---

## Instrucciones para Claude

Lee `CLAUDE.md` para convenciones. El lab debe:

### Archivos a crear

**`bootcamp/<semana>/2-practicas/lab-<NN>-<nombre>/README.md`**

Estructura obligatoria en este orden:
1. `# Lab NN — Título` con `⏱ ~50 min` en la misma línea o justo debajo
2. `## Objetivo` — una sola oración con verbo en infinitivo
3. `## Contexto` — máx. 3 párrafos o 5 bullets; referencia al tema de la semana sin repetir la teoría
4. `## Instrucciones` — pasos numerados con comandos exactos a ejecutar; cada paso tiene un output esperado
5. `## Criterios de éxito` — checklist: "Al terminar este lab, `make <target>` debe producir:"
6. `## Reto extra` — extensión opcional para ir más lejos

**`bootcamp/<semana>/2-practicas/lab-<NN>-<nombre>/starter/Makefile`**

- Scaffolding real: variables declaradas, estructura visible, comentarios de orientación
- TODOs marcados como `# TODO: implementa aquí`
- El Makefile debe poder ejecutarse sin error incluso con los TODOs sin completar (usar targets vacíos o con `@echo "TODO"`)
- Incluir siempre `help` como target con documentación inline (`## descripción`)

**`bootcamp/<semana>/2-practicas/lab-<NN>-<nombre>/solucion/Makefile`**

- Solución completa, funcional, sin TODOs
- Código limpio con los estándares de CLAUDE.md
- Comentarios solo donde el WHY no es obvio

### Criterio de calidad del lab

- El estudiante debe poder completarlo sin salir de la carpeta del lab
- El output de `make` debe ser legible y significativo (no silencioso)
- Progresión: cada paso del lab desbloquea el siguiente
