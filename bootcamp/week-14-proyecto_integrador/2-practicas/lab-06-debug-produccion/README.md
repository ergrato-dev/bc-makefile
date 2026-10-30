# Lab 06 — Diagnosticar y Corregir un Build System Roto

⏱ Duración estimada: ~60 min

## Objetivo

Diagnosticar y corregir cinco errores de un Makefile de producción usando, para cada uno, la herramienta de Make que lo hace visible.

## Contexto

El Makefile del starter es el build system de un microservicio que dejó de funcionar después de que tres personas lo tocaran la misma semana. Los errores son de semanas distintas del bootcamp: expansión de variables (02), recetas y TAB (01, 03), `.PHONY` (01), dependencias reales frente a orden de la lista con `-j` (10) y recursión con `$(MAKE)` (10).

Algunos fallan con un mensaje claro; otros salen con código 0 y solo se notan si sabes qué preguntar. Por eso cada paso usa una herramienta distinta: `make -n`, `-p`, `--warn-undefined-variables`, `-j2` en un árbol limpio y `echo $?` después de cada comando.

## Instrucciones

1. Copia el starter (no abras la solución):
   ```bash
   cp -r starter/ mi-lab-06 && cd mi-lab-06
   ```

2. Ejecuta cualquier cosa, incluso la ayuda:
   ```bash
   make help
   ```
   Debes ver `Makefile:NN: *** missing separator.  Stop.` Abre esa línea con un
   editor que muestre los espacios (`cat -A Makefile | sed -n 'NN,+2p'`: un TAB
   se ve como `^I`). Corrige las tres líneas de la receta de `deploy`.

3. Comprueba el pipeline en serie y en paralelo, siempre desde un árbol limpio:
   ```bash
   make clean && make ci; echo "exit=$?"
   make clean && make -j2 ci; echo "exit=$?"
   ```
   En serie pasa; con `-j2` debe fallar con
   `cat: build/version.txt: No such file or directory`. ¿Qué target lee un
   archivo que otro crea, y dónde está declarada esa relación? Recuerda: el
   orden de `ci: lint test build` solo se respeta sin `-j`.

4. Lanza el sub-make en paralelo:
   ```bash
   make clean && make -j2 all 2>&1 | grep -i jobserver
   ```
   Debe aparecer `warning: jobserver unavailable: using -j1.  Add '+' to parent make rule.`
   Busca la receta que lanza otro Make. ¿Por qué el hijo no recibe el jobserver?

5. Despliega:
   ```bash
   make deploy; echo "exit=$?"
   ```
   Debe fallar con `✗ El artefacto no es el de este build`. Compara la marca
   de tiempo que escribió `build` (`cat build/timestamp.txt`) con la que
   imprime `deploy`. Después mira cómo está definida la variable:
   ```bash
   make -p __nada__ 2>/dev/null | grep -B1 '^TIMESTAMP'
   ```
   El comentario `# makefile (from 'Makefile', line NN)` y el operador (`=` o
   `:=`) te dicen cuándo se evalúa `$(shell date ...)`.

6. Ejecuta el target que usa el job de release de CI:
   ```bash
   make release; echo "exit=$?"
   ```
   Debe imprimir `make: Nothing to be done for 'release'.` y `exit=0`. Es el
   error más peligroso de los cinco: CI queda en verde sin publicar nada. ¿Por
   qué Make no se queja de un target que no tiene regla?

7. Corrige cada error con un comentario `# FIX N:` que diga síntoma y causa, y
   comprueba que todo queda verde:
   ```bash
   make clean && make -j2 ci; echo "exit=$?"          # exit=0
   make clean && make -j2 all 2>&1 | grep -c jobserver # 0
   make deploy | tail -1                              # ✓ Deploy OK
   make release; echo "exit=$?"                       # No rule to make target 'release' ... exit=2
   make --warn-undefined-variables -n ci 2>&1 | grep -c warning   # 0
   ```

8. Rellena una tabla con una fila por error: síntoma, comando que lo reveló,
   causa raíz y semana del bootcamp que lo explica.

## Criterios de éxito

- [ ] `make help` lista los 9 targets documentados
- [ ] `make clean && make -j2 ci` sale con 0 e imprime `==> Tests con build 1.0.0` después de `✓ Build OK`
- [ ] `make -j2 all` no imprime ningún aviso de jobserver
- [ ] `make deploy` termina con `✓ Deploy OK`
- [ ] `make release` sale con código ≠ 0 (o existe una regla `release` real)
- [ ] Los cinco errores corregidos y comentados con `# FIX N:`, con su tabla de diagnóstico

## Reto extra

En Make 4.4+, ejecuta el starter corregido a medias (todo salvo el error del paso 3) con `make --shuffle -j2 ci` varias veces. `--shuffle` baraja el orden de los prerrequisitos y destapa dependencias que faltan aunque la máquina sea rápida.

> [!NOTE]
> **Make 4.4+.** `--shuffle` no existe en 4.3. Alternativa en 4.3: repetir
> `make clean && make -j8 ci` en bucle hasta que falle.
