# Semana 04 — Variables automáticas

## Descripción

Las variables automáticas son la razón por la que una sola regla de patrón puede compilar cien archivos distintos. En lugar de escribir el nombre del target o de los prerrequisitos en la receta, Make los inyecta en variables como `$@`, `$<` y `$^` en el momento de ejecución. Esta semana dominarás las seis más importantes y las usarás para construir un build system C real sin repetir un solo nombre de archivo.

## Objetivos de aprendizaje

Al terminar esta semana, podrás:

- Usar `$@` para referenciar el nombre del target dentro de su propia receta
- Usar `$<` para pasar el primer prerrequisito a un compilador
- Usar `$^` para pasar todos los prerrequisitos a un linker (sin duplicados)
- Usar `$?` para reprocesar solo los prerrequisitos modificados desde el último build
- Usar `$*` para extraer el stem en reglas de patrón `%.o: %.c`
- Usar `$(@D)` y `$(@F)` para construir rutas de salida en subdirectorios dinámicamente
- Escribir una regla genérica que compile cualquier `.c` a `.o` sin escribir nombres de archivo

## Prerrequisitos

- Semana 01 completada: targets, dependencias, `.PHONY`, target `help`
- Semana 02 completada: variables `=`, `:=`, `?=`, `+=`
- GNU Make ≥ 4.x instalado (`make --version`)
- `gcc` instalado — requerido solo para el proyecto semanal (`gcc --version`)

## Contenido

| # | Tipo | Tema | Tiempo |
|---|------|------|--------|
| — | Contexto | [01-contexto.md](1-teoria/01-contexto.md) | 30 min |
| 1 | Lab | [lab-01-target-nombre](2-practicas/lab-01-target-nombre/) | 50 min |
| 2 | Lab | [lab-02-primer-prerrequisito](2-practicas/lab-02-primer-prerrequisito/) | 50 min |
| 3 | Lab | [lab-03-todos-prerrequisitos](2-practicas/lab-03-todos-prerrequisitos/) | 50 min |
| 4 | Lab | [lab-04-stem-en-patrones](2-practicas/lab-04-stem-en-patrones/) | 50 min |
| 5 | Lab | [lab-05-rutas-dinamicas](2-practicas/lab-05-rutas-dinamicas/) | 50 min |
| 6 | Lab | [lab-06-variables-rotas](2-practicas/lab-06-variables-rotas/) | 50 min |
| — | Proyecto | [Build system C multi-archivo](3-proyecto/) | 2h 30min |

**Total: 8 horas**

## Distribución del tiempo

```
[30 min] Leer 1-teoria/01-contexto.md
[50 min] lab-01 — $@: el target se conoce a sí mismo
[50 min] lab-02 — $<: el primer prerrequisito, y solo ese
[50 min] lab-03 — $^ y $?: todos vs. los modificados
[50 min] lab-04 — $*: el stem en reglas de patrón
[50 min] lab-05 — $(@D) y $(@F): construir rutas de salida dinámicas
[50 min] lab-06 — Depurar cinco bugs con variables automáticas
[2h 30] Proyecto: build system C multi-archivo con reglas genéricas
```

## Verificación de completitud

Al terminar la semana, estos comandos deben funcionar sin errores:

```bash
cd 3-proyecto/solucion
make help
make all
make clean
make all CC=clang
```

El binario `build/app` debe ejecutarse y producir:

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
