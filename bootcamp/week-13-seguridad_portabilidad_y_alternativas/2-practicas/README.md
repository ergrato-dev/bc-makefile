# Labs — Semana 13: Seguridad, portabilidad y alternativas

| # | Lab | Objetivo | Duración |
|---|-----|----------|----------|
| 01 | [lab-01-parse-time-vs-run-time](lab-01-parse-time-vs-run-time/README.md) | Eliminar lo que el Makefile ejecuta al cargarse, incluido un `.env` malicioso | ~60 min |
| 02 | [lab-02-inyeccion-rota](lab-02-inyeccion-rota/README.md) | Explotar y corregir cinco inyecciones con validación, paso por entorno y citado seguro | ~60 min |
| 03 | [lab-03-secretos-y-descargas](lab-03-secretos-y-descargas/README.md) | Cerrar las fugas de un token y sustituir `curl \| sh` por una descarga verificada | ~60 min |
| 04 | [lab-04-testing-de-makefiles](lab-04-testing-de-makefiles/README.md) | Escribir un target `check` que pruebe el Makefile y arreglar lo que encuentre | ~60 min |
| 05 | [lab-05-portabilidad](lab-05-portabilidad/README.md) | Guarda de versión, comandos portables y un Makefile POSIX que acepta bmake | ~60 min |
| 06 | [lab-06-alternativas-a-make](lab-06-alternativas-a-make/README.md) | Traducir un Makefile a just y Task y decidir la herramienta para seis escenarios | ~60 min |

Reglas para todos los labs de esta semana:

- Los payloads de ataque son siempre `touch` de un archivo testigo. Nunca pruebes una inyección con `rm`.
- Lo destructivo (`clean` con rutas raras) se prueba **solo con `make -n`**.
- Ningún lab necesita red, Docker, just ni Task. Los retos extra que los usan son opcionales.
