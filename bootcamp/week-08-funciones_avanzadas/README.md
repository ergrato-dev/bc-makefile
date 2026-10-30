# Semana 08 — Funciones Avanzadas de Make

## Descripción

Con las funciones de la semana anterior descubres y transformas archivos. Con las de esta semana *programas* Make: iteras sobre listas, defines funciones reutilizables, generas reglas en la fase de lectura, consultas el sistema y escribes archivos sin lanzar un shell. Son las herramientas que convierten un Makefile en un meta-programa, y también las que más fácilmente lo vuelven lento o inseguro.

## Objetivos de aprendizaje

Al terminar esta semana serás capaz de:

- Iterar sobre listas con `$(foreach)` para generar texto y comandos sin copy-paste
- Definir funciones Make reutilizables con `define...endef` y llamarlas con `$(call)`
- Generar reglas y variables dinámicamente con `$(eval)` y depurarlas con `$(value)` e `$(info)`
- Capturar la salida de comandos con `$(shell)` sabiendo cuándo se ejecuta, cuánto cuesta y qué riesgo tiene
- Escribir y leer archivos sin shell con `$(file)`
- Reconocer `$(let)` y `$(intcmp)` (Make 4.4+) y escribir su alternativa para Make 4.3
- Combinar todo en un Meta-Makefile que genera sus propias reglas y su manifest

## Prerrequisitos

- Semana 01: targets, dependencias, recetas, `.PHONY`
- Semana 02: variables (`=`, `:=`, `?=`, `+=`), override CLI
- Semana 03: preámbulo estricto y guardas de `rm -rf`
- Semana 04: variables automáticas (`$@`, `$<`, `$^`, `$*`)
- Semana 05: pattern rules (`%.o: %.c`), static pattern rules
- Semana 06: prerrequisitos order-only
- Semana 07: `$(wildcard)`, `$(patsubst)`, `$(filter)`, `$(dir)`, `$(notdir)`
- GNU Make ≥ 4.3 (`make --version`; en macOS `gmake`) y `gcc`

## Contenido

| # | Tipo | Tema | Tiempo |
|---|------|------|--------|
| — | Teoría | [01-contexto.md](1-teoria/01-contexto.md) — `foreach`, `call`, `eval`, `shell` | 25 min |
| — | Teoría | [02-file-value-let-intcmp.md](1-teoria/02-file-value-let-intcmp.md) — `file`, `value`, `let`, `intcmp`, coste de `shell` | 20 min |
| — | Conocimiento | [10 preguntas](rubrica-evaluacion.md#-conocimiento-30) | 15 min |
| 1 | Lab | [lab-01-foreach](2-practicas/lab-01-foreach/) | 60 min |
| 2 | Lab | [lab-02-call](2-practicas/lab-02-call/) | 60 min |
| 3 | Lab | [lab-03-eval](2-practicas/lab-03-eval/) | 60 min |
| 4 | Lab | [lab-04-shell](2-practicas/lab-04-shell/) | 60 min |
| 5 | Lab | [lab-05-combinadas](2-practicas/lab-05-combinadas/) | 60 min |
| 6 | Lab | [lab-06-funciones-rotas](2-practicas/lab-06-funciones-rotas/) | 60 min |
| — | Proyecto | [Orquestador de microservicios auto-configurable](3-proyecto/) | 3 h |

**Total: 10 horas**

## Distribución del tiempo

```
[45 min] Leer 1-teoria/ (01-contexto + 02-file-value-let-intcmp)
[15 min] Responder las 10 preguntas de Conocimiento
[60 min] lab-01 — foreach: listas, directorios y configs por entorno
[60 min] lab-02 — call: funciones, nombres calculados y la trampa del espacio
[60 min] lab-03 — eval: reglas generadas, depuración con $(value) e $(info)
[60 min] lab-04 — shell: metadatos, = frente a :=, $(file) sin shell
[60 min] lab-05 — combinadas: build de plugins auto-descubiertos
[60 min] lab-06 — depurar seis errores en funciones avanzadas
[3 h]    Proyecto: orquestador de microservicios con manifest generado
```

## Verificación de completitud

Desde la raíz del repositorio:

```bash
./scripts/verificar-semana.sh 08
```

Comprueba tu `3-proyecto/starter/` contra las 16 comprobaciones de [checks.json](checks.json) (ver la [rúbrica](rubrica-evaluacion.md)). Para validar la solución de referencia: `ENTREGA=solucion ./scripts/verificar-semana.sh 08`.

## 🔗 Navegación

| Anterior | Actual | Siguiente |
|---|---|---|
| [Semana 07 — Funciones de texto y archivo](../week-07-funciones_de_texto_y_archivo/README.md) | **Semana 08 — Funciones avanzadas** | [Semana 09 — Condicionales, include y depuración](../week-09-condicionales_include_y_depuracion/README.md) |

[← Volver al índice del bootcamp](../README.md)
