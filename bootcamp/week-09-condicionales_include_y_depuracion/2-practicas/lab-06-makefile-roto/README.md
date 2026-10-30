# Lab 06 — Diagnosticar y Corregir un Makefile Roto

**Duración estimada:** 50 min

## Objetivo

Identificar y corregir 6 errores intencionales en un Makefile usando las herramientas de depuración aprendidas en la semana: `make -n`, `--debug=b`, `$(info)` y lectura de mensajes de error de Make.

## Contexto

Este lab invierte el flujo: en vez de implementar, diagnosticas. El `starter/Makefile` tiene 6 errores reales que Make reportará de forma críptica. Tu trabajo es:

1. Ejecutar Make y leer el error
2. Localizar la causa usando herramientas de depuración
3. Corregir el error
4. Repetir hasta que `make ci` y `make lint` funcionen

Los errores cubren los problemas más comunes en Makefiles reales:
- Uso de espacios en vez de TAB
- Variable recursiva que causa bucle
- Prerrequisito que no tiene ninguna regla (`No rule to make target`)
- `include` de archivo que no existe (sin `-include`)
- Condicional mal formado
- Dependencia circular

## Instrucciones

1. Copia el starter:
   ```bash
   cp -r starter/ mi-lab-06 && cd mi-lab-06
   ```

2. Ejecuta Make y lee el primer error:
   ```bash
   make ci 2>&1 | head -20
   ```

3. Para cada error que encuentres:
   - Anota el mensaje de error exacto
   - Identifica el número de línea
   - Corrige el error en tu copia
   - Vuelve a ejecutar `make ci`

4. Usa estas herramientas para ayudarte:
   ```bash
   make -n ci          # dry-run: muestra comandos sin ejecutar
   make --debug=b ci   # muestra decisiones de reconstrucción
   make -p 2>/dev/null | grep "^ci"  # busca la regla en la base de datos
   ```

5. `make ci` no pasa por `lint`: ese error solo aparece al pedirlo. Cuando
   hayas corregido los 6 errores:
   ```bash
   make ci
   make lint
   make help
   ```

## Errores intencionales (no leer antes de intentarlo)

<details>
<summary>Pista 1 — Tipos de errores presentes</summary>

Los 6 errores son de estas categorías:
1. Indentación con espacios en una receta
2. Variable recursiva infinita (`= $(VAR)` referenciando a sí misma)
3. Prerrequisito sin regla: un target depende de otro que no existe
4. `include` sin guion de un archivo inexistente
5. `ifeq` sin `endif`
6. Dependencia circular: `a: b` y `b: a`

</details>

## Criterios de éxito

- [ ] `make ci` completa sin errores e imprime `CI completo`
- [ ] `make help` lista todos los targets
- [ ] `make build` → `Compilando mi-app`
- [ ] `make test` → `Tests OK`
- [ ] `make lint` → `Lint OK`
- [ ] `make ci` ya no muestra `Circular ... dependency dropped`
- [ ] Puedes explicar cada uno de los 6 errores que corregiste

## Reto extra

Escribe un target `make lint-makefile` que ejecute `make -n` y busque patrones de error comunes con grep (espacios al inicio de receta, etc.).
