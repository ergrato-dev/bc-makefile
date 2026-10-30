# Labs — Semana 10: Paralelismo y recursión

| # | Lab | Objetivo | Duración |
|---|-----|----------|----------|
| 01 | [lab-01-jobs-paralelos](lab-01-jobs-paralelos/) | Medir el efecto de `-j` contando cuántas recetas corren a la vez; frenar con `.NOTPARALLEL` | ~60 min |
| 02 | [lab-02-carrera-roto](lab-02-carrera-roto/) | Destapar y corregir cuatro carreras por dependencias no declaradas (Makefile roto) | ~60 min |
| 03 | [lab-03-output-sync](lab-03-output-sync/) | Agrupar la salida de un build paralelo con `-O` y elegir el modo | ~60 min |
| 04 | [lab-04-recursion](lab-04-recursion/) | Recursión con subdirectorios como targets phony: fallos que se propagan, `-k` y variables a sub-makes | ~60 min |
| 05 | [lab-05-jobserver](lab-05-jobserver/) | Demostrar por qué `$(MAKE)` y no `make`: jobserver, `-n`, prefijo `+` y `MAKEFLAGS` | ~60 min |
| 06 | [lab-06-no-recursivo](lab-06-no-recursivo/) | Un solo grafo con un `module.mk` por directorio, sin sub-makes | ~60 min |

El lab-02 es de depuración: su starter está roto a propósito.
