# Lab 06 — funciones-rotas

**Duración estimada:** 50 minutos

## Objetivo

Identificar y corregir cuatro errores comunes en el uso de `$(foreach)`, `$(call)`, `$(eval)` y `$(shell)`.

## Contexto

Los bugs en funciones avanzadas de Make no suelen producir errores visibles — simplemente generan variables vacías, argumentos invertidos o reglas incompletas que fallan más adelante de forma misteriosa.

El `starter/Makefile` tiene exactamente 4 bugs. Ejecuta `make demo` y compara su salida con la salida esperada para localizar cada uno.

## Instrucciones

1. Entra al directorio starter:
   ```bash
   cd lab-06-funciones-rotas/starter
   ```

2. Ejecuta y observa la salida incorrecta:
   ```bash
   make demo
   ```

3. Para cada sección del Makefile, analiza:
   - ¿La variable tiene el valor correcto?
   - ¿Los argumentos están en el orden correcto?
   - ¿Las variables automáticas dentro del `define` tienen `$$`?
   - ¿El comando de `$(shell)` puede fallar silenciosamente?

4. Localiza los 4 bugs. Cada uno está marcado con un comentario `# BUG N:`.

5. Corrige los 4 bugs y verifica que `make demo` produce exactamente la salida esperada.

## Los 4 bugs a encontrar

| # | Función | Síntoma | Pista |
|---|---------|---------|-------|
| 1 | `$(foreach)` | `OBJS` está vacío | La variable de iteración en `$(foreach)` no coincide con la usada dentro del texto |
| 2 | `$(call)` | El servicio y el puerto aparecen invertidos | Los argumentos `$1` y `$2` se pasan en orden incorrecto al llamar |
| 3 | `$(eval)` | La regla generada tiene receta vacía | Falta `$$` antes de `<` y `@` dentro del `define` — se expanden a vacío en tiempo de parse |
| 4 | `$(shell)` | `GIT_HASH` vacío o fallo si no hay repo git | El comando no tiene fallback cuando git no está disponible o el directorio no es un repo |

## Criterios de éxito

La salida corregida debe ser exactamente:

```
$ make demo
OBJS:     build/auth.o build/logger.o build/config.o
Desplegando api en puerto 8080
Git hash: a1b2c3d
Reglas generadas para: auth logger config
```

(El hash git varía según el commit — lo importante es que no esté vacío y use `--short`.)

## Reto extra

Agrega un quinto bug intencional: usa `$(addsuffix)` donde corresponde `$(addprefix)` al generar `INC_FLAGS`. Documenta el síntoma y agrega la corrección.
