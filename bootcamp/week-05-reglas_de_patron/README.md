# Semana 05 — Reglas de patrón

## Descripción

Una regla de patrón reemplaza docenas de reglas repetitivas con una sola línea: `%.o: %.c`. Make evalúa el `%` como un comodín llamado stem, y aplica la misma receta a todos los archivos que coincidan. Esta semana dominarás reglas de patrón simples, con prefijos de directorio, y static pattern rules, para construir un compilador genérico para proyectos C que escale sin modificaciones.

## Objetivos de aprendizaje

Al terminar esta semana, podrás:

- Escribir una regla de patrón `%.ext1: %.ext2` y entender cómo Make resuelve el stem `%`
- Usar reglas de patrón con prefijos de directorio (`build/%.o: src/%.c`)
- Distinguir entre reglas de patrón genéricas y static pattern rules
- Aplicar static pattern rules para restringir un patrón a un subconjunto específico de targets
- Entender la jerarquía de prioridad: regla explícita > static pattern > regla de patrón > regla implícita
- Depurar errores comunes en reglas de patrón (`No rule to make target`)
- Construir un Makefile que compile cualquier proyecto C multi-módulo sin mencionar archivos por nombre

## Prerrequisitos

- Semana 01 completada: targets, dependencias, `.PHONY`, target `help`
- Semana 02 completada: variables `=`, `:=`, `?=`, `+=`
- Semana 04 completada: variables automáticas `$@`, `$<`, `$^`, `$*`, `$(@D)`
- GNU Make ≥ 4.x instalado (`make --version`)
- `gcc` instalado — requerido para labs 01, 02 y proyecto semanal (`gcc --version`)

## Contenido

| # | Tipo | Tema | Tiempo |
|---|------|------|--------|
| — | Contexto | [01-contexto.md](1-teoria/01-contexto.md) | 30 min |
| 1 | Lab | [lab-01-patron-basico](2-practicas/lab-01-patron-basico/) | 50 min |
| 2 | Lab | [lab-02-directorio-salida](2-practicas/lab-02-directorio-salida/) | 50 min |
| 3 | Lab | [lab-03-multiples-patrones](2-practicas/lab-03-multiples-patrones/) | 50 min |
| 4 | Lab | [lab-04-static-pattern](2-practicas/lab-04-static-pattern/) | 50 min |
| 5 | Lab | [lab-05-prioridad](2-practicas/lab-05-prioridad/) | 50 min |
| 6 | Lab | [lab-06-patrones-rotos](2-practicas/lab-06-patrones-rotos/) | 50 min |
| — | Proyecto | [Compilador genérico para proyectos C](3-proyecto/) | 2h 30min |

**Total: 8 horas**

## Distribución del tiempo

```
[30 min] Leer 1-teoria/01-contexto.md
[50 min] lab-01 — %.o: %.c: la mecánica del stem
[50 min] lab-02 — build/%.o: src/%.c: patrón con directorios
[50 min] lab-03 — múltiples reglas de patrón para distintas extensiones
[50 min] lab-04 — static pattern rules: restringir el patrón a targets específicos
[50 min] lab-05 — prioridad: cuándo la regla explícita gana al patrón
[50 min] lab-06 — depurar cinco errores en reglas de patrón
[2h 30] Proyecto: compilador genérico C con pattern rules
```

## Verificación de completitud

Desde la raíz del repositorio, `./scripts/verificar-semana.sh 05` comprueba tu proyecto (`3-proyecto/starter/`) contra los requisitos verificables de la semana.

Al terminar la semana, estos comandos deben funcionar sin errores:

```bash
cd 3-proyecto/solucion
make help
make all
make clean
make all CC=clang
make test
```

El binario `build/app` debe ejecutarse y producir:

```
suma(3, 4) = 7
producto(3, 4) = 12
potencia(2, 8) = 256
```

## 🔗 Navegación

| Anterior | Actual | Siguiente |
|---|---|---|
| [Semana 04 — Variables automáticas](../week-04-variables_automaticas/README.md) | **Semana 05 — Reglas de patrón** | [Semana 06 — Dependencias automáticas y targets especiales](../week-06-dependencias_y_targets_especiales/README.md) |

[← Volver al índice del bootcamp](../README.md)
