# Shell en recetas

## ¿Por qué importa esto?

Make no ejecuta tus recetas: se las pasa a un shell, línea a línea. Casi todos los Makefiles que "funcionan en mi máquina y fallan en CI" fallan aquí: un `cd` que no llega a la línea siguiente, un `$` que se comió Make, un `[[ ]]` que en tu portátil corre en bash y en el runner corre en dash. Entender quién ejecuta qué te ahorra horas de depuración.

## Cada línea, un shell nuevo

Make lanza un proceso de shell **por línea** de receta. Lo que una línea cambia en su shell (directorio actual, variables, `export`) muere con ella.

```makefile
.PHONY: wrong right
wrong:
	cd /tmp
	pwd
right:
	cd /tmp && pwd
```

`make wrong` imprime el directorio del Makefile; `make right`, `/tmp`. Usa `&&` y no `;`: si el `cd` falla, el resto no debe ejecutarse en el directorio equivocado.

Para escribir un bloque largo en un solo shell, termina cada línea con `\`. Make las une en una sola línea lógica, así que cada comando necesita su `;`:

```makefile
.PHONY: loop
loop:
	@for n in uno dos tres; do \
		echo "elemento: $$n"; \
	done
```

## `$` es de Make, `$$` es del shell

Make expande `$` antes de pasar la línea al shell. `$HOME` en una receta es la variable de Make `$(H)` seguida de `OME`. Para que el shell reciba `$HOME`, escribe `$$HOME`.

| Escribes | Lo expande | El shell recibe |
|---|---|---|
| `$(BUILD_DIR)` | Make | `build` |
| `$$HOME` | el shell | `$HOME` |
| `$HOME` | Make (mal) | `OME` |
| `$$(date +%F)` | el shell | `$(date +%F)` |

## `SHELL`: dash no es bash

Si no lo fijas, Make usa `/bin/sh`. En Debian, Ubuntu y casi todas las imágenes Docker, `/bin/sh` es **dash**: no tiene `[[ ]]`, ni llaves `{a,b}`, ni `pipefail`, y su `echo` trata `-e` como texto. Tu shell interactivo no cuenta: Make ignora la variable `SHELL` del entorno. Por eso todo Makefile de este bootcamp empieza con:

```makefile
SHELL := bash
```

## `.ONESHELL`

`.ONESHELL:` manda **toda** la receta a un único shell: el `cd` persiste. Tiene dos trampas:

- Afecta a todas las recetas del Makefile; no se puede activar para un solo target.
- Make solo ve el código de salida del final. Sin `-e` en `.SHELLFLAGS` (ver [02-modo-estricto](02-modo-estricto.md)), un comando que falla en mitad no detiene nada. Además, los prefijos `@`, `-` y `+` solo cuentan en la primera línea.

## Prefijos de receta

| Prefijo | Efecto | Úsalo para |
|---|---|---|
| `@` | No imprime el comando antes de ejecutarlo | `echo` y `help`; nunca en un `rm` |
| `-` | Ignora el código de salida de esa línea | Comandos cuyo fallo no cambia el resultado; nunca en el que escribe el target |
| `+` | Ejecuta la línea incluso con `make -n` | Llamadas a `$(MAKE)` (Semana 10); nunca en comandos destructivos |

## Opciones de la línea de comandos

| Opción | Efecto |
|---|---|
| `make -n` | Imprime lo que haría sin ejecutarlo (salvo líneas `+`). Úsalo antes de cualquier `clean` |
| `make -k` | Sigue con los targets que no dependen del que falló; termina igualmente con error |
| `make -i` | Ignora todos los errores. No tiene uso legítimo en un build |

> [!NOTE]
> `.RECIPEPREFIX := >` cambia el TAB obligatorio por otro carácter. Existe, pero rompe la expectativa de cualquiera que lea el Makefile: no lo uses en este bootcamp.

Sigue con [02-modo-estricto.md](02-modo-estricto.md), o ve al [lab-01](../2-practicas/lab-01-cada-linea-un-shell/README.md) y ponlo en práctica.
