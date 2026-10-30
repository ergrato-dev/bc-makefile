# Semana 03 — Shell en recetas y modo estricto

## Descripción

Make no ejecuta tus recetas: se las pasa a un shell, una línea cada vez, y por defecto solo se entera de un fallo si es el último comando de la línea. Esta semana aprenderás quién ejecuta qué, por qué un Makefile que funciona en tu máquina falla en CI, y cómo convertir los fallos silenciosos en errores ruidosos. Sales con el preámbulo estricto y las guardas de `rm -rf` que usan todos los Makefiles del bootcamp desde la Semana 04.

## Objetivos de aprendizaje

Al terminar esta semana, podrás:

- Explicar por qué cada línea de receta corre en un shell nuevo y encadenar comandos con `&&` y `\`
- Escapar `$$` para el shell y distinguir lo que expande Make de lo que expande el shell
- Fijar `SHELL := bash` y justificar por qué dash rompe `[[ ]]`, `{a,b}` y `pipefail`
- Escribir el preámbulo estricto `SHELL` + `.SHELLFLAGS := -eu -o pipefail -c` + `.DELETE_ON_ERROR:` y explicar cada pieza
- Adaptar tuberías a `pipefail`: validaciones que cortan el flujo, `grep` sin coincidencias, SIGPIPE de `head`
- Decidir cuándo usar el prefijo `-`, `make -k`, `make -i`, `make -n` y el prefijo `+`, y cuándo nunca
- Proteger un `clean` con comillas, `--` y guardas de Make contra variables vacías y rutas fuera del proyecto
- Evaluar los riesgos de `.ONESHELL` antes de activarlo

## Prerrequisitos

- Semanas 01 y 02 completadas: targets, `.PHONY`, `help`, variables `:=` `?=` y override desde la línea de comandos
- GNU Make ≥ 4.3 (`make --version`; en macOS `gmake`)
- bash, coreutils, `awk` y `tar` (vienen con cualquier Linux o macOS)
- Recomendado: `dash` para reproducir el `/bin/sh` de Debian/Ubuntu (en macOS ya está en `/bin/dash`)

## Contenido

| # | Tipo | Tema | Tiempo |
|---|------|------|--------|
| — | Teoría | [01-shell-en-recetas.md](1-teoria/01-shell-en-recetas.md) | 25 min |
| — | Teoría | [02-modo-estricto.md](1-teoria/02-modo-estricto.md) | 20 min |
| — | Conocimiento | [10 preguntas](rubrica-evaluacion.md#-conocimiento-30) | 15 min |
| 1 | Lab | [lab-01-cada-linea-un-shell](2-practicas/lab-01-cada-linea-un-shell/) | 60 min |
| 2 | Lab | [lab-02-bash-vs-sh](2-practicas/lab-02-bash-vs-sh/) | 60 min |
| 3 | Lab | [lab-03-pipefail](2-practicas/lab-03-pipefail/) | 60 min |
| 4 | Lab | [lab-04-delete-on-error](2-practicas/lab-04-delete-on-error/) | 60 min |
| 5 | Lab | [lab-05-guardas-rm](2-practicas/lab-05-guardas-rm/) | 60 min |
| 6 | Lab | [lab-06-shell-roto](2-practicas/lab-06-shell-roto/) | 60 min |
| — | Proyecto | [Reportes de accesos a prueba de fallos](3-proyecto/) | 3 h |

**Total: 10 horas**

Material de apoyo: [diagramas](0-assets/), [recursos](4-recursos/) y [glosario](5-glosario/README.md).

## Distribución del tiempo

```
[25 min] Leer 1-teoria/01-shell-en-recetas.md
[20 min] Leer 1-teoria/02-modo-estricto.md
[15 min] Responder las 10 preguntas de Conocimiento
[60 min] lab-01 — Cada línea, un shell nuevo: cd, variables, $$ y .ONESHELL
[60 min] lab-02 — bash frente a /bin/sh, y .SHELLFLAGS
[60 min] lab-03 — pipefail: tuberías que no esconden fallos
[60 min] lab-04 — .DELETE_ON_ERROR, el prefijo -, make -k y make -i
[60 min] lab-05 — Guardas para rm -rf, make -n y el prefijo +
[60 min] lab-06 — Shell roto: siete fallos a partir de sus síntomas
[3 h]    Proyecto: reportes de accesos a prueba de fallos
```

## Verificación de completitud

Desde la raíz del repositorio, `./scripts/verificar-semana.sh 03` comprueba tu proyecto (`3-proyecto/starter/`) contra los 16 requisitos verificables de la semana:

```bash
./scripts/verificar-semana.sh 03
```

Al terminar, estos comandos deben comportarse así dentro de `3-proyecto/starter/`:

```bash
make                                          # muestra la ayuda
make report && cat build/summary.txt          # Total de peticiones: 40
make -B build/status.txt LOG=data/corrupt.csv # falla y borra build/status.txt
make -n clean BUILD_DIR=                      # *** BUILD_DIR vacía: rm -rf no se ejecuta.  Stop.
make clean
```

## 🔗 Navegación

| Anterior | Actual | Siguiente |
|---|---|---|
| [Semana 02 — Variables y expansión](../week-02-variables_y_expansion/README.md) | **Semana 03 — Shell en recetas y modo estricto** | [Semana 04 — Variables automáticas](../week-04-variables_automaticas/README.md) |

[← Volver al índice del bootcamp](../README.md)
