<p align="center">
  <img src="assets/bootcamp-header.svg" alt="Bootcamp GNU Make — Zero to Advanced" width="800">
</p>

<p align="center">
  <a href="LICENSE"><img src="https://img.shields.io/badge/license-CC%20BY--NC--SA%204.0-lightgrey.svg" alt="License CC BY-NC-SA 4.0"></a>
  <a href="#"><img src="https://img.shields.io/badge/semanas-14-yellow.svg" alt="14 Semanas"></a>
  <a href="#"><img src="https://img.shields.io/badge/horas-140-orange.svg" alt="140 Horas"></a>
  <a href="#"><img src="https://img.shields.io/badge/GNU%20Make-≥4.3-A42E2B?logo=gnu&logoColor=white" alt="GNU Make ≥ 4.3"></a>
</p>

<p align="center">
  <a href="README_EN.md"><img src="https://img.shields.io/badge/🇺🇸_English-0969DA?style=for-the-badge&logoColor=white" alt="English Version"></a>
</p>

---

## 📋 Descripción

Bootcamp **Zero to Advanced** de **14 semanas (~3.5 meses)** enfocado en el dominio de **GNU Make** como herramienta de automatización y build system. Autoestudio asincrónico, **10 h/semana**, 100% práctico: lleva a desarrolladores que nunca dominaron Make hasta diseñar build systems modulares, paralelos y seguros listos para producción.

### 🎯 Objetivos

Al finalizar el bootcamp, los estudiantes serán capaces de:

- ✅ Escribir Makefiles idiomáticos con targets, dependencias y recetas correctas
- ✅ Dominar los tipos de variables (`=`, `:=`, `?=`, `+=`, `!=`) y su expansión
- ✅ Escribir recetas robustas en modo estricto (`.SHELLFLAGS`, `.DELETE_ON_ERROR`, `.ONESHELL`)
- ✅ Usar variables automáticas (`$@`, `$<`, `$^`, `$?`, `$*`) con fluidez
- ✅ Crear reglas de patrón, generar dependencias automáticas (`-MMD -MP`) y usar targets especiales
- ✅ Aplicar funciones de texto, archivo y metaprogramación (`$(foreach)`, `$(call)`, `$(eval)`, `$(file)`)
- ✅ Depurar Makefiles con `--trace`, `--warn-undefined-variables` y `-p`
- ✅ Paralelizar builds con `-j`, `--output-sync` y recursión que no se traga los fallos
- ✅ Orquestar proyectos Python, Docker y Node.js y pipelines CI/CD locales con Make
- ✅ Proteger un Makefile: secretos, `.env`, inyección de comandos, portabilidad y alternativas

### 🔧 ¿Por qué GNU Make?

> **Make moderno desde el día 1** — Sin antipatrones legacy, solo las mejores prácticas actuales.

Make nació en 1976 y GNU Make en 1988: casi cuatro décadas como columna vertebral de los build systems más críticos del mundo. Este bootcamp demuestra que Make no es una herramienta antigua: es la herramienta de automatización más ubicua, portable y poderosa disponible en cualquier sistema Unix. Los estudiantes aprenden directamente los patrones que encontrarán en proyectos reales de Linux, Open Source y DevOps.

---

## 🗓️ Estructura del Bootcamp

|         Fase           | Semanas | Horas | Temas Principales                                                    |
| :--------------------: | :-----: | :---: | -------------------------------------------------------------------- |
| **Fundamentos**        |   1-4   |  40h  | Targets, variables, shell y modo estricto, variables automáticas     |
| **Intermedio**         |   5-8   |  40h  | Pattern rules, dependencias automáticas, funciones                   |
| **Avanzado**           |  9-11   |  30h  | Depuración, paralelismo, recursión, proyectos modernos               |
| **Producción**         |  12-14  |  30h  | DevOps, seguridad, portabilidad, proyecto integrador                 |

**Total: 14 semanas** | **140 horas** | Índice con estado de cada semana: [bootcamp/README.md](bootcamp/README.md)

---

## 📚 Contenido por Semana

Cada semana incluye:

```
bootcamp/week-NN-nombre_del_tema/
├── README.md                  # Descripción, objetivos y navegación
├── rubrica-evaluacion.md      # Conocimiento 30% / Desempeño 40% / Producto 30%
├── checks.json                # Comprobaciones automáticas (autograding)
├── 0-assets/                  # Diagramas Mermaid
├── 1-teoria/                  # Contexto mínimo (≤ 45 min)
├── 2-practicas/               # 6 labs progresivos (~60 min c/u)
├── 3-proyecto/                # Proyecto semanal integrador (3 h)
├── 4-recursos/                # Recursos adicionales
│   ├── ebooks-free/
│   ├── videografia/
│   └── webgrafia/
└── 5-glosario/                # Términos clave de la semana
```

### 🗺️ Plan de 14 Semanas

| Semana | Tema | Proyecto Semanal |
|--------|------|-----------------|
| [01 — Tu primer Makefile](bootcamp/week-01-tu_primer_makefile/) | Targets, dependencias, recetas, `.PHONY` | Makefile para sitio estático |
| [02 — Variables y Expansión](bootcamp/week-02-variables_y_expansion/) | `=` `:=` `?=` `+=` `!=`, override CLI, `$(origin)` | Makefile parametrizable multi-entorno |
| [03 — Shell y Modo Estricto](bootcamp/week-03-shell_y_modo_estricto/) | `SHELL`, `.SHELLFLAGS`, `.ONESHELL`, `.DELETE_ON_ERROR` | Makefile de tareas a prueba de fallos |
| [04 — Variables Automáticas](bootcamp/week-04-variables_automaticas/) | `$@` `$<` `$^` `$?` `$*` `$(@D)` | Build system para proyecto C multi-archivo |
| [05 — Reglas de Patrón](bootcamp/week-05-reglas_de_patron/) | Pattern rules `%.o: %.c`, static pattern rules | Compilador genérico para C |
| [06 — Dependencias y Targets Especiales](bootcamp/week-06-dependencias_y_targets_especiales/) | `-MMD -MP`, order-only, `vpath`, `&:`, `.SECONDARY` | Build C con dependencias de headers exactas |
| [07 — Funciones de Texto y Archivo](bootcamp/week-07-funciones_de_texto_y_archivo/) | `$(wildcard)` `$(patsubst)` `$(filter)` `$(dir)` | Generador automático de reglas |
| [08 — Funciones Avanzadas](bootcamp/week-08-funciones_avanzadas/) | `$(foreach)` `$(call)` `$(eval)` `$(shell)` `$(file)` | Meta-Makefile: Makefiles que se generan solos |
| [09 — Condicionales, Include y Depuración](bootcamp/week-09-condicionales_include_y_depuracion/) | `ifeq`, `include`, `--trace`, `--warn-undefined-variables` | Makefile modular reutilizable |
| [10 — Paralelismo y Recursión](bootcamp/week-10-paralelismo_y_recursion/) | `-j`, jobserver, `-O`, `.WAIT`, `--shuffle`, sub-makes | Monorepo con build paralelo y recursión segura |
| [11 — Make para Proyectos Modernos](bootcamp/week-11-makefiles_para_proyectos_modernos/) | Python + uv, Docker, Node.js con Make | Makefile de microservicio listo para producción |
| [12 — Make como Orquestador DevOps](bootcamp/week-12-make_como_orquestador_devops/) | CI/CD local, git hooks, `.env`, secrets | Pipeline local completo |
| [13 — Seguridad, Portabilidad y Alternativas](bootcamp/week-13-seguridad_portabilidad_y_alternativas/) | Amenazas, testing de Makefiles, POSIX/BSD make, just/Task/ninja | Auditoría y endurecimiento de un Makefile real |
| [14 — Proyecto Integrador](bootcamp/week-14-proyecto_integrador/) | Integración de todo lo aprendido | Build system multi-lenguaje con Make |

### 🔑 Componentes Clave

- 📖 **Teoría**: Contexto mínimo indispensable (máx. 45 min/semana)
- 💻 **Práctica**: 6 labs progresivos con starter y criterios de éxito verificables
- 🐛 **Debugging**: Labs con errores intencionados para desarrollar criterio real
- 🤖 **Autograding**: `./scripts/verificar-semana.sh NN` comprueba tu trabajo ([cómo funciona](docs/autograding.md))
- 🎓 **Recursos**: Glosario, ebooks gratuitos, videografía y webgrafía

---

## 🛠️ Herramientas

| Herramienta | Versión | Uso |
|-------------|---------|-----|
| GNU Make    | **≥ 4.3** (4.4.1 recomendada) | Herramienta central del bootcamp |
| GCC / Clang | gcc ≥ 11 / clang ≥ 14 | Semanas 4-10 y 14 (proyectos C) |
| Python      | **3.14** + uv (nunca pip) | Semanas 11-14 |
| Docker      | Engine 27+ con Compose v2 | Semanas 11-14 |
| Node.js     | **26 LTS** + pnpm (nunca npm) | Semanas 11-14 |
| jq          | cualquiera | Autograding |
| Git         | cualquiera | Control de versiones |

Versiones exactas y por qué: [docs/stack-versions.md](docs/stack-versions.md).

> ⚠️ **macOS** trae GNU Make 3.81 (2006), que no sirve para este bootcamp. Instala `gmake` con Homebrew: [docs/setup-entorno.md](docs/setup-entorno.md).

---

## 🚀 Inicio Rápido

```bash
git clone https://github.com/ergrato-dev/bc-makefile.git
cd bc-makefile
./scripts/verificar-semana.sh --doctor     # comprueba tu entorno
```

Empieza por [bootcamp/week-01-tu_primer_makefile](bootcamp/week-01-tu_primer_makefile/README.md). Cada semana contiene un `README.md` con instrucciones, tiempo estimado y criterios de éxito verificables. Trabajas en las carpetas `starter/`; al terminar la semana, desde la raíz del repositorio:

```bash
./scripts/verificar-semana.sh 01
```

---

## 📊 Metodología de Aprendizaje

### Estrategias Didácticas

- 🎯 **Aprendizaje Basado en Proyectos (ABP)**
- 🧩 **Práctica Deliberada** — labs progresivos con dificultad incremental
- 🐛 **Debugging Intencional** — errores reales para desarrollar criterio
- 🔄 **Build Challenges** — problemas de automatización del mundo real

### Distribución del Tiempo (10h/semana)

- **Teoría**: 45 minutos
- **Conocimiento**: 15 minutos (10 preguntas de la rúbrica)
- **Prácticas**: 6 horas (6 labs × ~60 min)
- **Proyecto**: 3 horas

### Evaluación

Cada semana incluye tres evidencias:

1. **🧠 Conocimiento** (30%): 10 preguntas conceptuales, respondidas por escrito
2. **💪 Desempeño** (40%): los 6 labs, verificados con `make` y con el autograding
3. **📦 Producto** (30%): proyecto semanal — 60 pts automáticos (`checks.json`) + 40 pts de calidad (`.PHONY`, `help`, modo estricto, estilo)

**Criterio de aprobación**: mínimo **70% en cada evidencia**, no en el promedio.

---

## 📞 Soporte

- 💬 **Discussions**: [GitHub Discussions](https://github.com/ergrato-dev/bc-makefile/discussions)
- 🐛 **Issues**: [GitHub Issues](https://github.com/ergrato-dev/bc-makefile/issues)

---

## ⚠️ Exención de Responsabilidad

Este repositorio es un recurso **educativo** creado con fines de aprendizaje. Al utilizarlo, aceptas los siguientes términos:

- **Solo fines educativos**: El contenido, los ejemplos de código y los proyectos están diseñados exclusivamente para la enseñanza y el aprendizaje. No constituyen asesoramiento profesional, legal ni de seguridad.
- **Sin garantías**: El material se proporciona **"tal cual"**, sin garantías de ningún tipo, expresas o implícitas, incluyendo idoneidad para un propósito particular o ausencia de errores.
- **Código en producción**: Los ejemplos de código son ilustrativos. Antes de usarlos en entornos productivos, debes realizar revisiones de seguridad, rendimiento y adaptación a tu contexto específico.
- **Versiones de software**: Las versiones de herramientas mencionadas pueden quedar desactualizadas. Siempre consulta la documentación oficial más reciente.
- **Limitación de responsabilidad**: Los autores y contribuidores no se responsabilizan por pérdidas de datos, daños directos o indirectos, interrupciones de servicio ni cualquier otro perjuicio derivado del uso de este material.
- **Responsabilidad del estudiante**: Cada estudiante es responsable de sus propias implementaciones, entornos de desarrollo y decisiones técnicas.

---

## 📄 Licencia

Este proyecto está bajo la licencia **[CC BY-NC-SA 4.0](https://creativecommons.org/licenses/by-nc-sa/4.0/)** (Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International).

**Puedes:** compartir y adaptar el material, incluso crear forks educativos.<br>
**No puedes:** usar este material con fines comerciales.<br>
**Debes:** dar crédito apropiado y distribuir las adaptaciones bajo la misma licencia.

Ver el archivo [LICENSE](LICENSE) para el texto completo.

---

## 🏆 Agradecimientos

- [GNU Make](https://www.gnu.org/software/make/) — Por casi cuatro décadas siendo el build system más confiable del mundo
- [GNU Make Manual](https://www.gnu.org/software/make/manual/) — La documentación oficial más completa
- Comunidad Open Source — Por proyectos reales donde Make sigue siendo el estándar
- Todos los contribuidores

---

## 📚 Documentación Adicional

- [📜 Código de Conducta](CODE_OF_CONDUCT.md)
- [🔒 Política de Seguridad](SECURITY.md)
- [🛠️ Preparar el entorno](docs/setup-entorno.md)
- [🤖 Autograding](docs/autograding.md)
- [📦 Versiones del stack](docs/stack-versions.md)

---

<p align="center">
  <strong>🎓 Bootcamp GNU Make — Zero to Advanced</strong><br>
  <em>De cero a avanzado en automatización en 14 semanas</em>
</p>

<p align="center">
  <a href="bootcamp/week-01-tu_primer_makefile">Comenzar Semana 1</a> •
  <a href="https://github.com/ergrato-dev/bc-makefile/issues">Reportar Issue</a>
</p>

<p align="center">
  Hecho con ❤️ para la comunidad de desarrolladores
</p>
