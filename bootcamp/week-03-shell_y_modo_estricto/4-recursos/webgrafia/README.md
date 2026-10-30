# Webgrafía — Semana 03

| Recurso | Descripción |
|---------|-------------|
| [GNU Make Manual: Using One Shell](https://www.gnu.org/software/make/manual/html_node/One-Shell.html) | Referencia oficial de `.ONESHELL`, sus advertencias y el tratamiento de los prefijos `@ - +` |
| [GNU Make Manual: Errors in Recipes](https://www.gnu.org/software/make/manual/html_node/Errors.html) | Qué hace Make cuando una receta falla, el prefijo `-`, `-k`, `-i` y `.DELETE_ON_ERROR` |
| [Your Makefiles are wrong (Jacob Davis-Hansson)](https://tech.davis-hansson.com/p/make/) | El artículo que popularizó el preámbulo `SHELL := bash` + `.SHELLFLAGS := -eu -o pipefail -c` + `.DELETE_ON_ERROR` |
| [Most Makefiles Should .DELETE_ON_ERROR (Innolitics)](https://innolitics.com/articles/make-delete-on-error/) | Caso práctico de un archivo a medio escribir que Make da por bueno, y cómo lo evita `.DELETE_ON_ERROR` |
| [BashFAQ/105: Why doesn't set -e do what I expected?](https://mywiki.wooledge.org/BashFAQ/105) | Los límites de `-e` (condiciones, sustituciones de comando, tuberías): por qué no basta solo |
