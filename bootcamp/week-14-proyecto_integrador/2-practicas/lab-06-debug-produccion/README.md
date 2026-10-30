# Lab 06 — Diagnosticar y Corregir un Build System Roto

**Duración estimada:** 50 min

## Objetivo

Identificar y corregir cinco errores intencionados en un Makefile de producción roto, usando las técnicas de depuración aprendidas en el bootcamp.

## Contexto

El Makefile del starter representa el build system de un microservicio real que dejó de funcionar después de que tres personas lo modificaron a la vez. Los síntomas son variados: algunos targets no hacen nada, otros fallan con errores crípticos, el paralelismo produce resultados inconsistentes, y `make help` no muestra todos los targets. Tu tarea es diagnosticar y corregir cada error.

**Errores intencionados en el starter (encuéntralos tú):**
1. Un target listado en `.PHONY` no existe como target real
2. Una variable se expande en el momento equivocado (`=` vs `:=`)
3. Un target que debería ser phony produce un archivo llamado igual que el target
4. Dependencias mal declaradas causan condición de carrera con `-j2`
5. Un target usa espacios en lugar de TABs en su receta

## Instrucciones

1. Copia el starter:
   ```bash
   cp -r starter/ mi-lab-06 && cd mi-lab-06
   ```

2. Ejecuta el diagnóstico inicial:
   ```bash
   make -n all         # qué ejecutaría sin correr
   make --debug=b all  # por qué reconstruye cada target
   make -p | grep "^ci" # ver reglas del target ci
   ```

3. Identifica los cinco errores. Para cada uno:
   - Describe el síntoma
   - Identifica la causa raíz
   - Aplica la corrección

4. Verifica que el Makefile corregido funciona:
   ```bash
   make all
   make ci
   make -j2 ci
   make help  # debe mostrar todos los targets documentados
   ```

## Criterios de éxito

- [ ] `make all` completa sin errores
- [ ] `make ci` ejecuta lint → test → build en orden correcto
- [ ] `make -j2 ci` produce el mismo resultado que `make ci` (sin condición de carrera)
- [ ] `make help` muestra todos los targets con su documentación
- [ ] Los cinco errores están corregidos y comentados con `# FIX: descripción`

## Reto extra

Escribe un target `validate-makefile` que use `make -n --debug=b` para verificar que el Makefile no tiene targets que nunca se ejecutarían, e imprima un reporte de diagnóstico.
