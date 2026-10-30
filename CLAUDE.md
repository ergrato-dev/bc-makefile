# CLAUDE.md — bc-makefile

Instrucciones de proyecto para Claude Code. Este archivo se carga automáticamente en cada sesión.

---

## Identidad del proyecto

- **Nombre:** bc-makefile
- **Tipo:** Bootcamp técnico, 100% orientado a la práctica
- **Duración:** 14 semanas × 10 horas = 140 horas totales (Zero to Advanced)
- **Herramienta central:** GNU Make (≥ 4.3; features 4.4 marcadas como "Make 4.4+" con alternativa 4.3)
- **Repositorio de referencia de estructura:** ergrato-dev/bc-bash, ergrato-dev/bc-fastapi

## Audiencia objetivo

Desarrolladores que ya saben usar la terminal y han visto algún Makefile pero nunca lo dominaron. No asumas conocimiento de Make; sí asume comodidad con Linux/macOS, git y al menos un lenguaje de programación.

## Filosofía de contenido: 100% práctica

- **Teoría mínima:** solo el contexto indispensable para no perderse en el lab. Máximo 45 min por semana.
- **Labs primero:** el estudiante aprende haciendo, no leyendo.
- **Errores intencionados:** algunos labs incluyen código roto para que el estudiante depure.
- **Progresión real:** cada semana construye sobre la anterior. El Makefile del proyecto semanal puede reutilizarse en semanas posteriores.
- **Sin hello world vacío:** cada ejercicio tiene un propósito concreto y un output verificable.

## Distribución de tiempo por semana (10h)

| Sección | Tiempo | Descripción |
|---------|--------|-------------|
| 1-teoria | 45 min | Contexto mínimo + referencia rápida (1–3 archivos) |
| Conocimiento | 15 min | 10 preguntas de la rúbrica, respondidas por escrito |
| 2-practicas | 6h | 6 labs progresivos (~60 min c/u) |
| 3-proyecto | 3h | Proyecto semanal integrador |

## Estructura de carpetas por semana

```
week-NN-nombre_del_tema/
├── README.md                  # Descripción, objetivos, tabla de contenidos, navegación
├── rubrica-evaluacion.md      # Conocimiento 30 / Desempeño 40 / Producto 30
├── checks.json                # Autograding (ver docs/autograding.md)
├── 0-assets/                  # Diagramas Mermaid en archivos .md (renderizan en GitHub y VS Code)
│   └── NN-nombre.md
├── 1-teoria/                  # Contexto mínimo, NO tutoriales largos
│   └── 01-contexto.md         # 1–3 archivos, ≤ 600 palabras de prosa c/u
├── 2-practicas/               # Labs hands-on
│   ├── README.md              # Índice de labs con duración estimada
│   ├── lab-01-nombre/
│   │   ├── README.md          # Enunciado, instrucciones, criterios de éxito
│   │   ├── starter/           # Código inicial (con TODOs marcados)
│   │   │   └── Makefile
│   │   └── solucion/          # Solución de referencia (pasa a repo privado, ver abajo)
│   │       └── Makefile
│   └── lab-0N-nombre/
├── 3-proyecto/                # Proyecto semanal
│   ├── README.md              # Enunciado completo, entregables, criterios
│   ├── starter/               # Punto de partida
│   └── solucion/              # Solución de referencia
├── 4-recursos/
│   ├── ebooks-free/README.md   # Libros gratuitos (PDF, HTML) sobre Make y build systems
│   ├── videografia/README.md   # Videos en YouTube/cursos recomendados (tabla: título|canal|duración|enlace)
│   └── webgrafia/README.md     # Documentación oficial y artículos de calidad (tabla: recurso|descripción)
└── 5-glosario/
    └── README.md               # Tabla: Término | Definición en una línea | Ejemplo en Makefile
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
7. Cómo verificar que completaste la semana (`./scripts/verificar-semana.sh NN`)
8. `## 🔗 Navegación` (anterior / actual / siguiente + volver al índice)

## Rubrica de evaluación

Formato de referencia: `bc-curl/bootcamp/week-01-*/rubrica-evaluacion.md`. Tres evidencias, **mínimo 70% en cada una** (no en el promedio):
- 🧠 Conocimiento 30%: 10 preguntas conceptuales (3 pts c/u) que piden explicar el porqué, no recordar sintaxis
- 💪 Desempeño 40%: los 6 labs, con criterios de éxito verificables
- 📦 Producto 30%: proyecto semanal — 60 pts de autograding (`checks.json`) + 40 pts de calidad (`.PHONY`, `help`, modo estricto, estilo)

Bandas: Sobresaliente 90–100, Notable 80–89, Aprobado 70–79.

## Plan de 14 semanas

Índice con estado: `bootcamp/README.md` (✅ = semana al estándar actual).

| Semana | Carpeta | Tema | Proyecto semanal |
|--------|---------|------|-----------------|
| **Fase 1 — Fundamentos** ||||
| 01 | `week-01-tu_primer_makefile` | Targets, dependencias, recetas, .PHONY, instalación (macOS `gmake`) | Makefile de desarrollo para sitio estático |
| 02 | `week-02-variables_y_expansion` | `=` `:=` `?=` `+=` `!=`, override CLI, `$(origin)`, `$(flavor)` | Makefile parametrizable multi-entorno |
| 03 | `week-03-shell_y_modo_estricto` | `SHELL`, `.SHELLFLAGS`, `.ONESHELL`, `.DELETE_ON_ERROR`, prefijos `- @ +`, guardas `rm -rf` | Makefile de tareas a prueba de fallos |
| 04 | `week-04-variables_automaticas` | `$@` `$<` `$^` `$?` `$*` `$(@D)`, `-MMD -MP` básico | Build system para proyecto C multi-archivo |
| **Fase 2 — Intermedio** ||||
| 05 | `week-05-reglas_de_patron` | Pattern rules, static pattern rules, `-r` | Compilador genérico para proyectos C |
| 06 | `week-06-dependencias_y_targets_especiales` | `-MMD -MP`, order-only, `vpath`, `&:`, `.SECONDARY`/`.PRECIOUS`/`.NOTINTERMEDIATE`, `.SECONDEXPANSION` | Build C con dependencias de headers exactas |
| 07 | `week-07-funciones_de_texto_y_archivo` | `$(wildcard)` `$(patsubst)` `$(filter)` `$(dir)` `$(notdir)` | Generador automático de reglas |
| 08 | `week-08-funciones_avanzadas` | `$(foreach)` `$(call)` `$(eval)` `$(shell)` `$(file)` `$(let)` `$(value)` | Meta-Makefile: Makefiles que se generan solos |
| **Fase 3 — Avanzado** ||||
| 09 | `week-09-condicionales_include_y_depuracion` | Condicionales, `include`, `--trace`, `--warn-undefined-variables`, guarda de versión | Makefile modular reutilizable |
| 10 | `week-10-paralelismo_y_recursion` | `-j`, jobserver, `-O`, `.NOTPARALLEL`, `.WAIT`, `--shuffle`, sub-makes como targets | Monorepo con build paralelo y recursión segura |
| 11 | `week-11-makefiles_para_proyectos_modernos` | Python + uv, Docker multi-stage no-root, Node.js con pnpm | Makefile de microservicio listo para producción |
| **Fase 4 — Producción** ||||
| 12 | `week-12-make_como_orquestador_devops` | CI/CD local, git hooks (`core.hooksPath`), `.env`, secrets | Pipeline local completo |
| 13 | `week-13-seguridad_portabilidad_y_alternativas` | Amenazas, testing de Makefiles, POSIX/BSD make, just/Task/ninja/CMake | Auditoría y endurecimiento de un Makefile real |
| 14 | `week-14-proyecto_integrador` | Integración de todo lo aprendido | Build system multi-lenguaje con Make |

Versiones del stack (Python, Node, imágenes): `docs/stack-versions.md`. No usar otras. Node.js siempre con **pnpm** (`pnpm-lock.yaml`, `pnpm install --frozen-lockfile`); nunca npm. Python siempre con **uv** (`pyproject.toml` + `uv.lock`, `uv sync --locked`, `uv run`); nunca pip ni `requirements.txt`.

## Comandos útiles durante el desarrollo del bootcamp

```bash
# Verificar estructura, enlaces y starters del bootcamp
./scripts/verificar-enlaces.sh

# Autograding de una semana
./scripts/verificar-semana.sh NN

# Verificar sintaxis de un Makefile sin ejecutar
make -n

# Ver todas las variables y reglas que Make conoce
make --print-data-base

# Depurar con trazas
make --debug=v

# Forzar re-ejecución aunque los targets estén al día
make -B
```

## Contenido esperado por sección

### 0-assets/
Diagramas en formato **Mermaid** dentro de archivos `.md`. Renderizan nativamente en GitHub y en VS Code con la extensión "Markdown Preview Mermaid Support". Un archivo por diagrama, nombrado `NN-nombre.md`.

Mínimo 3 diagramas por semana. Cada archivo tiene: título H1, bloque ` ```mermaid ``` `, y 2-3 líneas de explicación del concepto ilustrado.

Tipos Mermaid preferidos: `graph TD/LR`, `flowchart TD`, `sequenceDiagram`.

### 4-recursos/ebooks-free/
Tabla con libros/documentos gratuitos descargables o legibles online:
```markdown
| Título | Formato | Descripción | Enlace |
|--------|---------|-------------|--------|
| GNU Make Manual | HTML/PDF | Manual oficial completo | https://www.gnu.org/software/make/manual/ |
```

### 4-recursos/videografia/
Tabla con videos de YouTube u otras plataformas abiertas:
```markdown
| Título | Canal | Duración | Enlace |
|--------|-------|----------|--------|
```
Mínimo 3 videos relevantes al tema de la semana. Preferir videos en español si existen de calidad; complementar con inglés.

### 4-recursos/webgrafia/
Tabla con documentación oficial y artículos técnicos de calidad:
```markdown
| Recurso | Descripción |
|---------|-------------|
```
3–5 enlaces, priorizando documentación oficial de GNU Make.

### 5-glosario/
Tabla con términos introducidos en la semana:
```markdown
| Término | Definición en una línea | Ejemplo en Makefile |
|---------|------------------------|---------------------|
```
Entre 8 y 15 términos por semana. Solo términos nuevos de esa semana.

## Notas para Claude al generar contenido

- Al generar un lab, siempre incluir `starter/Makefile` con TODOs comentados y `solucion/Makefile` funcional. Las soluciones se moverán al repo privado `ergrato-dev/bc-makefile-instructor` (misma ruta relativa); hasta entonces viven aquí.
- Desde la semana 03, toda solución usa el preámbulo estricto: `SHELL := bash`, `.SHELLFLAGS := -eu -o pipefail -c`, `.DELETE_ON_ERROR:`.
- Recursión siempre con subdirectorios como targets phony, nunca `for d in ...; do $(MAKE) -C $$d; done`.
- Nunca `export` sin argumentos, nunca `include .env` sin advertir que se parsea como Makefile, nunca `rm -rf $(VAR)` sin guarda.
- Cada semana nueva o refactorizada lleva `checks.json` escrito antes que el contenido, y pasa `./scripts/verificar-enlaces.sh`.
- Los labs deben poder ejecutarse con solo `make` y GNU Make ≥ 4.x instalado; sin dependencias extra salvo lo que indique explícitamente la semana.
- Al generar teoría, máximo 600 palabras. Preferir ejemplos concretos de Makefile sobre explicaciones abstractas.
- Cada ejemplo de Makefile en documentación debe ser autoejecutable (pegar y funciona).
- No generar contenido de semanas futuras si no se pidió explícitamente.
- Mantener consistencia de tono: directo, sin relleno, orientado al profesional.
