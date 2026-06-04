# CLAUDE.md — bc-makefile

Instrucciones de proyecto para Claude Code. Este archivo se carga automáticamente en cada sesión.

---

## Identidad del proyecto

- **Nombre:** bc-makefile
- **Tipo:** Bootcamp técnico, 100% orientado a la práctica
- **Duración:** 10 semanas × 8 horas = 80 horas totales
- **Herramienta central:** GNU Make (≥ 4.x)
- **Repositorio de referencia de estructura:** ergrato-dev/bc-bash, ergrato-dev/bc-fastapi

## Audiencia objetivo

Desarrolladores que ya saben usar la terminal y han visto algún Makefile pero nunca lo dominaron. No asumas conocimiento de Make; sí asume comodidad con Linux/macOS, git y al menos un lenguaje de programación.

## Filosofía de contenido: 100% práctica

- **Teoría mínima:** solo el contexto indispensable para no perderse en el lab. Máximo 30 min por semana.
- **Labs primero:** el estudiante aprende haciendo, no leyendo.
- **Errores intencionados:** algunos labs incluyen código roto para que el estudiante depure.
- **Progresión real:** cada semana construye sobre la anterior. El Makefile del proyecto semanal puede reutilizarse en semanas posteriores.
- **Sin hello world vacío:** cada ejercicio tiene un propósito concreto y un output verificable.

## Distribución de tiempo por semana (8h)

| Sección | Tiempo | Descripción |
|---------|--------|-------------|
| 1-teoria | 30 min | Contexto mínimo + referencia rápida |
| 2-practicas | 5h | 5–6 labs progresivos (~50 min c/u) |
| 3-proyecto | 2h30 | Proyecto semanal integrador |

## Estructura de carpetas por semana

```
week-NN-nombre_del_tema/
├── README.md                  # Descripción, objetivos, tabla de contenidos
├── rubrica-evaluacion.md      # Criterios de evaluación con puntaje
├── 0-assets/                  # Diagramas SVG (se crean con Mermaid o a mano)
│   └── README.md
├── 1-teoria/                  # Contexto mínimo, NO tutoriales largos
│   └── 01-contexto.md         # Un solo archivo por semana (max 2 si el tema lo requiere)
├── 2-practicas/               # Labs hands-on
│   ├── README.md              # Índice de labs con duración estimada
│   ├── lab-01-nombre/
│   │   ├── README.md          # Enunciado, instrucciones, criterios de éxito
│   │   ├── starter/           # Código inicial (con TODOs marcados)
│   │   │   └── Makefile
│   │   └── solucion/          # Solución de referencia
│   │       └── Makefile
│   └── lab-0N-nombre/
├── 3-proyecto/                # Proyecto semanal
│   ├── README.md              # Enunciado completo, entregables, criterios
│   ├── starter/               # Punto de partida
│   └── solucion/              # Solución de referencia
├── 4-recursos/
│   ├── ebooks-free/README.md
│   ├── videografia/README.md
│   └── webgrafia/README.md
└── 5-glosario/
    └── README.md
```

## Convenciones de naming

| Elemento | Convención | Ejemplo |
|----------|-----------|---------|
| Carpeta de semana | `week-NN-nombre_con_guion_bajo` | `week-03-variables_automaticas` |
| Carpeta de lab | `lab-NN-nombre-con-guion` | `lab-02-phony-targets` |
| Archivos Makefile | `Makefile` (sin extensión) | `Makefile` |
| Archivos de teoría | `NN-nombre-con-guion.md` | `01-contexto.md` |
| Variables Make | `UPPER_SNAKE_CASE` | `BUILD_DIR`, `CC` |
| Targets Make | `lower-kebab-case` | `build`, `clean`, `run-tests` |

## Estándares de Makefiles en el repo

```makefile
# Siempre declarar .PHONY para targets que no producen archivos
.PHONY: all build clean test help

# Primera regla = target por defecto (usa 'all' o 'help')
.DEFAULT_GOAL := help

# Variables al inicio, agrupadas por categoría
CC      := gcc
CFLAGS  := -Wall -Wextra -std=c11
BUILD   := build

# Separar con tabulación (TAB obligatorio), nunca espacios
build:
	$(CC) $(CFLAGS) -o $(BUILD)/programa src/main.c

# Target 'help' siempre presente, documenta los targets disponibles
help:
	@echo "Targets disponibles:"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
		| awk 'BEGIN {FS = ":.*?## "}; {printf "  %-20s %s\n", $$1, $$2}'
```

## Estándares de idioma

- **Prosa, enunciados, comentarios:** español
- **Código (variables, targets, funciones Make):** inglés
- **Nombres de archivo:** inglés o español-guionado (seguir el repo)
- **Mensajes de `@echo` en Makefiles:** español
- **Nunca mezclar idiomas en la misma línea de prosa**

## Estructura de un lab (README.md de lab)

Cada `lab-NN-nombre/README.md` debe tener estas secciones en orden:

1. **Título y duración estimada**
2. **Objetivo** — una sola oración con el verbo en infinitivo
3. **Contexto** — máx. 3 párrafos o bullets; no repetir lo que ya está en 1-teoria
4. **Instrucciones** — pasos numerados, con comandos exactos a ejecutar
5. **Criterios de éxito** — outputs esperados verificables (`make <target>` debe imprimir X)
6. **Reto extra** (opcional) — extensión para estudiantes avanzados

## Estructura del README.md de semana

1. Título y número de semana
2. Descripción (2-3 oraciones)
3. Objetivos de aprendizaje (lista con verbos de acción)
4. Prerrequisitos
5. Tabla de contenidos con tiempos
6. Distribución del tiempo
7. Cómo verificar que completaste la semana

## Rubrica de evaluación

Cada semana tiene rubrica con puntaje 0–100:
- Labs completados: 50 pts (10 pts c/u × 5 labs)
- Proyecto semanal funcional: 30 pts
- Calidad del Makefile (estilo, .PHONY, help): 20 pts

## Plan de 10 semanas

| Semana | Carpeta | Tema | Proyecto semanal |
|--------|---------|------|-----------------|
| 01 | `week-01-tu_primer_makefile` | Targets, dependencias, recetas, .PHONY | Makefile de desarrollo para sitio estático |
| 02 | `week-02-variables_y_expansion` | Tipos de variable (`=` `:=` `?=` `+=`), override CLI | Makefile parametrizable multi-entorno |
| 03 | `week-03-variables_automaticas` | `$@` `$<` `$^` `$?` `$*` `$(@D)` | Build system para proyecto C multi-archivo |
| 04 | `week-04-reglas_de_patron` | Pattern rules `%.o: %.c`, static pattern rules | Compilador genérico para proyectos C |
| 05 | `week-05-funciones_de_texto_y_archivo` | `$(wildcard)` `$(patsubst)` `$(filter)` `$(dir)` `$(notdir)` | Generador automático de reglas |
| 06 | `week-06-funciones_avanzadas` | `$(foreach)` `$(call)` `$(eval)` `$(shell)` | Meta-Makefile: Makefiles que se generan solos |
| 07 | `week-07-makefiles_para_proyectos_modernos` | Python, Docker, Node.js con Make | Makefile de microservicio listo para producción |
| 08 | `week-08-make_como_orquestador_devops` | CI/CD local, git hooks, `.env`, secrets | Pipeline local completo |
| 09 | `week-09-tecnicas_avanzadas` | Condicionales, `include`, recursión, depuración | Makefile modular reutilizable |
| 10 | `week-10-proyecto_integrador` | Integración de todo lo aprendido | Build system multi-lenguaje con Make |

## Comandos útiles durante el desarrollo del bootcamp

```bash
# Verificar sintaxis de un Makefile sin ejecutar
make -n

# Ver todas las variables y reglas que Make conoce
make --print-data-base

# Depurar con trazas
make --debug=v

# Forzar re-ejecución aunque los targets estén al día
make -B
```

## Notas para Claude al generar contenido

- Al generar un lab, siempre incluir `starter/Makefile` con TODOs comentados y `solucion/Makefile` funcional.
- Los labs deben poder ejecutarse con solo `make` y GNU Make ≥ 4.x instalado; sin dependencias extra salvo lo que indique explícitamente la semana.
- Al generar teoría, máximo 600 palabras. Preferir ejemplos concretos de Makefile sobre explicaciones abstractas.
- Cada ejemplo de Makefile en documentación debe ser autoejecutable (pegar y funciona).
- No generar contenido de semanas futuras si no se pidió explícitamente.
- Mantener consistencia de tono: directo, sin relleno, orientado al profesional.
