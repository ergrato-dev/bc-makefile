# Lab 06 — Depurar seis errores en reglas de patrón

⏱ Duración estimada: ~60 min

## Objetivo

Diagnosticar y corregir seis errores reales en reglas de patrón usando solo el mensaje de Make, `make -n` y `make -p`.

## Contexto

Los errores de reglas de patrón engañan porque Make descarta en silencio las reglas que no aplican. El mensaje final (`No rule to make target`) no dice **por qué** ninguna aplicó.

| Síntoma | Causa más probable |
|---------|-------------------|
| `*** missing separator.  Stop.` | Espacios en lugar de TAB en una receta; Make no lee el resto del archivo |
| `No rule to make target 'x.out'` | Ningún patrón casa, o su prerrequisito no existe ni se puede construir |
| `target 'x' doesn't match the target pattern` | Un target de una static pattern rule no casa con su patrón |
| Un archivo que nadie pidió aparece en el directorio | Una regla implícita de serie actuó por ti |
| `'x' is up to date` en un target que debería ejecutarse siempre | Falta `.PHONY` y existe un archivo con ese nombre |

## Instrucciones

`starter/Makefile` tiene seis casos, `bug-1` a `bug-6`, cada uno con un error. Arréglalos en orden y, para cada uno, anota en una línea **la causa** (no solo el arreglo).

1. Ejecuta `make bug-1`:
   ```
   Makefile:36: *** missing separator.  Stop.
   ```
   Mira los caracteres invisibles con `cat -A Makefile | sed -n '36,37p'`: una receta debe empezar por `^I` (TAB). Hasta que lo arregles, ningún otro target funciona.

2. `make bug-2`:
   ```
   make: *** No rule to make target 'bug-2.out-2', needed by 'bug-2'.  Stop.
   ```
   Lee la regla en voz alta: "para construir un `.raw`, necesito un `.out-2`". ¿Es eso lo que quieres?

3. `make bug-3` termina **sin error**, pero imprime:
   ```
   [ok]  generado
   ```
   Falta el nombre. Compara con `make -n bug-3`: ¿qué le llega al shell en lugar del nombre del target?

4. `make bug-4`:
   ```
   cp: cannot create regular file 'out/bug-4.out-4': No such file or directory
   ```
   El compilador o `cp` nunca crean directorios. Usa la variable automática del directorio del target.

5. `make bug-5` "funciona", pero ejecuta `make bug-5` otra vez y lista el directorio:
   ```
   [ok] bug-5.out-5 generado
   cat bug-5.sh >bug-5
   chmod a+x bug-5
   ```
   ```
   make: 'bug-5' is up to date.
   ```
   Aparece un ejecutable `bug-5` que nadie escribió, y desde entonces `bug-5` nunca vuelve a ejecutarse. Busca qué regla lo creó con `make -p -f /dev/null 2>/dev/null | grep -A2 '^%: %.sh'`. Arréglalo de dos formas complementarias: declara los `bug-N` como `.PHONY` (un target phony no busca reglas implícitas) y añade `MAKEFLAGS += -r`. Borra el archivo `bug-5` antes de volver a probar.

6. Desde el paso 2 ves en cada ejecución:
   ```
   Makefile:82: target 'bug-6.out6' doesn't match the target pattern
   ```
   y `make bug-6` falla con `cp: missing destination file operand after 'bug-6.out6'`. Make avisó y siguió con `$<` vacío. Haz que el nombre de la lista case con el patrón.

7. Con los seis corregidos, desde cero:
   ```bash
   make clean && make all-bugs
   ```
   ```
   [ok] bug-1.out-1 generado
   [ok] bug-2.out-2 generado
   [ok] bug-3.out-3 generado
   [ok] out/bug-4.out-4 generado
   [ok] bug-5.out-5 generado
   [ok] bug-6.out-6 generado
   [ok] todos los bugs corregidos
   ```
   Repite `make all-bugs`: debe volver a imprimir solo `[ok] todos los bugs corregidos` y no aparecer ningún aviso.

## Criterios de éxito

- [ ] `make clean && make all-bugs` imprime las siete líneas `[ok]` del paso 7, sin avisos
- [ ] `make bug-3` imprime `[ok] bug-3.out-3 generado`
- [ ] Tras `make all-bugs` no existe ningún archivo llamado `bug-5`
- [ ] El Makefile declara `bug-1` … `bug-6` en `.PHONY` y contiene `MAKEFLAGS += -r`
- [ ] Tienes por escrito la causa de cada uno de los seis bugs
- [ ] `make clean` elimina todos los archivos generados y `out/`

## Reto extra

Los archivos de entrada no los crea un `setup` con un bucle, sino una static pattern rule (`$(filter %.raw,$(INPUTS)): bug-%.raw:`). Explica por qué un `setup` que crea los `.raw` con `for` y se lista como **primer prerrequisito** de `all-bugs` falla con `No rule to make target 'bug-1.out-1'` en la primera ejecución. (Pista: Make lee el contenido del directorio una vez y decide si un prerrequisito "existe" con esa foto.)
