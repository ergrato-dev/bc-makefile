# Labs — Semana 09: Condicionales, include y depuración

Seis labs de ~60 min. Cada uno se hace sobre una copia del `starter/`
(`cp -r starter/ mi-lab-NN`) y se comprueba con sus criterios de éxito.

| # | Lab | Objetivo | Duración |
|---|-----|----------|----------|
| 01 | [lab-01-condicionales](./lab-01-condicionales/README.md) | Adaptar un Makefile a tres entornos y a CI con `ifeq`, `ifdef` y `$(error)`, y depurar un condicional que falla en silencio | 60 min |
| 02 | [lab-02-include-modular](./lab-02-include-modular/README.md) | Separar un Makefile en módulos `.mk` y generar uno con una regla que Make rehace antes de leerlo | 60 min |
| 03 | [lab-03-depuracion](./lab-03-depuracion/README.md) | Diagnosticar con `$(info)`, `$(warning)`, `$(error)`, `-n` y `--debug`, y encontrar un bug sin mensaje de error | 60 min |
| 04 | [lab-04-scope-variables](./lab-04-scope-variables/README.md) | Controlar qué variables recibe un sub-make con paso explícito, `export`, `unexport` y `override` | 60 min |
| 05 | [lab-05-portabilidad-y-diagnostico](./lab-05-portabilidad-y-diagnostico/README.md) | Guarda de versión mínima, `.FEATURES`, `--trace`, `--warn-undefined-variables`, `MAKECMDGOALS` y `make -p` | 60 min |
| 06 | [lab-06-makefile-roto](./lab-06-makefile-roto/README.md) | Reparar un Makefile heredado con seis errores que Make reporta y dos que no | 60 min |

**Total: 6 h**
