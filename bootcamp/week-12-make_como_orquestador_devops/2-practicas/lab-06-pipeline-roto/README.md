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
   Observa el primer error. Algunos errores no rompen la ejecución: solo se ven
   comparando lo que pasa con los criterios de éxito.

3. Sin leer la solución, usa `make -n`, `make --debug=v` o `make -p` para diagnosticar el problema.

4. Corrige el error y vuelve a ejecutar `make ci`.

5. Cuando `make ci` termine con `✓ CI OK`, comprueba también estos tres casos:
   ```bash
   ls build/          # ¿hay un report-AAAA-MM-DD.txt?
   make ci            # segunda ejecución: ¿se ejecutaron las cuatro etapas?
   make               # sin argumentos: ¿qué hizo?
   ```
   Son exactamente **5 errores**. Repite hasta que se cumplan todos los criterios de éxito.

6. Documenta cada error que encontraste: ¿qué era? ¿por qué fallaba? ¿cómo lo diagnosticaste?

## Pistas

- Error 1: algo con las dependencias del target `ci`
- Error 2: algo con variables que no están definidas cuando se necesitan
- Error 3: algo con `.PHONY`
- Error 4: algo con la sintaxis de receta
- Error 5: algo con el orden de targets

> No leas la solución hasta haber encontrado los 5. El objetivo es el proceso de diagnóstico.

## Criterios de éxito

- [ ] `make ci` imprime `✓ Lint OK`, `✓ Tests OK`, `✓ Build OK` y `✓ Reporte generado: build/report-AAAA-MM-DD.txt`, en ese orden, y termina con `✓ CI OK`
- [ ] Una segunda ejecución de `make ci` vuelve a imprimir `✓ Build OK`
- [ ] `make` sin argumentos muestra la ayuda y no borra nada
- [ ] Puedes explicar qué era cada uno de los 5 errores y qué síntoma producía
- [ ] Usaste al menos una de las herramientas de depuración (`-n`, `--debug`, `-p`)

## Reto extra

Agrega un target `ci-debug` que ejecuta el pipeline con `make --debug=b` para ver exactamente qué recetas ejecuta Make y por qué.
