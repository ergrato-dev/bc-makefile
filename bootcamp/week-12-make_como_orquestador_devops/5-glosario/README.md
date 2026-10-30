# Glosario — Semana 12

| Término | Definición en una línea | Ejemplo en Makefile |
|---------|------------------------|---------------------|
| `.env` | Archivo local de configuración que Make lee como si fuera un Makefile (`$` se expande, comillas literales, `#` corta) | `-include .env` |
| `.env.example` | Plantilla versionada con los nombres de variable y sin valores reales | `cp .env.example .env` antes de `make env-check` |
| export selectivo | `export` con lista: solo esas variables llegan al entorno de las recetas | `export DB_URL API_KEY` (nunca `export` a secas) |
| guard target | Regla de patrón que valida en Make que una variable existe, sin pasar su valor por el shell | `guard-%: ; @$(if $($*),:,$(error $* no definida))` |
| git hook | Script que git ejecuta en un evento (commit, push) y que puede abortarlo saliendo con ≠ 0 | `scripts/hooks/pre-commit` |
| `core.hooksPath` | Opción de git que indica de qué directorio leer los hooks, en lugar de `.git/hooks/` | `git config core.hooksPath '$(CURDIR)/scripts/hooks'` |
| `--no-verify` | Flag de `git commit`/`git push` que salta los hooks: por eso son ayuda, no control | `git commit --no-verify -m wip` |
| paridad local/CI | El runner ejecuta exactamente el mismo target que el desarrollador | `- run: make ci` como único paso del workflow |
| pin por SHA | Fijar una acción de GitHub Actions al hash de 40 caracteres de su commit, que no se puede mover | `uses: actions/checkout@3d3c42e5...b1 # v7.0.1` |
| `permissions` | Bloque del workflow que limita lo que puede hacer el token del job | `permissions: contents: read` |
| keep going (`-k`) | Make sigue con los targets que no dependen del que falló y sale igualmente con ≠ 0 | `lint-all: ; @$(MAKE) -k lint` |
| SemVer | Versionado `MAYOR.MENOR.PARCHE` con reglas de compatibilidad | `VERSION := $(strip $(file < VERSION))` |
| bump | Incrementar una componente de la versión y reiniciar las de la derecha | `make bump-minor` → `1.4.2` pasa a `1.5.0` |
| tag anotado | Etiqueta de git con autor, fecha y mensaje que marca un release | `git tag -a "v$(VERSION)" -m "Release v$(VERSION)"` |
| `--warn-undefined-variables` | Opción de Make que avisa cada vez que se expande una variable no definida | `make --warn-undefined-variables -n ci` |
