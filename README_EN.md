<p align="center">
  <img src="assets/bootcamp-header.svg" alt="GNU Make Bootcamp — Master the Build System" width="800">
</p>

<p align="center">
  <a href="LICENSE"><img src="https://img.shields.io/badge/license-CC%20BY--NC--SA%204.0-lightgrey.svg" alt="License CC BY-NC-SA 4.0"></a>
  <a href="#"><img src="https://img.shields.io/badge/weeks-10-yellow.svg" alt="10 Weeks"></a>
  <a href="#"><img src="https://img.shields.io/badge/hours-80-orange.svg" alt="80 Hours"></a>
  <a href="#"><img src="https://img.shields.io/badge/GNU%20Make-≥4.x-A42E2B?logo=gnu&logoColor=white" alt="GNU Make"></a>
</p>

<p align="center">
  <a href="README.md"><img src="https://img.shields.io/badge/🇪🇸_Español-0969DA?style=for-the-badge&logoColor=white" alt="Spanish Version"></a>
</p>

---

## 📋 Description

Intensive **10-week (~2.5 months)** bootcamp focused on mastering **GNU Make** as an automation and build system tool. Designed to take developers from basic usage to **advanced mastery**, with emphasis on real projects, professional patterns, and DevOps techniques.

### 🎯 Objectives

Upon completion of the bootcamp, students will be able to:

- ✅ Write idiomatic Makefiles with correct targets, dependencies, and recipes
- ✅ Master variable types (`=`, `:=`, `?=`, `+=`) and their expansion rules
- ✅ Use automatic variables (`$@`, `$<`, `$^`, `$?`, `$*`) fluently
- ✅ Create generic pattern rules (`%.o: %.c`) and static pattern rules
- ✅ Apply text and file functions (`$(wildcard)`, `$(patsubst)`, `$(filter)`)
- ✅ Use advanced functions (`$(foreach)`, `$(call)`, `$(eval)`, `$(shell)`)
- ✅ Integrate Make with Python, Docker, and Node.js projects
- ✅ Build local CI/CD pipelines with Make as the orchestrator
- ✅ Apply advanced techniques: conditionals, `include`, recursion, debugging
- ✅ Design modular and reusable build systems ready for production

### 🔧 Why GNU Make?

> **Modern Make from day 1** — No legacy antipatterns, only current best practices.

GNU Make has been the backbone of the world's most critical build systems for over 40 years. This bootcamp demonstrates that Make is not an old tool: it is the most ubiquitous, portable, and powerful automation tool available on any Unix system. Students learn directly the patterns they will encounter in real Linux, Open Source, and DevOps projects.

---

## 🗓️ Bootcamp Structure

|         Stage          | Weeks | Hours | Main Topics                                                  |
| :--------------------: | :---: | :---: | ------------------------------------------------------------ |
| **Fundamentals**       |  1-2  |  16h  | Targets, variables, dependencies, `.PHONY`                   |
| **Intermediate**       |  3-5  |  24h  | Automatic variables, pattern rules, functions                |
| **Advanced**           |  6-8  |  24h  | Advanced functions, modern projects, DevOps                  |
| **Production**         | 9-10  |  16h  | Advanced techniques, integrator project                      |

**Total: 10 weeks** | **80 hours** of intensive training

---

## 📚 Weekly Content

Each week includes:

```
bootcamp/week-NN-topic_name/
├── README.md                  # Description and objectives
├── rubrica-evaluacion.md      # Evaluation criteria
├── 0-assets/                  # Mermaid diagrams
├── 1-teoria/                  # Minimal context (≤ 30 min)
├── 2-practicas/               # 5-6 progressive labs (~50 min each)
├── 3-proyecto/                # Weekly integrator project (2h 30min)
├── 4-recursos/                # Additional resources
│   ├── ebooks-free/
│   ├── videografia/
│   └── webgrafia/
└── 5-glosario/                # Key terms for the week
```

### 🗺️ 10-Week Plan

| Week | Topic | Weekly Project |
|------|-------|----------------|
| [01 — Your First Makefile](bootcamp/week-01-tu_primer_makefile/) | Targets, dependencies, recipes, `.PHONY` | Makefile for static site |
| [02 — Variables & Expansion](bootcamp/week-02-variables_y_expansion/) | `=` `:=` `?=` `+=`, CLI override | Parametrizable multi-environment Makefile |
| [03 — Automatic Variables](bootcamp/week-03-variables_automaticas/) | `$@` `$<` `$^` `$?` `$*` `$(@D)` | Build system for multi-file C project |
| [04 — Pattern Rules](bootcamp/week-04-reglas_de_patron/) | Pattern rules `%.o: %.c`, static pattern rules | Generic C compiler Makefile |
| [05 — Text & File Functions](bootcamp/week-05-funciones_de_texto_y_archivo/) | `$(wildcard)` `$(patsubst)` `$(filter)` `$(dir)` | Automatic rule generator |
| [06 — Advanced Functions](bootcamp/week-06-funciones_avanzadas/) | `$(foreach)` `$(call)` `$(eval)` `$(shell)` | Meta-Makefile: Makefiles that generate themselves |
| [07 — Make for Modern Projects](bootcamp/week-07-makefiles_para_proyectos_modernos/) | Python, Docker, Node.js with Make | Production-ready microservice Makefile |
| [08 — Make as DevOps Orchestrator](bootcamp/week-08-make_como_orquestador_devops/) | Local CI/CD, git hooks, `.env`, secrets | Complete local pipeline |
| [09 — Advanced Techniques](bootcamp/week-09-tecnicas_avanzadas/) | Conditionals, `include`, recursion, debugging | Reusable modular Makefile |
| [10 — Integrator Project](bootcamp/week-10-proyecto_integrador/) | Integration of everything learned | Multi-language build system with Make |

### 🔑 Key Components

- 📖 **Theory**: Minimal essential context (max 30 min/week)
- 💻 **Practice**: 5-6 progressive labs with starter + reference solution
- 🐛 **Debugging**: Intentional errors to develop real troubleshooting skills
- 📝 **Evaluation**: Rubric with criteria verifiable via `make` commands
- 🎓 **Resources**: Glossary, free ebooks, videography, and webgraphy

---

## 🛠️ Tools

| Tool        | Version    | Usage |
|-------------|------------|-------|
| GNU Make    | **≥ 4.x**  | Core bootcamp tool |
| GCC / Clang | any        | Weeks 3-4 (C projects) |
| Python      | **3.x**    | Week 7 (Make + Python integration) |
| Docker      | any        | Weeks 7-8 (Make + Docker integration) |
| Node.js     | **≥ 20**   | Week 7 (Make + Node.js integration) |
| Git         | any        | Version control |
| VS Code     | latest     | Recommended editor |

**Development environment**: Linux, macOS, or WSL2 on Windows — GNU Make available by default.

**Verify installation**: `make --version` should show `GNU Make 4.x` or higher.

---

## 🚀 Quick Start

### Prerequisites

- **GNU Make ≥ 4.x** installed (`make --version`)
- **Git** for version control
- **VS Code** (recommended) with included extensions
- Linux/macOS terminal or WSL2 on Windows

### 1. Clone the Repository

```bash
git clone https://github.com/ergrato-dev/bc-makefile.git
cd bc-makefile
```

### 2. Install VS Code Extensions

```bash
# Open in VS Code
code .

# Recommended extensions will appear automatically
# Or run: Ctrl+Shift+P → "Extensions: Show Recommended Extensions"
```

### 3. Navigate to the Current Week

```bash
cd bootcamp/week-01-tu_primer_makefile
```

### 4. Follow the Instructions

Each week contains a `README.md` with detailed instructions, estimated time, and verifiable success criteria.

---

## 📊 Learning Methodology

### Teaching Strategies

- 🎯 **Project-Based Learning (PBL)**
- 🧩 **Deliberate Practice** — progressive labs with incremental difficulty
- 🐛 **Intentional Debugging** — real errors to develop genuine troubleshooting skills
- 🔄 **Build Challenges** — real-world automation problems
- 👥 **Peer Code Review**
- 🎮 **Live Coding**

### Time Distribution (8h/week)

- **Theory**: 30 minutes
- **Practice**: 5 hours (5-6 labs × ~50 min)
- **Project**: 2 hours 30 minutes

### Evaluation

Each week includes three types of evidence:

1. **Completed Labs 💻** (50%): 5-6 labs with verifiable outputs (`make <target>`)
2. **Functional Weekly Project 📦** (30%): Integrator Makefile that passes all tests
3. **Makefile Quality 🏗️** (20%): `.PHONY`, `help` target, style, correct variables

**Passing criteria**: Minimum 70% overall.

---

## 📞 Support

- 💬 **Discussions**: [GitHub Discussions](https://github.com/ergrato-dev/bc-makefile/discussions)
- 🐛 **Issues**: [GitHub Issues](https://github.com/ergrato-dev/bc-makefile/issues)

---

## ⚠️ Disclaimer

This repository is an **educational** resource created for learning purposes. By using it, you agree to the following terms:

- **Educational purposes only**: The content, code examples, and projects are designed exclusively for teaching and learning. They do not constitute professional, legal, or security advice.
- **No warranties**: The material is provided **"as is"**, without warranties of any kind, express or implied, including fitness for a particular purpose or freedom from errors.
- **Production code**: Code examples are illustrative. Before using them in production environments, you must perform security, performance, and context-specific reviews.
- **Software versions**: Tool versions mentioned may become outdated. Always consult the latest official documentation.
- **Limitation of liability**: The authors and contributors are not responsible for data loss, direct or indirect damages, service interruptions, or any other harm arising from the use of this material.
- **Student responsibility**: Each student is responsible for their own implementations, development environments, and technical decisions.

---

## 📄 License

This project is licensed under **[CC BY-NC-SA 4.0](https://creativecommons.org/licenses/by-nc-sa/4.0/)** (Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International).

**You may:** share and adapt the material, including creating educational forks.<br>
**You may not:** use this material for commercial purposes.<br>
**You must:** give appropriate credit and distribute adaptations under the same license.

See the [LICENSE](LICENSE) file for the full text.

---

## 🏆 Acknowledgments

- [GNU Make](https://www.gnu.org/software/make/) — For four decades as the world's most reliable build system
- [GNU Make Manual](https://www.gnu.org/software/make/manual/) — The most comprehensive official documentation
- Open Source Community — For real projects where Make remains the standard
- All contributors

---

## 📚 Additional Documentation

- [📜 Code of Conduct](CODE_OF_CONDUCT.md)
- [🔒 Security Policy](SECURITY.md)

---

<p align="center">
  <strong>🎓 GNU Make Bootcamp — Master the Build System</strong><br>
  <em>From basic user to automation expert in 10 weeks</em>
</p>

<p align="center">
  <a href="bootcamp/week-01-tu_primer_makefile">Start Week 1</a> •
  <a href="https://github.com/ergrato-dev/bc-makefile/issues">Report Issue</a>
</p>

<p align="center">
  Made with ❤️ for the developer community
</p>
