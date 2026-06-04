# PLANTILLA DE SEMANA — bc-makefile

> Archivo de referencia. Copia esta estructura al crear contenido nuevo.
> Ver también: `.claude/commands/gen-semana.md` para generación automática.

---

## README.md de semana (plantilla)

```markdown
# Semana NN — Título del Tema

## Descripción

<2-3 oraciones. Qué aprenderá el estudiante. Por qué importa en la práctica real.>

## Objetivos de aprendizaje

Al terminar esta semana, podrás:

- Escribir <concepto> usando <técnica>
- Depurar <problema común> con <herramienta>
- Construir <artefacto concreto> desde cero
- Aplicar <patrón> a proyectos reales

## Prerrequisitos

- Haber completado la Semana NN-1
- GNU Make ≥ 4.x instalado (`make --version`)
- <herramienta específica si aplica>

## Contenido

| # | Tipo | Tema | Tiempo |
|---|------|------|--------|
| — | Contexto | [01-contexto.md](1-teoria/01-contexto.md) | 30 min |
| 1 | Lab | [lab-01-nombre](2-practicas/lab-01-nombre/) | 50 min |
| 2 | Lab | [lab-02-nombre](2-practicas/lab-02-nombre/) | 50 min |
| 3 | Lab | [lab-03-nombre](2-practicas/lab-03-nombre/) | 50 min |
| 4 | Lab | [lab-04-nombre](2-practicas/lab-04-nombre/) | 50 min |
| 5 | Lab | [lab-05-nombre](2-practicas/lab-05-nombre/) | 50 min |
| — | Proyecto | [Proyecto semanal](3-proyecto/) | 2h 30min |

**Total: 8 horas**

## Verificación de completitud

Al terminar la semana, estos comandos deben funcionar sin errores:

\`\`\`bash
cd 3-proyecto/solucion
make help
make build
make clean
\`\`\`
```

---

## README.md de lab (plantilla)

```markdown
# Lab NN — Título del Lab

⏱ Duración estimada: ~50 min

## Objetivo

<Verbo en infinitivo>: implementar/depurar/construir <qué> usando <qué técnica de Make>.

## Contexto

<Máx. 3 párrafos o 5 bullets. Referencia al tema de la semana sin repetir la teoría.>

## Instrucciones

1. Abre `starter/Makefile` y lee los comentarios `# TODO`
2. Implementa el target `<nombre>`:
   \`\`\`makefile
   # pista si aplica
   \`\`\`
3. Verifica con:
   \`\`\`bash
   make <target>
   \`\`\`
   Debes ver:
   \`\`\`
   <output esperado exacto>
   \`\`\`
4. <siguiente paso...>

## Criterios de éxito

Al completar este lab:

- [ ] `make <target1>` imprime `<output>`
- [ ] `make <target2>` produce `<artefacto>`
- [ ] `make clean` elimina los archivos generados sin error

## Reto extra

<Extensión opcional para ir más lejos. Siempre opcional, nunca requerida.>
```

---

## Makefile starter (plantilla)

```makefile
# ============================================================
# Lab NN — Título
# Semana NN: Tema
# ============================================================
# Instrucciones:
#   1. Lee cada TODO y completa la implementación
#   2. Ejecuta `make help` para ver los targets disponibles
#   3. Verifica con `make <target>` según el README
# ============================================================

.PHONY: all help

# TODO: declara aquí las variables necesarias
# VARIABLE := valor

.DEFAULT_GOAL := help

## all: ejecuta el flujo principal
all:
	@echo "TODO: implementa el target all"

## help: muestra esta ayuda
help:
	@grep -E '^##' $(MAKEFILE_LIST) | sed 's/## //'
```

---

## Makefile solucion (plantilla)

```makefile
# ============================================================
# Lab NN — Título (SOLUCIÓN)
# ============================================================

.PHONY: all build clean test help

CC      := gcc
CFLAGS  := -Wall -Wextra -std=c11
BUILD   := build

.DEFAULT_GOAL := help

## all: compila y ejecuta tests
all: build test

## build: compila el proyecto
build: $(BUILD)/programa

$(BUILD)/programa: src/main.c | $(BUILD)
	$(CC) $(CFLAGS) -o $@ $<

$(BUILD):
	mkdir -p $@

## clean: elimina archivos generados
clean:
	rm -rf $(BUILD)

## test: verifica que el binario funciona
test: build
	@./$(BUILD)/programa && echo "OK"

## help: muestra esta ayuda
help:
	@grep -E '^## ' $(MAKEFILE_LIST) \
		| awk 'BEGIN {FS = ": "}; {printf "  %-20s %s\n", $$1, $$2}' \
		| sed 's/## //'
```
