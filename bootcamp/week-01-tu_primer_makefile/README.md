# Semana 01 — Tu primer Makefile

## Descripción

Aprenderás la anatomía de un Makefile desde cero: cómo se definen targets, dependencias y recetas, y por qué Make solo ejecuta lo que necesita. Esta semana establece la base sobre la que se construye todo el bootcamp.

## Objetivos de aprendizaje

Al terminar esta semana, podrás:

- Verificar que usas GNU Make ≥ 4.3 e instalarlo en Linux, macOS (`gmake`) o WSL2
- Escribir un Makefile con targets, dependencias y recetas correctamente indentadas con TAB
- Identificar y corregir los errores más comunes (espacios en lugar de TABs, dependencias circulares o faltantes)
- Declarar targets `.PHONY` y explicar por qué son necesarios
- Construir cadenas de dependencias entre targets y entre archivos
- Distinguir targets que producen archivos de targets que ejecutan acciones
- Implementar el patrón `help` estándar con documentación inline

## Prerrequisitos

- Terminal Linux, macOS o WSL2 en Windows
- GNU Make ≥ 4.3 (`make --version`; en macOS `gmake`). Si no lo tienes, la
  [teoría de instalación](1-teoria/02-instalacion-y-version.md) y
  [docs/setup-entorno.md](../../docs/setup-entorno.md) te guían
- Editor con TABs visibles (VS Code con `editor.renderWhitespace: all` recomendado)
- `python3` solo para `make serve` del proyecto

## Contenido

| # | Tipo | Tema | Tiempo |
|---|------|------|--------|
| — | Teoría | [01-contexto.md](1-teoria/01-contexto.md) · [02-instalacion-y-version.md](1-teoria/02-instalacion-y-version.md) | 45 min |
| — | Conocimiento | [10 preguntas](rubrica-evaluacion.md#-conocimiento-30) | 15 min |
| 1 | Lab | [lab-01-primer-target](2-practicas/lab-01-primer-target/) | 60 min |
| 2 | Lab | [lab-02-dependencias](2-practicas/lab-02-dependencias/) | 60 min |
| 3 | Lab | [lab-03-phony-targets](2-practicas/lab-03-phony-targets/) | 60 min |
| 4 | Lab | [lab-04-targets-y-archivos](2-practicas/lab-04-targets-y-archivos/) | 60 min |
| 5 | Lab | [lab-05-makefile-roto](2-practicas/lab-05-makefile-roto/) | 60 min |
| 6 | Lab | [lab-06-patron-help](2-practicas/lab-06-patron-help/) | 60 min |
| — | Proyecto | [Makefile para sitio estático](3-proyecto/) | 3 h |

**Total: 10 horas**

## Distribución del tiempo

```
[45 min] Leer 1-teoria/ (anatomía de una regla + instalación y versión)
[15 min] Responder las 10 preguntas de Conocimiento
[60 min] lab-01 — Comprobar la versión y escribir tus primeros targets
[60 min] lab-02 — Encadenar dependencias, incluida una en diamante
[60 min] lab-03 — .PHONY y .DEFAULT_GOAL: por qué importan
[60 min] lab-04 — Timestamps: targets que crean archivos en cadena
[60 min] lab-05 — Depurar un Makefile roto (4 errores reales)
[60 min] lab-06 — Implementar el patrón help estándar
[3 h]    Proyecto: Makefile para sitio estático
```

## Verificación de completitud

Desde la raíz del repositorio:

```bash
./scripts/verificar-semana.sh 01
```

Comprueba tu proyecto (`3-proyecto/starter/`) contra los 11 requisitos
verificables de la semana. Al terminar deben pasar todos, y estos comandos
deben funcionar sin errores dentro de tu proyecto:

```bash
make help
make build
make check
make deploy
make clean
```

## 🔗 Navegación

| Anterior | Actual | Siguiente |
|---|---|---|
| — | **Semana 01 — Tu primer Makefile** | [Semana 02 — Variables y expansión](../week-02-variables_y_expansion/README.md) |

[← Volver al índice del bootcamp](../README.md)
