# Lab 06 — Depurar cinco errores en reglas de patrón

⏱ Duración estimada: ~50 min

## Objetivo

Identificar y corregir cinco errores comunes en reglas de patrón de Make, usando los mensajes de error como guía de diagnóstico.

## Contexto

Los errores en reglas de patrón producen mensajes que a primera vista parecen crípticos. El diagnóstico requiere entender qué espera Make:

| Mensaje | Causa más probable |
|---------|-------------------|
| `No rule to make target 'foo.o'` | El patrón no coincide con el target, o el prerrequisito no existe |
| `*** missing separator` | Espacios en lugar de TAB antes de la receta |
| `Circular dependency` | El target y el prerrequisito tienen el mismo nombre |
| `No rule to make target 'build/%.o'` | Se usó `%` como nombre literal de archivo |
| Receta ejecutada pero target incorrecto | `$@` mal escrito como `$$@` o `$(@)` fuera de contexto |

## Instrucciones

El archivo `starter/Makefile` contiene cinco targets (`bug-1` al `bug-5`), cada uno con un error distinto.

1. Ejecuta `make bug-1` y lee el error. Identifica la causa y corrígela.
2. Repite para `bug-2` al `bug-5`.
3. Una vez corregidos todos, ejecuta:
   ```bash
   make all-bugs
   ```
   Este target agrupa los cinco. Debe completarse sin errores.

### Pistas por bug

- **bug-1**: La receta usa espacios en lugar de TABs. Usa `cat -A Makefile | grep " bug-1" -A2` para ver los caracteres invisibles.
- **bug-2**: El patrón tiene el target y el prerrequisito invertidos.
- **bug-3**: La variable `$@` está escrita como `$$@` dentro de la receta.
- **bug-4**: El directorio de salida no se crea antes de escribir el archivo.
- **bug-5**: La regla de patrón usa `%` en el target pero el prerrequisito tiene un nombre fijo sin `%`.

## Criterios de éxito

- [ ] `make all-bugs` completa sin errores tras las correcciones
- [ ] `make bug-1` imprime `[ok] bug-1.out generado`
- [ ] `make bug-2` imprime `[ok] bug-2.out generado`
- [ ] `make bug-3` imprime el nombre del target correctamente (sin `$@` literal)
- [ ] `make bug-4` crea el archivo en `out/bug-4.out` sin error de directorio
- [ ] `make bug-5` compila `bug-5.raw` correctamente con la receta del patrón
- [ ] `make clean` elimina todos los archivos generados

## Reto extra

Escribe un target `diagnose` que use `make -p 2>/dev/null` para volcar la base de datos de Make y filtre (`grep`) las líneas relacionadas con los patrones `bug-`. El output debe mostrar cómo Make internalizó cada regla después de las correcciones.
