# Semana 01 — Tu primer Makefile

## Descripción

Aprenderás la anatomía de un Makefile desde cero: cómo se definen targets, dependencias y recetas, y por qué Make solo ejecuta lo que necesita. Esta semana establece la base sobre la que se construye todo el bootcamp.

## Objetivos de aprendizaje

Al terminar esta semana, podrás:

- Escribir un Makefile con targets, dependencias y recetas correctamente indentadas con TAB
- Identificar y corregir los errores más comunes (espacios en lugar de TABs, dependencias faltantes)
- Declarar targets `.PHONY` y explicar por qué son necesarios
- Construir cadenas de dependencias entre targets
- Distinguir targets que producen archivos de targets que ejecutan acciones
- Implementar el patrón `help` estándar con documentación inline

## Prerrequisitos

- GNU Make ≥ 4.x instalado (`make --version`)
- Terminal Linux/macOS o WSL en Windows
- Editor con soporte de TABs visible (VS Code con `editor.renderWhitespace: all` recomendado)

## Contenido

| # | Tipo | Tema | Tiempo |
|---|------|------|--------|
| — | Contexto | [01-contexto.md](1-teoria/01-contexto.md) | 30 min |
| 1 | Lab | [lab-01-primer-target](2-practicas/lab-01-primer-target/) | 50 min |
| 2 | Lab | [lab-02-dependencias](2-practicas/lab-02-dependencias/) | 50 min |
| 3 | Lab | [lab-03-phony-targets](2-practicas/lab-03-phony-targets/) | 50 min |
| 4 | Lab | [lab-04-targets-y-archivos](2-practicas/lab-04-targets-y-archivos/) | 50 min |
| 5 | Lab | [lab-05-makefile-roto](2-practicas/lab-05-makefile-roto/) | 50 min |
| 6 | Lab | [lab-06-patron-help](2-practicas/lab-06-patron-help/) | 50 min |
| — | Proyecto | [Makefile para sitio estático](3-proyecto/) | 2h 30min |

**Total: 8 horas**

## Distribución del tiempo

```
[30 min] Leer 1-teoria/01-contexto.md
[50 min] lab-01 — Escribir tu primer target desde cero
[50 min] lab-02 — Encadenar dependencias entre targets
[50 min] lab-03 — .PHONY: por qué importa más de lo que parece
[50 min] lab-04 — Targets que crean archivos vs targets PHONY
[50 min] lab-05 — Depurar un Makefile roto (4 errores reales)
[50 min] lab-06 — Implementar el patrón help estándar
[2h 30] Proyecto: Makefile para sitio estático
```

## Verificación de completitud

Al terminar la semana, estos comandos deben funcionar sin errores:

```bash
cd 3-proyecto/solucion
make help
make build
make check
make clean
```
