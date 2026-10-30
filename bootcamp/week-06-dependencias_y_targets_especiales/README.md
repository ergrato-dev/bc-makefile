# Semana 06 — Dependencias automáticas y targets especiales

## Descripción

Un build incremental solo sirve si confías en él. Esta semana cierras los huecos
por los que Make recompila de menos (headers, flags, código generado) o de más
(directorios de salida), y aprendes los targets especiales que deciden qué
archivos generados conserva Make. Terminas con un build C multi-directorio que
hace exactamente el trabajo necesario, también con `make -j8`.

## Objetivos de aprendizaje

Al terminar esta semana, podrás:

- Leer un archivo `.d` y explicar qué aportan `-MMD` y `-MP` por separado
- Separar `CPPFLAGS`, `CFLAGS` y `DEPFLAGS`, y recompilar al cambiar flags con un stamp
- Declarar directorios de salida como prerrequisitos order-only con `|` y `$$(@D)` bajo `.SECONDEXPANSION`
- Compilar fuentes repartidos en varios directorios con `vpath`, y evitar sus trampas
- Ejecutar un generador de varios archivos una sola vez con un grouped target `&:`
- Elegir entre `.SECONDARY`, `.PRECIOUS`, `.INTERMEDIATE` y `.NOTINTERMEDIATE` según el efecto buscado
- Depurar builds que recompilan de más, de menos o fallan solo con `-j`

## Prerrequisitos

- Semanas 01–05 completadas (en especial: variables automáticas de la 04 y reglas de patrón de la 05)
- GNU Make ≥ 4.3 (`make --version`; en macOS `gmake`). `.NOTINTERMEDIATE` necesita 4.4 y tiene alternativa 4.3
- `gcc` y `bash`

## Contenido

| # | Tipo | Tema | Tiempo |
|---|------|------|--------|
| — | Teoría | [01-dependencias-automaticas.md](1-teoria/01-dependencias-automaticas.md) | 15 min |
| — | Teoría | [02-order-only-y-vpath.md](1-teoria/02-order-only-y-vpath.md) | 15 min |
| — | Teoría | [03-grouped-e-intermedios.md](1-teoria/03-grouped-e-intermedios.md) | 15 min |
| — | Conocimiento | [10 preguntas](rubrica-evaluacion.md#-conocimiento-30) | 15 min |
| 1 | Lab | [lab-01-anatomia-del-d](2-practicas/lab-01-anatomia-del-d/README.md) | 60 min |
| 2 | Lab | [lab-02-order-only](2-practicas/lab-02-order-only/README.md) | 60 min |
| 3 | Lab | [lab-03-vpath](2-practicas/lab-03-vpath/README.md) | 60 min |
| 4 | Lab | [lab-04-grouped-targets](2-practicas/lab-04-grouped-targets/README.md) | 60 min |
| 5 | Lab | [lab-05-intermedios-y-precious](2-practicas/lab-05-intermedios-y-precious/README.md) | 60 min |
| 6 | Lab | [lab-06-dependencias-rotas](2-practicas/lab-06-dependencias-rotas/README.md) | 60 min |
| — | Proyecto | [Build C con dependencias de headers exactas](3-proyecto/README.md) | 3 h |

**Total: 10 horas**

Material de apoyo: [diagramas](0-assets/), [recursos](4-recursos/) y [glosario](5-glosario/README.md).

## Distribución del tiempo

```
[45 min] Leer 1-teoria/ (tres archivos de 15 min)
[15 min] Responder las 10 preguntas de Conocimiento
[60 min] lab-01 — Anatomía del .d: -MMD, -MP, CPPFLAGS, stamp de flags, .EXTRA_PREREQS
[60 min] lab-02 — Order-only y .SECONDEXPANSION para directorios de salida
[60 min] lab-03 — vpath: fuentes repartidos y sus dos trampas
[60 min] lab-04 — Grouped targets: un generador, dos archivos, make -j
[60 min] lab-05 — Intermedios: .SECONDARY, .PRECIOUS, .INTERMEDIATE, .NOTINTERMEDIATE
[60 min] lab-06 — Depurar cinco bugs de dependencias
[3 h]    Proyecto: build C con dependencias de headers exactas
```

## Verificación de completitud

Desde la raíz del repositorio:

```bash
./scripts/verificar-semana.sh 06
```

Comprueba tu proyecto (`3-proyecto/starter/`) contra las 15 comprobaciones de
[`checks.json`](checks.json). Tienen que pasar todas; el resto de la nota está en
la [rúbrica](rubrica-evaluacion.md).

## 🔗 Navegación

| Anterior | Actual | Siguiente |
|---|---|---|
| [Semana 05 — Reglas de patrón](../week-05-reglas_de_patron/README.md) | **Semana 06 — Dependencias automáticas y targets especiales** | [Semana 07 — Funciones de texto y archivo](../week-07-funciones_de_texto_y_archivo/README.md) |

[← Volver al índice del bootcamp](../README.md)
