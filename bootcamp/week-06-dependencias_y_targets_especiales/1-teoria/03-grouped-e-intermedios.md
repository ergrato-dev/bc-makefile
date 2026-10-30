# Grouped targets e intermedios

## ¿Por qué importa esto?

Los generadores de código (protoc, bison, un script propio) suelen producir
**varios archivos en una sola ejecución**. Si se lo cuentas mal a Make, con
`-j` lanza el generador dos veces a la vez, que escriben los mismos archivos
en paralelo. Y cuando un archivo generado es solo un paso intermedio, Make
lo borra al terminar sin preguntarte. Ambas cosas tienen arreglo de una
línea, si sabes cuál es.

## Dos targets, una receta: `:` frente a `&:`

```makefile
# INCORRECTO: son DOS reglas independientes con la misma receta
gen/api.c gen/api.h: api.def
	./generar.sh $<

# CORRECTO (Make 4.3+): una regla, una ejecución produce los dos
gen/api.c gen/api.h &: api.def
	./generar.sh $<
```

Con `:` Make entiende "cada uno de estos targets se construye con esta
receta". En serie suele funcionar por casualidad: tras generar `api.c`,
`api.h` ya está al día. Con `make -j4`, si hacen falta los dos, Make lanza
la receta dos veces en paralelo. Con `&:` (*grouped target*) Make sabe que
una ejecución actualiza todos.

| Forma | Ejecuciones con `-j` | Notas |
|---|:-:|---|
| `a b : dep` explícita | Una por target | Bug clásico con generadores |
| `a b &: dep` | Una | Make 4.3+ |
| `%.c %.h : %.def` (patrón) | Una | Las reglas de patrón con varios targets siempre fueron agrupadas |

## Intermedios: por qué Make borra tu `.c` generado

Ejemplo autoejecutable: crea `saludo.def` con `echo hola > saludo.def` y
ejecuta `make` con este Makefile.

```makefile
SHELL       := bash
.SHELLFLAGS := -eu -o pipefail -c
.DELETE_ON_ERROR:

.PHONY: all clean
.DEFAULT_GOAL := all

all: saludo.o

# Cadena: saludo.def -> saludo.c -> saludo.o
%.c: %.def
	printf 'const char *saludo = "%s";\n' "$$(cat $<)" > $@

%.o: %.c
	$(CC) -c $< -o $@

clean:
	rm -f saludo.c saludo.o
```

La salida termina con `rm saludo.c`. Make necesitó `saludo.c` para llegar a
`saludo.o`, pero ningún Makefile lo menciona: lo dedujo encadenando dos
reglas de patrón. Eso lo convierte en **intermedio**, y los intermedios se
borran al final. Además, un intermedio ausente no obliga a rehacer nada:
el siguiente `make` responde `Nothing to be done`.

| Target especial | Efecto |
|---|---|
| `.INTERMEDIATE: x` | Trata `x` como intermedio aunque esté mencionado |
| `.SECONDARY: x` | Intermedio que no se borra; sin prerrequisitos, aplica a todos |
| `.PRECIOUS: x` o `%.c` | No se borra si es intermedio **ni** si la receta se interrumpe o falla; acepta patrones |
| `.NOTINTERMEDIATE: x` o `%.c` | Nunca es intermedio (Make 4.4+) |

> [!NOTE]
> **Make 4.4+.** `.NOTINTERMEDIATE` no existe en 4.3: allí es un target más,
> sin efecto especial. Alternativa 4.3 para archivos concretos:
> `.SECONDARY: saludo.c`. Para un patrón: `.PRECIOUS: %.c`.

Cuidado con `.PRECIOUS`: también anula `.DELETE_ON_ERROR`. Si la receta
falla a medias, el archivo corrupto se queda en disco y el siguiente `make`
lo da por bueno. Úsalo para directorios o artefactos caros, no para todo.

## `.EXTRA_PREREQS` y `.SECONDEXPANSION` en una línea

- `.EXTRA_PREREQS := Makefile` (4.3): prerrequisito que no aparece en `$^`.
- `.SECONDEXPANSION:`: permite `$$(@D)` y similares en prerrequisitos.

Los dos están en los archivos de teoría anteriores; aquí solo los
colocamos junto al resto de targets especiales.

---

Listo. Ve al [lab-01](../2-practicas/lab-01-anatomia-del-d/README.md) y ponlo en práctica.
