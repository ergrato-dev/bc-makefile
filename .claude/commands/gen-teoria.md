# /gen-teoria

Genera el archivo de contexto mínimo (1-teoria) para una semana.

## Uso

```
/gen-teoria <semana-carpeta> "<tema>" "<conceptos clave separados por coma>"
```

**Ejemplo:**
```
/gen-teoria week-04-reglas_de_patron "Reglas de Patrón" "%.o: %.c, static pattern rules, vpath, reglas implícitas"
```

---

## Instrucciones para Claude

Lee `CLAUDE.md`. La teoría es un **puente mínimo** al lab, no un tutorial completo.

### Archivo a crear

**`bootcamp/<semana>/1-teoria/01-contexto.md`**

Estructura obligatoria:

```markdown
# Contexto — <Tema>

## ¿Por qué importa esto?
<1 párrafo directo. Qué problema resuelve. Qué pasa si no lo sabes.>

## Referencia rápida

<tabla o snippets con los conceptos clave — máximo lo que cabe en una pantalla>

## Ejemplo mínimo funcional

<Makefile de 15-25 líneas que demuestre todos los conceptos clave juntos>
<Debe poder copiarse y ejecutarse con `make`>

## Qué observar cuando ejecutes el ejemplo

<3-5 bullets: qué output esperar, qué comando ver, qué comportamiento notar>

---
Listo. Ve al [lab-01](../2-practicas/lab-01-.../README.md) y ponlo en práctica.
```

### Restricciones estrictas

- Máximo 600 palabras en prosa
- No explicar historia de Unix/Make ni por qué Make fue creado
- No listar todos los casos edge — solo el 80% que se usa siempre
- No repetir lo que los labs explican step-by-step
- El ejemplo de Makefile debe ser autocontenido (no depender de archivos .c externos)
- Usar `@echo` para demostrar conceptos cuando no hay archivos reales de por medio
