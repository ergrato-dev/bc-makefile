# Lab 03 — `vpath`: fuentes repartidos en varios directorios

⏱ Duración estimada: ~60 min

## Objetivo

Compilar fuentes repartidos en `src/`, `src/core/` y `src/util/` con una sola regla de patrón usando `vpath`, y reconocer sus dos trampas: nombres duplicados y `vpath` aplicado a targets.

## Contexto

- El starter lista los fuentes solo por nombre (`main.c calc.c fmt.c`) y compila con `$(BUILD_DIR)/%.o: %.c`. Make no sabe dónde están.
- `vpath` le da a Make una lista de directorios donde buscar prerrequisitos por patrón. Es la herramienta clásica para proyectos heredados con el código repartido; en un proyecto nuevo, un árbol de salida que replique `src/` (como en el proyecto de la semana) es más robusto.
- Teoría: [02-order-only-y-vpath.md](../../1-teoria/02-order-only-y-vpath.md), sección `vpath`.

## Instrucciones

Trabaja dentro de `starter/`.

1. **Sin `vpath`.**
   ```bash
   make all
   ```
   ```
   make: *** No rule to make target 'build/main.o', needed by 'build/app'.  Stop.
   ```
   La regla `build/%.o: %.c` existe, pero `main.c` no está en el directorio actual, así
   que Make descarta la regla.

2. **`vpath %.c`.** Completa el TODO del paso 2 con
   `vpath %.c src src/core src/util` y compila:
   ```bash
   make all
   make run
   ```
   ```
   [cc]   src/main.c
   [cc]   src/core/calc.c
   [cc]   src/util/fmt.c
   [link] build/app
   media de 6 valores = 18
   ```
   El prerrequisito de la regla era `calc.c`, pero `$<` vale `src/core/calc.c`: Make
   sustituye el nombre por la ruta donde lo encontró. Por eso la receta nunca escribe
   rutas a mano.

3. **Inspeccionar las rutas.** Make imprime las rutas de búsqueda en su base de datos:
   ```bash
   make -p __nada__ 2>/dev/null | grep -A4 'VPATH Search'
   ```
   ```
   # VPATH Search Paths

   vpath %.c src:src/core:src/util
   ```

4. **`vpath` no es `-I`.** Añade `vpath %.h include` (TODO del paso 4) y compila
   quitando el `-I`:
   ```bash
   make -B all CPPFLAGS=
   ```
   ```
   src/main.c:1:10: fatal error: calc.h: No such file or directory
   ```
   `vpath` informa a **Make**, no al compilador. gcc sigue necesitando `-Iinclude`.
   Mira además `cat build/main.d`: gcc ya escribe `include/calc.h` con su ruta, así que
   para las dependencias automáticas `vpath %.h` no aporta nada; solo sirve si escribes
   prerrequisitos de headers a mano.

5. **Nombres duplicados.** Crea un segundo `calc.c` en `src/util/`:
   ```bash
   printf '#error "este calc.c no es el bueno"\n' > src/util/calc.c
   make -B all
   ```
   Compila sin quejarse: Make usó el primero que encontró (`src/core/calc.c`) y el otro
   queda en silencio. Cambia el orden a `vpath %.c src src/util src/core` y repite:
   ```
   src/util/calc.c:1:2: error: #error "este calc.c no es el bueno"
   ```
   Con `vpath`, el orden de los directorios decide qué archivo se compila. Restaura el
   orden y borra `src/util/calc.c`.

6. **La trampa: `vpath` para targets.** `trampa-vpath.mk` usa `vpath %.o build` para que
   Make "encuentre" los objetos en `build/`. Ejecuta la secuencia y anota cada resultado:
   ```bash
   make -f trampa-vpath.mk          # 1: compila y falla al enlazar
   make -f trampa-vpath.mk          # 2: enlaza bien
   touch src/core/calc.c
   make -f trampa-vpath.mk          # 3: recompila y falla otra vez
   make -f trampa-vpath.mk limpiar
   ```
   En la tercera verás `[link] build/main.o calc.o build/fmt.o`: cuando un target
   encontrado por `vpath` tiene que rehacerse, Make lo rehace **en el directorio
   actual** y olvida la ruta de `vpath`. Escribe en un comentario `# FIX:` al principio
   de `trampa-vpath.mk` por qué falla cada ejecución y cuál es el diseño correcto
   (pista: el que usa `Makefile`).

## Criterios de éxito

- [ ] `make all` compila los tres fuentes y `make run` imprime `media de 6 valores = 18`
- [ ] Ninguna receta contiene `src/core` ni `src/util`: las rutas salen de `$<`
- [ ] `make -p __nada__ | grep -A4 'VPATH Search'` muestra tus rutas
- [ ] Puedes explicar por qué `make -B all CPPFLAGS=` falla aunque exista `vpath %.h include`
- [ ] `trampa-vpath.mk` tiene un comentario `# FIX:` que explica las tres ejecuciones
- [ ] `make clean` deja `starter/` sin `build/`

## Reto extra

Reescribe `trampa-vpath.mk` con el diseño correcto: targets con su ruta completa
(`build/%.o: %.c`), `vpath` solo para `%.c` y el binario en `build/app` como target
real. Repite la secuencia del paso 6: las tres ejecuciones deben funcionar y la
segunda no debe imprimir nada.
