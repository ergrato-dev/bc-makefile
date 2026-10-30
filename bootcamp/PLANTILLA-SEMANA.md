# PLANTILLA DE SEMANA — bc-makefile

> Archivo de referencia. Copia esta estructura al crear contenido nuevo.
> Reglas completas en `CLAUDE.md`; generación automática con `.claude/commands/gen-semana.md`.

---

## README.md de semana (plantilla)

~~~markdown
# Semana NN — Título del Tema

## Descripción

<2-3 oraciones. Qué aprenderá el estudiante. Por qué importa en la práctica real.>

## Objetivos de aprendizaje

Al terminar esta semana, podrás:

- Escribir <concepto> usando <técnica>
- Depurar <problema común> con <herramienta>
- Construir <artefacto concreto> desde cero

## Prerrequisitos

- Semanas 01–NN-1 completadas
- GNU Make ≥ 4.3 (`make --version`; en macOS `gmake`)
- <herramienta específica si aplica>

## Contenido

| # | Tipo | Tema | Tiempo |
|---|------|------|--------|
| — | Teoría | [01-contexto.md](1-teoria/01-contexto.md) | 45 min |
| — | Conocimiento | [10 preguntas](rubrica-evaluacion.md#-conocimiento-30) | 15 min |
| 1 | Lab | [lab-01-nombre](2-practicas/lab-01-nombre/) | 60 min |
| 2 | Lab | [lab-02-nombre](2-practicas/lab-02-nombre/) | 60 min |
| 3 | Lab | [lab-03-nombre](2-practicas/lab-03-nombre/) | 60 min |
| 4 | Lab | [lab-04-nombre](2-practicas/lab-04-nombre/) | 60 min |
| 5 | Lab | [lab-05-nombre](2-practicas/lab-05-nombre/) | 60 min |
| 6 | Lab | [lab-06-nombre](2-practicas/lab-06-nombre/) | 60 min |
| — | Proyecto | [Proyecto semanal](3-proyecto/) | 3 h |

**Total: 10 horas**

## Distribución del tiempo

```
[45 min] Leer 1-teoria/
[15 min] Responder las 10 preguntas de Conocimiento
[60 min] lab-01 — <tema>
...
[60 min] lab-06 — <tema>
[3 h]    Proyecto: <nombre>
```

## Verificación de completitud

Desde la raíz del repositorio:

```bash
./scripts/verificar-semana.sh NN
```

## 🔗 Navegación

| Anterior | Actual | Siguiente |
|---|---|---|
| [Semana NN-1 — Tema](../week-NN-1-slug/README.md) | **Semana NN — Tema** | [Semana NN+1 — Tema](../week-NN+1-slug/README.md) |

[← Volver al índice del bootcamp](../README.md)
~~~

---

## README.md de lab (plantilla)

~~~markdown
# Lab NN — Título del Lab

⏱ Duración estimada: ~60 min

## Objetivo

<Verbo en infinitivo> <qué> usando <qué técnica de Make>.

## Contexto

<Máx. 3 párrafos o 5 bullets. Referencia al tema de la semana sin repetir la teoría.>

## Instrucciones

1. Abre `starter/Makefile` y lee los comentarios `# TODO`
2. Implementa el target `<nombre>`
3. Verifica con:
   ```bash
   make <target>
   ```
   Debes ver:
   ```
   <output esperado exacto>
   ```

## Criterios de éxito

- [ ] `make <target1>` imprime `<output>`
- [ ] `make <target2>` produce `<artefacto>`
- [ ] `make clean` elimina los archivos generados sin error

## Reto extra

<Extensión opcional para ir más lejos.>
~~~

---

## Makefile starter (plantilla)

```makefile
# ============================================================
# Lab NN — Título
# Semana NN: Tema
# ============================================================

.PHONY: all help
.DEFAULT_GOAL := help

# TODO: declara aquí las variables necesarias
# VARIABLE := valor

all: ## Ejecuta el flujo principal
	@echo "TODO: implementa el target all"

help: ## Muestra los targets disponibles
	@echo "Targets disponibles:"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
		| awk 'BEGIN {FS = ":.*?## "}; {printf "  %-20s %s\n", $$1, $$2}'
```

---

## Makefile solución (plantilla, semana 03 en adelante)

```makefile
# ============================================================
# Lab NN — Título (SOLUCIÓN)
# ============================================================

SHELL       := bash
.SHELLFLAGS := -eu -o pipefail -c
.DELETE_ON_ERROR:

.PHONY: all build clean test help
.DEFAULT_GOAL := help

CC      := gcc
CFLAGS  := -Wall -Wextra -std=c11
BUILD   := build

all: build test ## Compila y ejecuta tests

build: $(BUILD)/programa ## Compila el proyecto

$(BUILD)/programa: src/main.c | $(BUILD)
	$(CC) $(CFLAGS) -o $@ $<

$(BUILD):
	mkdir -p $@

clean: ## Elimina archivos generados
	$(if $(BUILD),,$(error BUILD esta vacio))
	rm -rf -- '$(BUILD)'

test: build ## Verifica que el binario funciona
	./$(BUILD)/programa

help: ## Muestra los targets disponibles
	@echo "Targets disponibles:"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
		| awk 'BEGIN {FS = ":.*?## "}; {printf "  %-20s %s\n", $$1, $$2}'
```
