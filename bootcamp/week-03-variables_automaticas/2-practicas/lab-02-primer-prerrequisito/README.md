# Lab 02 — `$<`: el primer prerrequisito, y solo ese

⏱ Duración estimada: ~50 min

## Objetivo

Usar `$<` para pasar el primer prerrequisito a un comando, y entender por qué `$<` es correcto para compilar pero incorrecto para enlazar.

## Contexto

`$<` expande al **primer** prerrequisito de la lista. En una regla de compilación C:

```makefile
main.o: main.c include/utils.h include/math.h
    gcc -c $< -o $@
```

`$<` = `main.c`. Los headers son prerrequisitos (Make los monitorea para detectar cambios) pero no son argumentos del compilador. Pasar `$^` al compilador produciría un error: `gcc -c main.c include/utils.h include/math.h -o main.o` falla.

La situación se invierte en el linker:

```makefile
app: main.o utils.o math.o
    gcc $^ -o $@    # correcto: necesita todos los .o
    gcc $< -o $@    # incorrecto: enlaza solo main.o → undefined references
```

Este lab te hace experimentar ambos escenarios para fijar la diferencia.

## Instrucciones

1. Abre `starter/Makefile`. Lee los comentarios de cada target.

2. Completa `compilar-main` imprimiendo la diferencia entre `$<` y `$^`:
   ```makefile
   compilar-main: src/main.c include/utils.h include/math.h
   	@echo "[cc] Compilando (solo fuente): $<"
   	@echo "[cc] Todos los prereqs:        $^"
   ```
   Verifica: `make compilar-main` → el primer echo tiene solo `src/main.c`.

3. Completa `compilar-utils` con el mismo patrón.

4. Completa `enlazar`. Imprime `$<` y `$^` por separado para ver la diferencia:
   ```bash
   make enlazar
   # [ld] Primer objeto (incorrecto para linker): main.o
   # [ld] TODOS los objetos (correcto):           main.o utils.o math.o
   ```

5. Responde en un comentario dentro del Makefile: ¿por qué `gcc $< -o app` falla en producción aunque aquí solo hacemos echo?

## Criterios de éxito

- [ ] `make compilar-main` imprime exactamente:
  ```
  [cc] Compilando (solo fuente): src/main.c
  [cc] Todos los prereqs:        src/main.c include/utils.h include/math.h
  ```
- [ ] `make compilar-utils` imprime solo `src/utils.c` en el primer echo
- [ ] `make enlazar` imprime `main.o` en `$<` y `main.o utils.o math.o` en `$^`
- [ ] Hay un comentario en el Makefile explicando por qué `$<` es incorrecto para el linker
- [ ] `make help` lista los tres targets con descripción

## Reto extra

Agrega un target `compilar-todos` que dependa de `compilar-main` y `compilar-utils`. En su receta, imprime: `"[resumen] Módulos compilados: $^"`. Observa que `$^` lista los targets prerrequisitos, no los archivos fuente.
