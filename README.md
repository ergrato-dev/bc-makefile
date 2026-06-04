<p align="center">
  <img src="assets/bootcamp-header.svg" alt="Bootcamp GNU Make — Domina el Build System" width="800">
</p>

<p align="center">
  <a href="LICENSE"><img src="https://img.shields.io/badge/license-CC%20BY--NC--SA%204.0-lightgrey.svg" alt="License CC BY-NC-SA 4.0"></a>
  <a href="#"><img src="https://img.shields.io/badge/semanas-10-yellow.svg" alt="10 Semanas"></a>
  <a href="#"><img src="https://img.shields.io/badge/horas-80-orange.svg" alt="80 Horas"></a>
  <a href="#"><img src="https://img.shields.io/badge/GNU%20Make-≥4.x-A42E2B?logo=gnu&logoColor=white" alt="GNU Make"></a>
</p>

<p align="center">
  <a href="README_EN.md"><img src="https://img.shields.io/badge/🇺🇸_English-0969DA?style=for-the-badge&logoColor=white" alt="English Version"></a>
</p>

---

## 📋 Descripción

Bootcamp intensivo de **10 semanas (~2.5 meses)** enfocado en el dominio de **GNU Make** como herramienta de automatización y build system. Diseñado para llevar a desarrolladores de un uso básico a **dominio avanzado**, con énfasis en proyectos reales, patrones profesionales y técnicas de DevOps.

### 🎯 Objetivos

Al finalizar el bootcamp, los estudiantes serán capaces de:

- ✅ Escribir Makefiles idiomáticos con targets, dependencias y recetas correctas
- ✅ Dominar los tipos de variables (`=`, `:=`, `?=`, `+=`) y su expansión
- ✅ Usar variables automáticas (`$@`, `$<`, `$^`, `$?`, `$*`) con fluidez
- ✅ Crear reglas de patrón genéricas (`%.o: %.c`) y static pattern rules
- ✅ Aplicar funciones de texto y archivo (`$(wildcard)`, `$(patsubst)`, `$(filter)`)
- ✅ Usar funciones avanzadas (`$(foreach)`, `$(call)`, `$(eval)`, `$(shell)`)
- ✅ Integrar Make con proyectos Python, Docker y Node.js
- ✅ Construir pipelines CI/CD locales con Make como orquestador
- ✅ Aplicar técnicas avanzadas: condicionales, `include`, recursión, depuración
- ✅ Diseñar build systems modulares y reutilizables listos para producción

### 🔧 ¿Por qué GNU Make?

> **Make moderno desde el día 1** — Sin antipatrones legacy, solo las mejores prácticas actuales.

GNU Make lleva más de 40 años siendo la columna vertebral de los build systems más críticos del mundo. Este bootcamp demuestra que Make no es una herramienta antigua: es la herramienta de automatización más ubicua, portable y poderosa disponible en cualquier sistema Unix. Los estudiantes aprenden directamente los patrones que encontrarán en proyectos reales de Linux, Open Source y DevOps.

---

## 🗓️ Estructura del Bootcamp

|         Etapa          | Semanas | Horas | Temas Principales                                              |
| :--------------------: | :-----: | :---: | -------------------------------------------------------------- |
| **Fundamentos**        |   1-2   |  16h  | Targets, variables, dependencias, `.PHONY`                     |
| **Intermedio**         |   3-5   |  24h  | Variables automáticas, pattern rules, funciones                |
| **Avanzado**           |   6-8   |  24h  | Funciones avanzadas, proyectos modernos, DevOps                |
| **Producción**         |  9-10   |  16h  | Técnicas avanzadas, proyecto integrador                        |

**Total: 10 semanas** | **80 horas** de formación intensiva

---

## 📚 Contenido por Semana

Cada semana incluye:

```
bootcamp/week-NN-nombre_del_tema/
├── README.md                  # Descripción y objetivos
├── rubrica-evaluacion.md      # Criterios de evaluación
├── 0-assets/                  # Diagramas Mermaid
├── 1-teoria/                  # Contexto mínimo (≤ 30 min)
├── 2-practicas/               # 5-6 labs progresivos (~50 min c/u)
├── 3-proyecto/                # Proyecto semanal integrador (2h 30min)
├── 4-recursos/                # Recursos adicionales
│   ├── ebooks-free/
│   ├── videografia/
│   └── webgrafia/
└── 5-glosario/                # Términos clave de la semana
```

### 🗺️ Plan de 10 Semanas

| Semana | Tema | Proyecto Semanal |
|--------|------|-----------------|
| [01 — Tu primer Makefile](bootcamp/week-01-tu_primer_makefile/) | Targets, dependencias, recetas, `.PHONY` | Makefile para sitio estático |
| [02 — Variables y Expansión](bootcamp/week-02-variables_y_expansion/) | `=` `:=` `?=` `+=`, override CLI | Makefile parametrizable multi-entorno |
| [03 — Variables Automáticas](bootcamp/week-03-variables_automaticas/) | `$@` `$<` `$^` `$?` `$*` `$(@D)` | Build system para proyecto C multi-archivo |
| [04 — Reglas de Patrón](bootcamp/week-04-reglas_de_patron/) | Pattern rules `%.o: %.c`, static pattern rules | Compilador genérico para C |
| [05 — Funciones de Texto y Archivo](bootcamp/week-05-funciones_de_texto_y_archivo/) | `$(wildcard)` `$(patsubst)` `$(filter)` `$(dir)` | Generador automático de reglas |
| [06 — Funciones Avanzadas](bootcamp/week-06-funciones_avanzadas/) | `$(foreach)` `$(call)` `$(eval)` `$(shell)` | Meta-Makefile: Makefiles que se generan solos |
| [07 — Make para Proyectos Modernos](bootcamp/week-07-makefiles_para_proyectos_modernos/) | Python, Docker, Node.js con Make | Makefile de microservicio listo para producción |
| [08 — Make como Orquestador DevOps](bootcamp/week-08-make_como_orquestador_devops/) | CI/CD local, git hooks, `.env`, secrets | Pipeline local completo |
| [09 — Técnicas Avanzadas](bootcamp/week-09-tecnicas_avanzadas/) | Condicionales, `include`, recursión, depuración | Makefile modular reutilizable |
| [10 — Proyecto Integrador](bootcamp/week-10-proyecto_integrador/) | Integración de todo lo aprendido | Build system multi-lenguaje con Make |

### 🔑 Componentes Clave

- 📖 **Teoría**: Contexto mínimo indispensable (máx. 30 min/semana)
- 💻 **Práctica**: 5-6 labs progresivos con starter + solución de referencia
- 🐛 **Debugging**: Labs con errores intencionados para desarrollar criterio real
- 📝 **Evaluación**: Rúbrica con criterios verificables por comandos `make`
- 🎓 **Recursos**: Glosario, ebooks gratuitos, videografía y webgrafía

---

## 🛠️ Herramientas

| Herramienta | Versión | Uso |
|-------------|---------|-----|
| GNU Make    | **≥ 4.x** | Herramienta central del bootcamp |
| GCC / Clang | cualquiera | Semanas 3-4 (proyectos C) |
| Python      | **3.x**   | Semana 7 (integración Make + Python) |
| Docker      | cualquiera | Semana 7-8 (integración Make + Docker) |
| Node.js     | **≥ 20**  | Semana 7 (integración Make + Node.js) |
| Git         | cualquiera | Control de versiones |
| VS Code     | última     | Editor recomendado |

**Entorno de desarrollo**: Linux, macOS o WSL2 en Windows — GNU Make disponible por defecto.

**Verificar instalación**: `make --version` debe mostrar `GNU Make 4.x` o superior.

---

## 🚀 Inicio Rápido

### Prerrequisitos

- **GNU Make ≥ 4.x** instalado (`make --version`)
- **Git** para control de versiones
- **VS Code** (recomendado) con extensiones incluidas
- Terminal Linux/macOS o WSL2 en Windows

### 1. Clonar el Repositorio

```bash
git clone https://github.com/ergrato-dev/bc-makefile.git
cd bc-makefile
```

### 2. Instalar Extensiones de VS Code

```bash
# Abrir en VS Code
code .

# Las extensiones recomendadas aparecerán automáticamente
# O ejecutar: Ctrl+Shift+P → "Extensions: Show Recommended Extensions"
```

### 3. Navegar a la Semana Actual

```bash
cd bootcamp/week-01-tu_primer_makefile
```

### 4. Seguir las Instrucciones

Cada semana contiene un `README.md` con instrucciones detalladas, tiempo estimado y criterios de éxito verificables.

---

## 📊 Metodología de Aprendizaje

### Estrategias Didácticas

- 🎯 **Aprendizaje Basado en Proyectos (ABP)**
- 🧩 **Práctica Deliberada** — labs progresivos con dificultad incremental
- 🐛 **Debugging Intencional** — errores reales para desarrollar criterio
- 🔄 **Build Challenges** — problemas de automatización del mundo real
- 👥 **Code Review entre pares**
- 🎮 **Live Coding**

### Distribución del Tiempo (8h/semana)

- **Teoría**: 30 minutos
- **Prácticas**: 5 horas (5-6 labs × ~50 min)
- **Proyecto**: 2 horas 30 minutos

### Evaluación

Cada semana incluye tres tipos de evidencias:

1. **Labs completados 💻** (50%): 5-6 labs con outputs verificables (`make <target>`)
2. **Proyecto semanal funcional 📦** (30%): Makefile integrador que pasa todos los tests
3. **Calidad del Makefile 🏗️** (20%): `.PHONY`, `help`, estilo, variables correctas

**Criterio de aprobación**: Mínimo 70% en total.

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

- [GNU Make](https://www.gnu.org/software/make/) — Por cuatro décadas siendo el build system más confiable del mundo
- [GNU Make Manual](https://www.gnu.org/software/make/manual/) — La documentación oficial más completa
- Comunidad Open Source — Por proyectos reales donde Make sigue siendo el estándar
- Todos los contribuidores

---

## 📚 Documentación Adicional

- [📜 Código de Conducta](CODE_OF_CONDUCT.md)
- [🔒 Política de Seguridad](SECURITY.md)

---

<p align="center">
  <strong>🎓 Bootcamp GNU Make — Domina el Build System</strong><br>
  <em>De usuario básico a experto en automatización en 10 semanas</em>
</p>

<p align="center">
  <a href="bootcamp/week-01-tu_primer_makefile">Comenzar Semana 1</a> •
  <a href="https://github.com/ergrato-dev/bc-makefile/issues">Reportar Issue</a>
</p>

<p align="center">
  Hecho con ❤️ para la comunidad de desarrolladores
</p>
