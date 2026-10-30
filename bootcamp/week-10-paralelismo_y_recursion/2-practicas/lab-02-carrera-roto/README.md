# Lab 02 — Carreras en paralelo (Makefile roto)

⏱ Duración estimada: ~60 min

## Objetivo

Destapar y corregir cuatro carreras causadas por dependencias que el Makefile no declara, hasta que el build sea correcto con cualquier `-j`.

## Contexto

- En serie, Make construye los prerrequisitos **en el orden en que los escribiste**. Si `all: config paginas sitio` y las páginas leen `config`, funciona por casualidad: la dependencia existe en tu cabeza, no en el Makefile.
- Con `-j`, Make solo respeta el grafo. Todo lo que no está declarado puede ejecutarse a la vez. Una carrera no es un bug de `-j`: es una dependencia que falta, y `-j` la hace visible.
- Para encontrarlas sin esperar a que CI falle un martes: `-j` alto repetido varias veces (Make 4.3) o `--shuffle`, que baraja el orden de los prerrequisitos incluso en serie (Make 4.4+).

## Los síntomas

| Bug | Síntoma con `make -j8` |
|:--:|---|
| A | `grep: out/config.txt: No such file or directory` al generar una página |
| B | `mv: cannot stat 'out/tmp.txt'`, o una página con el `<h1>` de otra |
| C | `cat: out/inicio.html: No such file or directory` al ensamblar el sitio |
| D | `make -j8 rebuild` termina, pero `make check` dice que falta `out/site.html` |

## Instrucciones

1. Copia el starter y comprueba que en serie todo funciona:
   ```bash
   cp -r starter/ mi-lab-02 && cd mi-lab-02
   make clean && make all && make check
   ```
   Debes ver `check: OK`.

2. Ahora en paralelo:
   ```bash
   make clean && make -j8 all; echo "exit=$?"
   ```
   Falla con `exit=2`. Lee el primer error: es el bug A.

3. Aprende a destapar carreras sin depender de la suerte. En Make 4.3, repite el build paralelo:
   ```bash
   for i in 1 2 3 4 5; do make clean >/dev/null; make -j8 all >/dev/null 2>&1 && echo "vuelta $i ok" || echo "vuelta $i FALLA"; done
   ```

   > [!NOTE]
   > **Make 4.4+:** `--shuffle` baraja el orden de los prerrequisitos, también sin `-j`:
   > ```bash
   > make clean && make --shuffle=reverse all   # orden inverso: determinista
   > make clean && make --shuffle all           # aleatorio; el error muestra la semilla
   > ```
   > El error termina en `shuffle=3385448864`: `make --shuffle=3385448864 all` repite exactamente ese orden. En 4.3 la opción no existe (`unrecognized option '--shuffle'`); usa el bucle de arriba.

4. **Bug A.** La receta de cada página lee `$(CONFIG)`, pero la regla no lo declara. Añádelo como prerrequisito (y usa `$<` en la receta en lugar de `$(CONFIG)`). Deja un `# FIX:` encima. Después:
   ```bash
   make clean && make -j8 all; echo "exit=$?"
   ```
   Ya no hay `grep: ... No such file`, pero salen dos errores nuevos: el `cat` del sitio y un `mv`.

5. **Bugs B y C.**
   - B: las tres páginas escriben y mueven el mismo `out/tmp.txt`. En paralelo, la primera en hacer `mv` se lleva el archivo y las demás fallan (o, con peor suerte, una página sale con el contenido de otra). Usa un temporal por target: `$@.tmp`.
   - C: `$(SITE)` concatena las páginas, pero depende de `$(CONFIG)`. Debe depender de `$(PAGE_FILES)` (y la receta puede usar `$^`).

   Verifica:
   ```bash
   make clean && make -j8 all && make check
   ```
   Debes ver `check: OK`.

6. **Bug D.** Con todo construido, ejecuta tres o cuatro veces:
   ```bash
   make -j8 rebuild >/dev/null; make check
   ```
   Lo normal es que alterne entre `check: falta out/site.html` y `check: OK`. `rebuild: clean all` pide los dos a la vez, y con `-j` corren en paralelo: `all` da por buenos los archivos que `clean` está borrando. Cuando `out/` ya no existe, no hay nada que pisar y sale bien: por eso alterna. Corrígelo con dos sub-makes en secuencia:
   ```makefile
   rebuild: ## Borra y reconstruye el sitio
   	@$(MAKE) --no-print-directory clean
   	@$(MAKE) --no-print-directory all
   ```

   > [!NOTE]
   > **Make 4.4+:** `rebuild: clean .WAIT all` hace lo mismo sin sub-makes: Make no empieza nada a la derecha de `.WAIT` hasta terminar lo de la izquierda. En 4.3 falla con `No rule to make target '.WAIT'`.

7. Prueba de estrés: diez reconstrucciones paralelas seguidas.
   ```bash
   for i in $(seq 10); do make -j8 rebuild >/dev/null && make check; done
   ```
   Diez `check: OK`.

## Criterios de éxito

- [ ] `make clean && make -j8 all && make check` imprime `check: OK`
- [ ] El bucle del paso 3 da cinco `ok`
- [ ] `make -j8 rebuild && make check` imprime `check: OK` diez veces seguidas
- [ ] Ninguna receta escribe en un archivo que no sea `$@` o `$@.tmp`
- [ ] Cada corrección lleva un comentario `# FIX:` que explica qué dependencia faltaba

## Reto extra

Añade `.NOTPARALLEL:` al starter original (con los cuatro bugs) y comprueba que `make -j8 all` vuelve a funcionar. Explica en un comentario por qué eso no es un arreglo, sino esconder los bugs, y qué pierdes en un proyecto con 500 páginas.
