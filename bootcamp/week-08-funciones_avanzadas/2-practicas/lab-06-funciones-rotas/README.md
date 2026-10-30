# Lab 06 — funciones-rotas

⏱ Duración estimada: ~60 min

## Objetivo

Identificar y corregir seis errores comunes en el uso de `$(foreach)`, `$(call)`, `$(eval)` y `$(shell)`.

## Contexto

Los bugs en funciones avanzadas de Make no suelen producir errores visibles — simplemente generan variables vacías, argumentos invertidos o reglas incompletas que fallan más adelante de forma misteriosa.

El `starter/Makefile` tiene exactamente 6 bugs. Ejecuta `make demo` y `make list` y compara su salida con la salida esperada para localizar cada uno.

## Instrucciones

1. Entra al directorio starter:
   ```bash
   cd lab-06-funciones-rotas/starter
   ```

2. Ejecuta y observa la salida incorrecta:
   ```bash
   make demo
   make list
   ```
   Con el starter verás, entre otras cosas:
   ```
   OBJS:     build/.o build/.o build/.o
   Desplegando 8080 en puerto api
   ...
   Artefacto: app-1793349128476610941.tar
   Manifest:  app-1793349128478250549.tar
     - auth echo   - logger echo   - config
   ```

3. El bug 3 no aparece en `make demo`: la regla generada existe, pero con la receta rota. Mírala en la base de datos de Make:
   ```bash
   make -p 2>/dev/null | grep -A6 '^build/auth.o:' | grep gcc
   ```
   Con el bug verás `gcc -c  -o ` (sin archivos). Corregido debe verse `gcc -c $< -o $@`.

4. Para cada sección del Makefile, analiza:
   - ¿La variable tiene el valor correcto?
   - ¿Los argumentos están en el orden correcto?
   - ¿Las variables automáticas dentro del `define` tienen `$$`?
   - ¿El comando de `$(shell)` puede fallar silenciosamente?
   - ¿Cuántas veces se ejecuta cada `$(shell)`?
   - ¿Cuántos comandos de shell produce cada `$(foreach)` dentro de una receta?

5. Localiza los 6 bugs. Cada uno está marcado con un comentario `# BUG N:`.

6. Corrige los 6 bugs y verifica que `make demo`, `make list` y el `make -p` del paso 3 producen la salida esperada.

## Los 6 bugs a encontrar

| # | Función | Síntoma | Pista |
|---|---------|---------|-------|
| 1 | `$(foreach)` | `OBJS` sale `build/.o build/.o build/.o` | La variable de iteración en `$(foreach)` no coincide con la usada dentro del texto |
| 2 | `$(call)` | El servicio y el puerto aparecen invertidos | Los argumentos `$1` y `$2` se pasan en orden incorrecto al llamar |
| 3 | `$(eval)` | La regla generada tiene receta vacía | Falta `$$` antes de `<` y `@` dentro del `define` — se expanden a vacío en tiempo de parse |
| 4 | `$(shell)` | `GIT_HASH` vacío o fallo si no hay repo git | El comando no tiene fallback cuando git no está disponible o el directorio no es un repo |
| 5 | `$(foreach)` en receta | `make list` imprime una sola línea con `echo` dentro | Las iteraciones se unen con espacios: sin `;` son un único comando |
| 6 | `$(shell)` + `=` | Artefacto y manifest con IDs distintos | Una variable recursiva vuelve a ejecutar el shell en cada referencia |

## Criterios de éxito

La salida corregida debe ser exactamente:

```
$ make demo
OBJS:     build/auth.o build/logger.o build/config.o
Desplegando api en puerto 8080
Git hash: a1b2c3d
Reglas generadas para: auth logger config
Artefacto: app-1793349128509454810.tar
Manifest:  app-1793349128509454810.tar
```

```
$ make list
  - auth
  - logger
  - config
```

(El hash git y el ID varían; lo importante es que el hash no esté vacío, use `--short`, y que los dos IDs sean **idénticos**.)

- [ ] `make demo` imprime `Desplegando api en puerto 8080` y `OBJS` con los tres objetos
- [ ] `make list` imprime tres líneas
- [ ] `make -p 2>/dev/null | grep -A6 '^build/auth.o:' | grep gcc` muestra `gcc -c $< -o $@`
- [ ] Puedes explicar con tus palabras la causa de cada bug

## Reto extra

Agrega un séptimo bug intencional: usa `$(addsuffix)` donde corresponde `$(addprefix)` al generar `INC_FLAGS`. Documenta el síntoma y agrega la corrección.
