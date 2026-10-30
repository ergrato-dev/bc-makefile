# Testing y portabilidad de Makefiles

## ¿Por qué importa esto?

Un Makefile falla de dos formas silenciosas: con un typo que se expande a vacío, o en una máquina distinta de la tuya. El make de macOS es GNU Make 3.81 y no da error con tu Makefile moderno: lo ejecuta **mal**, porque ignora `.SHELLFLAGS` y pierde `pipefail` sin avisar. Las dos cosas se previenen con herramientas que Make ya trae.

## Probar un Makefile

| Herramienta | Qué detecta | Ojo |
|---|---|---|
| `--warn-undefined-variables` | `$(REPORT_TITLE)` mal escrita | Con `-n` revisa también las recetas sin ejecutarlas |
| `make -n` | Qué comandos correría | Ejecuta `$(shell)`, `+` y `$(MAKE)` (ver teoría 01) |
| `make -n -B all \| diff -u esperado -` | Cambios de receta no pedidos (golden test) | Regenera el esperado cuando el cambio es intencionado |
| `make -q target` | ¿Está al día? 0 sí, 1 no, 2 error | Úsalo sobre archivos: un phony con receta siempre da 1 |
| Construir cada target aislado | Prerrequisitos que faltan | `make clean && make build/report.txt` |
| `--shuffle` | Lo mismo, con orden aleatorio | Make 4.4+ |

Juntas en un target `check`, el CI las ejecuta en cada PR. Cada línea debe **fallar** si existe el problema que comprueba.

> [!NOTE]
> **Make 4.4+.** `make --shuffle` desordena los prerrequisitos y `--shuffle=reverse` los invierte. **En 4.3**, construye cada target por separado desde un directorio limpio: detecta lo mismo de forma determinista.

## Portabilidad

Tres capas, de más a menos importante:

1. **La versión de Make.** Pon una guarda al principio con sintaxis que 3.81 entienda, para que el make viejo pueda explicar qué falta. Mejor aún, pregunta por features con `$(filter output-sync,$(.FEATURES))`.
2. **Los comandos de las recetas.** `sed -i`, `stat -c`, `date --iso-8601`, `echo -e` y `sha256sum` cambian o no existen en macOS/BSD. Usa `sed ... > f.tmp && mv`, `wc -c <`, `date -u +%Y-%m-%dT%H:%M:%SZ`, `printf` y `shasum -a 256` como alternativa.
3. **El dialecto de Make.** Solo si tu Makefile tiene que correr con BSD make o con un make POSIX.

| Construcción | GNU 3.81 (macOS) | GNU 4.3 | POSIX 2024 | bmake 20200710 (Debian 13) |
|---|:--:|:--:|:--:|:--:|
| `.SHELLFLAGS`, `.ONESHELL` | ✗ | ✓ | ✗ | ✗ |
| `$(file <f)` | ✗ | ✓ | ✗ | ✗ |
| `?=`, `+=`, `-include`, `.PHONY` | ✓ | ✓ | ✓ | ✓ |
| `!=` | ✗ | ✓ | ✓ | ✓ |
| `::=` | ✗ | ✓ | ✓ | ✗ |
| `$^` | ✓ | ✓ | ✓ | ✗ (usa `$>`) |
| `:=` | ✓ | ✓ | ✗ | ✓, con otra semántica |
| `ifeq`, `$(shell)`, `$(wildcard)`, reglas `%` | ✓ | ✓ | ✗ | ✗ (tiene `.if` y `:sh` propios) |
| Reglas de sufijo `.c.o:` | ✓ | ✓ | ✓ | ✓ |

`.POSIX:` como primera línea no convierte a GNU Make en un make estricto: sigue aceptando extensiones. Lo que hace es adoptar el comportamiento POSIX donde difiere, por ejemplo ejecutar cada receta como con `sh -e`. Para probar portabilidad de verdad, ejecuta el Makefile con bmake.

## Ejemplo mínimo funcional

```makefile
MIN_MAKE_VERSION := 4.3
ifneq ($(MIN_MAKE_VERSION),$(firstword $(sort $(MAKE_VERSION) $(MIN_MAKE_VERSION))))
  $(error Se requiere GNU Make >= $(MIN_MAKE_VERSION); tienes $(MAKE_VERSION))
endif

SHELL       := bash
.SHELLFLAGS := -eu -o pipefail -c
.PHONY: all check

all: out.txt
out.txt:
	printf 'hola\n' > $@

check:
	@out=$$($(MAKE) -s --warn-undefined-variables -n -B all 2>&1) && ! grep 'undefined variable' <<<"$$out"
	@$(MAKE) -s all && $(MAKE) -q out.txt
	@echo "check: OK, output-sync $(if $(filter output-sync,$(.FEATURES)),disponible,no disponible)"
```

```bash
make check                      # check: OK, output-sync disponible
make check MIN_MAKE_VERSION=9.9 # Se requiere GNU Make >= 9.9; tienes 4.3
```

`$(sort)` compara texto: la guarda fallaría con una hipotética versión 4.10.

---

Listo. Ve al [lab-04](../2-practicas/lab-04-testing-de-makefiles/README.md) y al [lab-05](../2-practicas/lab-05-portabilidad/README.md) y ponlo en práctica.
