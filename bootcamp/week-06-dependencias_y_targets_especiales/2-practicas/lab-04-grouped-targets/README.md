# Lab 04 — Grouped targets: un generador, dos archivos

⏱ Duración estimada: ~60 min

## Objetivo

Garantizar que un generador que produce un par `.c`/`.h` se ejecute una sola vez por build, también con `make -j`, usando un grouped target `&:`.

## Contexto

- `tools/gen-tabla.sh defs/colores.def build/gen` lee una tabla de colores y escribe `build/gen/colores.c` **y** `build/gen/colores.h` en la misma ejecución. Tarda 0,2 s, como un generador real.
- El starter declara la regla con `:`. En serie todo parece correcto; con `-j` el generador corre dos veces en paralelo sobre los mismos archivos. Es el tipo de bug que solo aparece en CI.
- Teoría: [03-grouped-e-intermedios.md](../../1-teoria/03-grouped-e-intermedios.md).

## Instrucciones

Trabaja dentro de `starter/`.

1. **En serie, todo bien.**
   ```bash
   make clean && make all
   make run
   ```
   ```
   [gen]  build/gen/colores.c + colores.h
   [cc]   src/main.c
   [cc]   build/gen/colores.c
   [link] build/app
   rojo   #ff0000
   verde  #00ff00
   azul   #0000ff
   ```

2. **En paralelo, dos veces.**
   ```bash
   make clean && make -j4 all
   ```
   ```
   [gen]  build/gen/colores.c + colores.h
   [gen]  build/gen/colores.c + colores.h
   [cc]   build/gen/colores.c
   [cc]   src/main.c
   [link] build/app
   ```
   Repítelo cinco veces contando ejecuciones:
   ```bash
   for i in 1 2 3 4 5; do make clean >/dev/null; make -j4 all | grep -c '^.gen.'; done
   ```
   Cinco veces `2`. Con un generador que escribe archivos grandes, dos procesos
   escribiendo a la vez producen archivos corruptos de forma intermitente.

3. **Por qué en serie "funciona".** La regla `$(GEN_C) $(GEN_H): ...` equivale a dos
   reglas con la misma receta. En serie, Make ejecuta la de `colores.h` primero; cuando
   llega a `colores.c`, comprueba su fecha, ve que ya es más nuevo que el `.def` y no
   hace nada. Es una casualidad del orden. Con `-j4` Make lanza las dos recetas antes de
   que termine la primera. Compruébalo también tras un cambio:
   ```bash
   touch defs/colores.def && make all        # un [gen]
   touch defs/colores.def && make -j4 all    # dos [gen]
   ```

4. **`&:`.** Completa el TODO del paso 4: cambia `:` por `&:` en la regla del generador.
   ```bash
   for i in 1 2 3 4 5; do make clean >/dev/null; make -j4 all | grep -c '^.gen.'; done
   ```
   Cinco veces `1`. Y tras `touch defs/colores.def && make -j4 all`, un solo `[gen]`.

5. **La alternativa con patrón.** Las reglas de patrón con varios targets **siempre**
   fueron agrupadas. Sustituye temporalmente la regla por:
   ```makefile
   $(GEN_DIR)/%.c $(GEN_DIR)/%.h: defs/%.def $(GEN_TOOL) | $(GEN_DIR)/
   	@bash $(GEN_TOOL) $< $(GEN_DIR)
   ```
   Repite el bucle del paso 4: también `1`. Sirve cuando hay muchos `.def`; para un
   único generador con nombres fijos, `&:` es más explícito. Vuelve a dejar `&:`.

6. **`$@` en una receta agrupada.** Añade temporalmente como primera línea de la receta
   del generador:
   ```makefile
   	@echo "[debug] target que disparó la regla: $@"
   ```
   Con `make clean && make all` verás `build/gen/colores.h`: `$@` es **uno** de los
   targets, el que Make necesitó primero. Por eso la receta le pasa al generador el
   directorio y no `$@`. Quita la línea.

## Criterios de éxito

- [ ] `make clean && make -j4 all | grep -c '^.gen.'` imprime `1` en cinco ejecuciones seguidas
- [ ] `touch defs/colores.def && make -j4 all` ejecuta el generador una vez y recompila los dos objetos
- [ ] Un segundo `make all` imprime `Nothing to be done for 'all'.`
- [ ] `make run` imprime las tres filas de la tabla
- [ ] La receta del generador no usa `$@`
- [ ] `make clean` deja `starter/` sin `build/`

## Reto extra

Añade `defs/tamanos.def` (`pequeno 8`, `mediano 16`, `grande 32`) y haz que `main.c`
imprima también esa tabla. Usa la regla de patrón del paso 5 para los dos `.def`.
¿Cuántas veces corre el generador con `make clean && make -j8 all`, y por qué ese
número es el correcto?
