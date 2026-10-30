# Semana 04 — Variables automáticas

## Descripción

Las variables automáticas son la razón por la que una sola regla de patrón puede compilar cien archivos distintos. En lugar de escribir el nombre del target o de los prerrequisitos en la receta, Make los inyecta en variables como `$@`, `$<` y `$^` en el momento de ejecución. Esta semana dominarás las seis más importantes y las usarás para construir un build system C real sin repetir un solo nombre de archivo.

## Objetivos de aprendizaje

Al terminar esta semana, podrás:

- Usar `$@` para referenciar el nombre del target dentro de su propia receta
- Usar `$<` para pasar el primer prerrequisito a un compilador
- Usar `$^` para pasar todos los prerrequisitos a un linker (sin duplicados) y `$+` cuando importan las repeticiones
- Usar `$?` para reprocesar solo los prerrequisitos modificados desde el último build
- Usar `$*` para extraer el stem en reglas de patrón `%.o: %.c`
- Usar `$(@D)`, `$(@F)`, `$(<D)` y `$(<F)` para construir rutas de salida en subdirectorios dinámicamente
- Escribir una regla genérica que compile cualquier `.c` a `.o` sin escribir nombres de archivo, con dependencias de headers generadas por `-MMD -MP`

## Prerrequisitos

- Semana 01: targets, dependencias, `.PHONY`, target `help`
- Semana 02: variables `=`, `:=`, `?=`, `+=` y `$(origin)`
- Semana 03: preámbulo estricto (`SHELL := bash`, `.SHELLFLAGS := -eu -o pipefail -c`, `.DELETE_ON_ERROR:`) y guardas de `rm -rf`; todas las soluciones de esta semana los usan
- GNU Make ≥ 4.3 (`make --version`; en macOS `gmake`)
- `gcc` (`gcc --version`) para el lab 02 y el proyecto; `tar` para `make dist`

## Contenido

| # | Tipo | Tema | Tiempo |
|---|------|------|--------|
| — | Teoría | [01-contexto.md](1-teoria/01-contexto.md) | 45 min |
| — | Conocimiento | [10 preguntas](rubrica-evaluacion.md#-conocimiento-30) | 15 min |
| 1 | Lab | [lab-01-target-nombre](2-practicas/lab-01-target-nombre/) | 60 min |
| 2 | Lab | [lab-02-primer-prerrequisito](2-practicas/lab-02-primer-prerrequisito/) | 60 min |
| 3 | Lab | [lab-03-todos-prerrequisitos](2-practicas/lab-03-todos-prerrequisitos/) | 60 min |
| 4 | Lab | [lab-04-stem-en-patrones](2-practicas/lab-04-stem-en-patrones/) | 60 min |
| 5 | Lab | [lab-05-rutas-dinamicas](2-practicas/lab-05-rutas-dinamicas/) | 60 min |
| 6 | Lab | [lab-06-variables-rotas](2-practicas/lab-06-variables-rotas/) | 60 min |
| — | Proyecto | [Build system C multi-archivo](3-proyecto/) | 3 h |

**Total: 10 horas**

## Distribución del tiempo

```
[45 min] Leer 1-teoria/01-contexto.md (incluida la sección Headers: -MMD -MP)
[15 min] Responder las 10 preguntas de Conocimiento
[60 min] lab-01 — $@: el target se conoce a sí mismo
[60 min] lab-02 — $<: el primer prerrequisito, y compilar de verdad
[60 min] lab-03 — $^, $+ y $?: todos, con duplicados o los modificados
[60 min] lab-04 — $*: el stem en reglas de patrón
[60 min] lab-05 — $(@D), $(@F), $(<D) y $(<F): rutas dinámicas
[60 min] lab-06 — Depurar cinco bugs con variables automáticas
[3 h]    Proyecto: build system C multi-archivo con reglas genéricas y empaquetado
```

## Verificación de completitud

Desde la raíz del repositorio:

```bash
./scripts/verificar-semana.sh 04
```

Comprueba tu proyecto (`3-proyecto/starter/`) contra los 14 requisitos
verificables de la semana. Al terminar deben pasar todos, y dentro de tu
proyecto:

```bash
make all && ./build/app
make dist && tar -tzf dist/app-1.0.0.tar.gz
make clean
```

El binario `build/app` debe producir:

```
Hola desde Make!
suma(3, 4) = 7
producto(3, 4) = 12
```

## 🔗 Navegación

| Anterior | Actual | Siguiente |
|---|---|---|
| [Semana 03 — Shell en recetas y modo estricto](../week-03-shell_y_modo_estricto/README.md) | **Semana 04 — Variables automáticas** | [Semana 05 — Reglas de patrón](../week-05-reglas_de_patron/README.md) |

[← Volver al índice del bootcamp](../README.md)
