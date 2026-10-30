# Semana 10 — Paralelismo y recursión

## Descripción

`make -j` divide el tiempo de build por el número de núcleos, siempre que el Makefile diga la verdad sobre sus dependencias. Esta semana aprenderás a paralelizar con seguridad: destapar las carreras que `-j` hace visibles, leer la salida de un build paralelo y coordinar sub-makes que comparten un único jobserver y no se tragan los fallos. Terminarás con un monorepo cuyo build raíz es paralelo, propaga errores y respeta las dependencias entre paquetes.

## Objetivos de aprendizaje

Al terminar esta semana, podrás:

- Medir el paralelismo real de un build contando recetas simultáneas, no solo con `time`
- Diagnosticar y corregir carreras causadas por dependencias no declaradas, con `-j` repetido o `--shuffle` (Make 4.4+)
- Ordenar pasos sin dependencias falsas con sub-makes en secuencia o `.WAIT` (Make 4.4+)
- Agrupar la salida paralela con `--output-sync` y elegir el modo según el contexto
- Escribir recursión con subdirectorios como targets phony que propaga fallos y funciona con `-j` y `-k`
- Explicar por qué los sub-makes se lanzan con `$(MAKE)` (jobserver, `-n`, binario) y cuándo hace falta el prefijo `+`
- Decidir qué variables llegan a un sub-make (línea de comandos, `export VAR`) y cuáles no
- Construir un build no recursivo que incluye un `module.mk` por directorio

## Prerrequisitos

- Semanas 01–09 completadas; en especial el modo estricto (semana 03), las variables automáticas `$(@D)` y `$(@F)` (semana 04) e `include` (semana 09)
- GNU Make ≥ 4.3 (`make --version`; en macOS `gmake`). Las secciones marcadas **Make 4.4+** traen su alternativa para 4.3
- `cc` (gcc o clang) para el lab-06

## Contenido

| # | Tipo | Tema | Tiempo |
|---|------|------|--------|
| — | Teoría | [01-paralelismo.md](1-teoria/01-paralelismo.md) y [02-recursion.md](1-teoria/02-recursion.md) | 45 min |
| — | Conocimiento | [10 preguntas](rubrica-evaluacion.md#-conocimiento-30) | 15 min |
| 1 | Lab | [lab-01-jobs-paralelos](2-practicas/lab-01-jobs-paralelos/) | 60 min |
| 2 | Lab | [lab-02-carrera-roto](2-practicas/lab-02-carrera-roto/) | 60 min |
| 3 | Lab | [lab-03-output-sync](2-practicas/lab-03-output-sync/) | 60 min |
| 4 | Lab | [lab-04-recursion](2-practicas/lab-04-recursion/) | 60 min |
| 5 | Lab | [lab-05-jobserver](2-practicas/lab-05-jobserver/) | 60 min |
| 6 | Lab | [lab-06-no-recursivo](2-practicas/lab-06-no-recursivo/) | 60 min |
| — | Proyecto | [Monorepo con build paralelo y recursión segura](3-proyecto/) | 3 h |

**Total: 10 horas**

Material de apoyo: [diagramas](0-assets/), [recursos](4-recursos/) y [glosario](5-glosario/README.md).

## Distribución del tiempo

```
[45 min] Leer 1-teoria/ (paralelismo y recursión)
[15 min] Responder las 10 preguntas de Conocimiento
[60 min] lab-01 — -j: cuántas tareas a la vez
[60 min] lab-02 — Carreras en paralelo (Makefile roto)
[60 min] lab-03 — Salida legible con -O
[60 min] lab-04 — Recursión que no se traga los fallos
[60 min] lab-05 — $(MAKE) y el jobserver
[60 min] lab-06 — Make no recursivo
[3 h]    Proyecto: monorepo con build paralelo y recursión segura
```

## Verificación de completitud

Desde la raíz del repositorio:

```bash
./scripts/verificar-semana.sh 10
```

Comprueba las 15 condiciones del proyecto (build paralelo real, dependencias respetadas con `-j8`, fallos que se propagan, `$(MAKE)` en lugar de `make`, salida agrupada, `clean` con guarda...). Tarda alrededor de medio minuto, porque construye el monorepo varias veces desde cero.

## 🔗 Navegación

| Anterior | Actual | Siguiente |
|---|---|---|
| [Semana 09 — Condicionales, include y depuración](../week-09-condicionales_include_y_depuracion/README.md) | **Semana 10 — Paralelismo y recursión** | [Semana 11 — Makefiles para proyectos modernos](../week-11-makefiles_para_proyectos_modernos/README.md) |

[← Volver al índice del bootcamp](../README.md)
