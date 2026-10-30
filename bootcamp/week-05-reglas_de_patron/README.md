# Semana 05 — Reglas de patrón

## Descripción

Una regla de patrón reemplaza docenas de reglas repetitivas con una sola línea: `%.o: %.c`. Make evalúa el `%` como un comodín llamado stem, y aplica la misma receta a todos los archivos que coincidan. Esta semana dominarás reglas de patrón simples, con prefijos de directorio, y static pattern rules, para construir un compilador genérico para proyectos C que escale sin modificaciones.

## Objetivos de aprendizaje

Al terminar esta semana, podrás:

- Escribir una regla de patrón `%.ext1: %.ext2` y entender cómo Make resuelve el stem `%`
- Usar reglas de patrón con prefijos de directorio (`build/%.o: src/%.c`)
- Distinguir entre reglas de patrón genéricas y static pattern rules
- Aplicar static pattern rules para restringir un patrón a un subconjunto específico de targets
- Predecir qué regla elige Make: receta explícita, stem más corto, orden del Makefile y reglas de serie
- Desactivar las reglas implícitas de serie con `-r` / `MAKEFLAGS += -r` e inspeccionarlas con `make -p`
- Depurar errores comunes en reglas de patrón (`No rule to make target`)
- Construir un Makefile que compile cualquier proyecto C multi-módulo sin mencionar archivos por nombre

## Prerrequisitos

- Semana 01 completada: targets, dependencias, `.PHONY`, target `help`
- Semana 02 completada: variables `=`, `:=`, `?=`, `+=`
- Semana 04 completada: variables automáticas `$@`, `$<`, `$^`, `$*`, `$(@D)`
- GNU Make ≥ 4.3 instalado (`make --version`; en macOS `gmake`)
- `gcc` y `ar` instalados — requeridos para los labs 01, 02, 04, 05 y el proyecto (`gcc --version`)

## Contenido

| # | Tipo | Tema | Tiempo |
|---|------|------|--------|
| — | Teoría | [01-contexto.md](1-teoria/01-contexto.md) · [02-reglas-implicitas.md](1-teoria/02-reglas-implicitas.md) | 45 min |
| — | Conocimiento | [10 preguntas](rubrica-evaluacion.md#-conocimiento-30) | 15 min |
| 1 | Lab | [lab-01-patron-basico](2-practicas/lab-01-patron-basico/) | 60 min |
| 2 | Lab | [lab-02-directorio-salida](2-practicas/lab-02-directorio-salida/) | 60 min |
| 3 | Lab | [lab-03-multiples-patrones](2-practicas/lab-03-multiples-patrones/) | 60 min |
| 4 | Lab | [lab-04-static-pattern](2-practicas/lab-04-static-pattern/) | 60 min |
| 5 | Lab | [lab-05-prioridad](2-practicas/lab-05-prioridad/) | 60 min |
| 6 | Lab | [lab-06-patrones-rotos](2-practicas/lab-06-patrones-rotos/) | 60 min |
| — | Proyecto | [Compilador genérico para proyectos C](3-proyecto/) | 3 h |

**Total: 10 horas**

Apoyo: [diagramas](0-assets/) · [recursos](4-recursos/) · [glosario](5-glosario/README.md)

## Distribución del tiempo

```
[45 min] Leer 1-teoria/ (01-contexto y 02-reglas-implicitas)
[15 min] Responder las 10 preguntas de Conocimiento
[60 min] lab-01 — %.o: %.c: la mecánica del stem y la incrementalidad
[60 min] lab-02 — build/%.o: src/%.c: patrón con directorios y subdirectorios
[60 min] lab-03 — varias reglas de patrón: prerrequisito, orden y encadenamiento
[60 min] lab-04 — static pattern rules: flags por grupo y librería estática
[60 min] lab-05 — cómo elige Make una regla y MAKEFLAGS += -r
[60 min] lab-06 — depurar seis errores en reglas de patrón
[3 h]    Proyecto: compilador genérico C con pattern rules, tests y ensamblador
```

## Verificación de completitud

Desde la raíz del repositorio:

```bash
./scripts/verificar-semana.sh 05
```

Comprueba tu proyecto (`3-proyecto/starter/`) contra las 15 comprobaciones de [`checks.json`](checks.json). Cada fallo trae una pista con el lab y el paso donde se arregla.

## 🔗 Navegación

| Anterior | Actual | Siguiente |
|---|---|---|
| [Semana 04 — Variables automáticas](../week-04-variables_automaticas/README.md) | **Semana 05 — Reglas de patrón** | [Semana 06 — Dependencias automáticas y targets especiales](../week-06-dependencias_y_targets_especiales/README.md) |

[← Volver al índice del bootcamp](../README.md)
