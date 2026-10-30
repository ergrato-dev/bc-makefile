# Lab 02 — `$<`: el primer prerrequisito, y solo ese

⏱ Duración estimada: ~60 min

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
	# gcc $< -o $@  # incorrecto: enlaza solo main.o → undefined references
```

Este lab te hace experimentar ambos escenarios para fijar la diferencia.

## Instrucciones

1. Abre `starter/Makefile` y lee los comentarios de cada target. Después crea
   los fuentes del lab:
   ```bash
   make setup
   ```
   Debes ver `[setup] Fuentes creados en src/ e include/`. Los prerrequisitos
   tienen que existir: si pides `make compilar-main` antes del `setup`, Make se
   detiene con `No rule to make target 'src/main.c'`.

2. Completa `compilar-main` imprimiendo la diferencia entre `$<` y `$^`:
   ```makefile
   compilar-main: src/main.c include/utils.h include/math.h
   	@echo "[cc] Compilando (solo fuente): $<"
   	@echo "[cc] Todos los prereqs:        $^"
   ```
   Verifica: `make compilar-main` → el primer echo tiene solo `src/main.c`.

3. Completa `compilar-utils` con el mismo patrón.

4. Completa `enlazar`. Sus prerrequisitos son los objetos `build/*.o`: Make
   los compilará primero con las reglas del paso 6 (de momento solo imprimen
   el TODO). Imprime `$<` y `$^` por separado:
   ```bash
   make enlazar
   # [ld] Primer objeto (incorrecto para linker): build/main.o
   # [ld] TODOS los objetos (correcto):           build/main.o build/utils.o build/math.o
   ```

5. Responde en un comentario dentro del Makefile: ¿por qué `gcc $< -o app` fallaría al enlazar?

6. **Compila de verdad.** Completa las tres reglas `build/*.o` con
   `$(CC) -Iinclude -c $< -o $@`. Los headers están en la lista de
   prerrequisitos para que Make recompile si cambian, pero `$<` solo pasa el
   `.c` a gcc. Borra lo anterior y compila:
   ```bash
   make limpiar && make setup
   make build/main.o
   # gcc -Iinclude -c src/main.c -o build/main.o
   ```

7. Completa `build/app` con `$(CC) $^ -o $@` y ejecútalo:
   ```bash
   make build/app && ./build/app
   # gcc build/main.o build/utils.o build/math.o -o build/app
   # Hola desde utils
   ```
   Ahora toca un header y observa qué se recompila:
   ```bash
   touch include/math.h && make build/app
   ```
   Solo `build/main.o` y `build/math.o` (los que lo listan como prerrequisito)
   y el enlace.

8. **Provoca el error del linker.** Cambia `$^` por `$<` en la receta de
   `build/app`, borra el binario (`rm build/app`) y ejecuta `make build/app`:
   ```
   gcc build/main.o -o build/app
   ... undefined reference to `suma'
   ... undefined reference to `saludo'
   ```
   Con `$<` solo llega `main.o` al linker. Vuelve a `$^` y termina con
   `make limpiar`.

## Criterios de éxito

- [ ] `make compilar-main` imprime exactamente:
  ```
  [cc] Compilando (solo fuente): src/main.c
  [cc] Todos los prereqs:        src/main.c include/utils.h include/math.h
  ```
- [ ] `make compilar-utils` imprime solo `src/utils.c` en el primer echo
- [ ] `make enlazar` imprime `build/main.o` en `$<` y los tres objetos en `$^`
- [ ] `make build/app && ./build/app` imprime `Hola desde utils`
- [ ] Tras `touch include/math.h`, solo se recompilan `main.o` y `math.o`
- [ ] Con `$<` en el enlace, gcc falla con `undefined reference`, y puedes explicar por qué
- [ ] `make help` lista los targets con descripción

## Reto extra

Agrega un target `compilar-todos` que dependa de `compilar-main` y `compilar-utils`. En su receta, imprime: `"[resumen] Módulos compilados: $^"`. Observa que `$^` lista los targets prerrequisitos, no los archivos fuente.
