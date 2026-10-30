# Paralelismo: `-j`, carreras y salida legible

## ¿Por qué importa esto?

Tu portátil tiene 8 núcleos y `make` usa uno. Con `-j8`, un build de 400 objetos C tarda una fracción del tiempo, sin cambiar una línea del Makefile... si el Makefile es correcto. En serie, Make construye los prerrequisitos en el orden en que los escribiste, y eso esconde dependencias que nunca declaraste. Con `-j`, solo respeta el grafo, y esas dependencias olvidadas se convierten en fallos intermitentes: la peor clase de bug de CI.

## Referencia rápida

| Opción o target | Qué hace |
|---|---|
| `-j N` / `--jobs=N` | Hasta N recetas a la vez |
| `-j` sin número | Sin límite: lanza todo lo que esté listo. Peligroso con proyectos grandes |
| `-l N` | No arranca recetas nuevas si la carga del sistema supera N |
| `-k` | Tras un fallo, sigue con lo que no depende del target roto |
| `-O[modo]` / `--output-sync` | Agrupa la salida: `none`, `line`, `target` (el de `-O` a secas), `recurse` |
| `.NOTPARALLEL:` | Todo este Makefile en serie, aunque pases `-j` |
| `.WAIT` | **Make 4.4+.** En una lista de prerrequisitos, espera a que termine lo de la izquierda |
| `--shuffle` | **Make 4.4+.** Baraja el orden de los prerrequisitos para destapar carreras |

Mide el paralelismo contando solapes, no solo con `time`: cada receta escribe `start` y `end` en una traza y `awk` calcula el máximo simultáneo. Es estable aunque la máquina esté cargada.

## Una carrera mínima

Pega esto en un `Makefile` vacío:

```makefile
.DELETE_ON_ERROR:
.PHONY: all clean

all: config.txt page.txt

config.txt:
	@sleep 1
	@echo "titulo=Demo" > $@

page.txt:
	@grep titulo config.txt > $@

clean:
	@rm -f config.txt page.txt
```

```bash
make clean && make        # funciona: config.txt va antes en la lista
make clean && make -j2    # grep: config.txt: No such file or directory
```

`page.txt` lee `config.txt`, pero no lo declara. El arreglo no es quitar `-j`: es decir la verdad en el grafo.

```makefile
page.txt: config.txt
	@grep titulo $< > $@
```

Las carreras típicas son tres: una receta que lee un archivo que no declara, dos recetas que escriben el mismo temporal (usa `$@.tmp`, nunca `tmp.txt`), y `rebuild: clean all`, que con `-j` ejecuta los dos a la vez.

## Destapar carreras a propósito

En Make 4.3, repite el build con `-j` alto hasta que falle:

```bash
for i in 1 2 3 4 5; do make clean >/dev/null; make -j8 >/dev/null 2>&1 || echo "falla en la vuelta $i"; done
```

> [!NOTE]
> **Make 4.4+:** `make --shuffle=reverse` invierte el orden de todas las listas de prerrequisitos, incluso sin `-j`: si el build depende del orden, falla siempre. `make --shuffle` baraja al azar y el error muestra la semilla (`shuffle=3385448864`) para repetirlo con `--shuffle=3385448864`. En 4.3 la opción no existe: usa el bucle de arriba.

## Ordenar sin dependencias falsas

`rebuild` necesita que `clean` termine antes de `all`, pero `all` no depende de `clean`. En Make 4.3, dos sub-makes en secuencia:

```makefile
rebuild:
	@$(MAKE) --no-print-directory clean
	@$(MAKE) --no-print-directory all
```

> [!NOTE]
> **Make 4.4+:** `rebuild: clean .WAIT all`. En 4.3, `.WAIT` es un nombre de archivo más y falla con `No rule to make target '.WAIT'`.

`.NOTPARALLEL:` es el freno de emergencia para un Makefile que aún no es seguro en paralelo; no arregla nada, solo apaga `-j`. En 4.4, `.NOTPARALLEL: objetivo` serializa solo los prerrequisitos de ese objetivo; 4.3 ignora la lista y serializa el Makefile entero.

## Salida legible

Con `-j`, las líneas de varias recetas se mezclan. `-O` guarda la salida de cada target y la imprime en bloque al terminar. Para que nadie tenga que acordarse, actívalo en el Makefile, con la variable definida **antes** (Make 4.4 lee `MAKEFLAGS` en el momento de la asignación):

```makefile
OUTPUT_SYNC ?= target
MAKEFLAGS   += --output-sync=$(OUTPUT_SYNC)
```

El precio: no ves nada de un target hasta que termina, y las herramientas detectan que su salida ya no es una terminal y apagan los colores. `make -j8 OUTPUT_SYNC=none` lo desactiva para una ejecución.

Listo. Ve al [lab-01](../2-practicas/lab-01-jobs-paralelos/README.md) y ponlo en práctica.
