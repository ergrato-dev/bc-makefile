# Lab 06 — Depurar un Pipeline Roto

**Duración estimada:** 50 min

## Objetivo

Identificar y corregir cinco errores intencionales en un Makefile de pipeline CI/CD que impiden su ejecución correcta.

## Contexto

Este lab invierte el flujo habitual: en lugar de implementar, depuras. El Makefile del starter tiene cinco errores reales del tipo que aparecen en proyectos de producción. Cada error bloquea una etapa del pipeline de una forma diferente.

Herramientas de depuración Make:
```bash
make -n          # dry-run: muestra qué ejecutaría sin ejecutar
make --debug=v   # trazas de Make (verboso)
make -p          # dump de todas las reglas y variables
```

## Instrucciones

1. Copia el starter (no copies la solución):
   ```bash
   cp -r starter/ mi-lab-06 && cd mi-lab-06
   ```

2. Intenta ejecutar el pipeline:
   ```bash
   make ci
   ```
   Observa el primer error.

3. Sin leer la solución, usa `make -n`, `make --debug=v` o `make -p` para diagnosticar el problema.

4. Corrige el error y vuelve a ejecutar `make ci`.

5. Repite hasta que `make ci` complete sin errores. Son exactamente **5 errores**.

6. Documenta cada error que encontraste: ¿qué era? ¿por qué fallaba? ¿cómo lo diagnosticaste?

## Pistas

- Error 1: algo con las dependencias del target `ci`
- Error 2: algo con variables que no están definidas cuando se necesitan
- Error 3: algo con `.PHONY`
- Error 4: algo con la sintaxis de receta
- Error 5: algo con el orden de targets

> No leas la solución hasta haber encontrado los 5. El objetivo es el proceso de diagnóstico.

## Criterios de éxito

- [ ] `make ci` en la solución corregida termina con `✓ CI OK`
- [ ] Puedes explicar qué era cada uno de los 5 errores
- [ ] Usaste al menos una de las herramientas de depuración (`-n`, `--debug`, `-p`)
- [ ] La solución no tiene TODOs ni errores intencionales

## Reto extra

Agrega un target `ci-debug` que ejecuta el pipeline con `make --debug=b` para ver exactamente qué recetas ejecuta Make y por qué.
