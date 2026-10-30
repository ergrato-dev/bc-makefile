# Labs — Semana 03: Shell en recetas y modo estricto

| # | Lab | Objetivo | Duración |
|---|-----|----------|----------|
| 01 | [lab-01-cada-linea-un-shell](lab-01-cada-linea-un-shell/) | Corregir recetas que pierden `cd` y variables entre líneas, usar `$$` y probar la trampa de `.ONESHELL` | ~60 min |
| 02 | [lab-02-bash-vs-sh](lab-02-bash-vs-sh/) | Ver qué rompe dash y fijar `SHELL := bash` y `.SHELLFLAGS := -eu -o pipefail -c` | ~60 min |
| 03 | [lab-03-pipefail](lab-03-pipefail/) | Hacer que un fallo en mitad de una tubería detenga el build, sin romper `grep` ni `head` | ~60 min |
| 04 | [lab-04-delete-on-error](lab-04-delete-on-error/) | Impedir que un archivo a medio escribir pase por "al día", y usar bien `-`, `make -k` y `make -i` | ~60 min |
| 05 | [lab-05-guardas-rm](lab-05-guardas-rm/) | Blindar `clean` con comillas, `--` y dos guardas de Make, y revisar con `make -n` | ~60 min |
| 06 | [lab-06-shell-roto](lab-06-shell-roto/) | Diagnosticar y corregir siete fallos de shell y modo estricto a partir de sus síntomas | ~60 min |

Los labs 01 a 05 se hacen en orden: cada uno añade una pieza del preámbulo estricto. El lab 06 las usa todas.

[← Volver a la Semana 03](../README.md)
