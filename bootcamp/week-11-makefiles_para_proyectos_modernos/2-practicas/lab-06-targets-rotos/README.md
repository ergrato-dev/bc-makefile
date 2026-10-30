# Lab 06 — Targets Rotos

**Duración estimada:** 50 minutos

## Objetivo

Identificar y corregir los cinco errores más comunes en Makefiles de proyectos modernos a partir de mensajes de error reales.

## Contexto

Un compañero dejó un Makefile heredado con cinco bugs. El Makefile "parece" correcto pero falla de maneras inesperadas. Cada bug produce un síntoma diferente y requiere un diagnóstico distinto.

Antes de mirar la solución, intenta reproducir cada error, leer el mensaje que produce Make y deducir la causa. Esta habilidad de diagnóstico es la que más diferencia a un usuario avanzado de Make.

## Los 5 bugs

| # | Síntoma | Causa subyacente |
|---|---------|-----------------|
| Bug 1 | `make build` dice "is up to date" sin hacer nada | `build` no está en `.PHONY` y existe un directorio `build/` |
| Bug 2 | `make install` falla con "missing separator" | Una línea de receta usa espacios en vez de TAB |
| Bug 3 | `make test` falla con "No rule to make target 'instal'" | Dependencia con typo: `instal` en vez de `install` |
| Bug 4 | `make info` falla con "Recursive variable 'SOURCES' references itself" | Variable `SOURCES` definida con `=` referenciándose a sí misma |
| Bug 5 | `make info` imprime "Versión: " (string vacío) y un `fatal: No names found` | `$(shell git describe --tags)` falla sin tags y no tiene fallback |

## Instrucciones

1. Entra al directorio starter:
   ```bash
   cd lab-06-targets-rotos/starter
   ```

2. Ejecuta cualquier target y observa el error:
   ```bash
   make build               # bug 2: missing separator
   ```
   El bug 2 es un error de sintaxis: Make no llega a leer el resto del archivo,
   así que tapa a los demás. Corrígelo primero y después observa los otros cuatro:
   ```bash
   mkdir -p build           # prepara el escenario del bug 1
   make build               # bug 1
   make test                # bug 3
   make info                # bug 4; tras corregirlo, bug 5
   ```

3. Corrige cada bug en el Makefile:
   - **Bug 1:** agrega `build` a la línea `.PHONY`
   - **Bug 2:** reemplaza los 4 espacios de la receta de `install` por un TAB real
   - **Bug 3:** corrige `instal` → `install` en la dependencia de `test`
   - **Bug 4:** cambia `SOURCES = $(SOURCES) src/main.py` por `SOURCES := src/main.py` (expansión inmediata)
   - **Bug 5:** agrega fallback al shell: `$(shell git describe --tags 2>/dev/null || echo 0.0.0)`

4. Verifica que el Makefile corregido funciona:
   ```bash
   make demo
   ```

## Criterios de éxito

```
$ make demo
=== Makefile corregido ===
Versión:  0.0.0  (o el tag git si existe)
Sources:  src/main.py
Build OK: target build es PHONY, siempre ejecuta
Install:  TAB correcto
Test dep: install correcto
```

No debe haber errores de `missing separator`, `Recursive variable ... references itself`, ni targets bloqueados por directorios existentes.

## Reto extra

Agrega un target `check-make` que verifique que todos los targets de `.PHONY` existen como targets declarados en el Makefile. Pista: usa `$(shell grep -E '^[a-zA-Z_-]+:' $(MAKEFILE_LIST) | cut -d: -f1)` para extraer la lista de targets declarados.
