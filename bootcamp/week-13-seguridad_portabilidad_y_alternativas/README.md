# Semana 13 — Seguridad, portabilidad y alternativas

## Descripción

Un Makefile ejecuta comandos con tus permisos, en tu portátil y en el CI donde viven los tokens, y casi nadie lo revisa como código. Esta semana lo atacas tú mismo, con payloads inofensivos: `$(shell)` que corre al parsear, variables que inyectan comandos, secretos que acaban en `ps` y `curl | sh`. Después lo pruebas como cualquier otro código, lo haces portable a otros make y decides con criterio cuándo just, Task, CMake o Bazel son mejor opción.

## Objetivos de aprendizaje

Al terminar esta semana, podrás:

- Distinguir qué ejecuta Make al parsear, qué ejecuta con `make -n` y qué no, y sacar los efectos secundarios de la fase de lectura
- Validar un `.env` con lista blanca antes de incluirlo
- Neutralizar inyecciones con validación, paso por entorno (`"$$VAR"`), `$(value)` y citado seguro
- Mantener un token fuera de `ps`, `make -n`, los logs y los subprocesos que no lo necesitan (`unexport`, `export` por target, `umask 077`)
- Sustituir `curl | sh` por una descarga verificada con SHA-256
- Escribir un target `check` que pruebe el Makefile con `--warn-undefined-variables`, `-n`, `-q` y builds aislados
- Proteger un Makefile frente a versiones antiguas de Make y a comandos no portables, y escribir make POSIX que acepte bmake
- Elegir entre Make, just, Task, CMake + Ninja y Bazel con una tabla de decisión

## Prerrequisitos

- Semanas 01–12 completadas (en especial la 03, modo estricto, y la 12, `.env` y secretos)
- GNU Make ≥ 4.3 (`make --version`; en macOS `gmake`)
- bash, curl y coreutils
- Opcional: Docker, para probar Make 4.4 (`--shuffle`), Make 3.81 o bmake en los retos extra

## Contenido

| # | Tipo | Tema | Tiempo |
|---|------|------|--------|
| — | Teoría | [01-modelo-de-amenazas.md](1-teoria/01-modelo-de-amenazas.md) · [02-testing-y-portabilidad.md](1-teoria/02-testing-y-portabilidad.md) · [03-alternativas.md](1-teoria/03-alternativas.md) | 45 min |
| — | Conocimiento | [10 preguntas](rubrica-evaluacion.md#-conocimiento-30) | 15 min |
| 1 | Lab | [lab-01-parse-time-vs-run-time](2-practicas/lab-01-parse-time-vs-run-time/README.md) | 60 min |
| 2 | Lab | [lab-02-inyeccion-rota](2-practicas/lab-02-inyeccion-rota/README.md) | 60 min |
| 3 | Lab | [lab-03-secretos-y-descargas](2-practicas/lab-03-secretos-y-descargas/README.md) | 60 min |
| 4 | Lab | [lab-04-testing-de-makefiles](2-practicas/lab-04-testing-de-makefiles/README.md) | 60 min |
| 5 | Lab | [lab-05-portabilidad](2-practicas/lab-05-portabilidad/README.md) | 60 min |
| 6 | Lab | [lab-06-alternativas-a-make](2-practicas/lab-06-alternativas-a-make/README.md) | 60 min |
| — | Proyecto | [Auditoría y endurecimiento de un Makefile real](3-proyecto/README.md) | 3 h |

**Total: 10 horas**

Material de apoyo: [diagramas](0-assets/01-superficie-de-ataque.md), [recursos](4-recursos/webgrafia/README.md) y [glosario](5-glosario/README.md).

## Distribución del tiempo

```
[45 min] Leer 1-teoria/ (amenazas 20 · testing y portabilidad 15 · alternativas 10)
[15 min] Responder las 10 preguntas de Conocimiento
[60 min] lab-01 — Parse-time vs run-time y .env malicioso
[60 min] lab-02 — Cinco inyecciones y rm -rf con guardas (lab roto)
[60 min] lab-03 — Secretos sin fugas y descargas verificadas
[60 min] lab-04 — Un target check que prueba el Makefile
[60 min] lab-05 — Guarda de versión, comandos portables y make POSIX
[60 min] lab-06 — Traducir a just y Task, y decidir
[3 h]    Proyecto: auditoría y endurecimiento del Makefile de notify
```

## Verificación de completitud

Desde la raíz del repositorio:

```bash
./scripts/verificar-semana.sh 13
```

Las 17 comprobaciones usan payloads inofensivos (un `touch` en una carpeta
temporal) y prueban `clean` solo con `make -n`.

## 🔗 Navegación

| Anterior | Actual | Siguiente |
|---|---|---|
| [Semana 12 — Make como orquestador DevOps](../week-12-make_como_orquestador_devops/README.md) | **Semana 13 — Seguridad, portabilidad y alternativas** | [Semana 14 — Proyecto integrador](../week-14-proyecto_integrador/README.md) |

[← Volver al índice del bootcamp](../README.md)
