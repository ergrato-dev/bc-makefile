# Glosario — Semana 12

| Término | Definición en una línea | Ejemplo en Makefile |
|---------|------------------------|---------------------|
| pipeline | Secuencia de etapas donde cada una depende del éxito de la anterior | `ci: lint test build report` |
| git hook | Script ejecutado por git antes o después de operaciones como commit o push | `cp scripts/hooks/pre-commit .git/hooks/pre-commit` |
| pre-commit | Hook que git ejecuta antes de crear el commit; si sale con ≠ 0, el commit no ocurre | `hooks-install: @cp ... && chmod +x ...` |
| pre-push | Hook que git ejecuta antes de enviar commits al remoto; más lento que pre-commit | `$(HOOKS_DIR)/pre-push: $(HOOKS_SRC)/pre-push` |
| guard target | Patrón Make para validar que una variable esté definida antes de continuar | `guard-%: @test -n "${$*}" \|\| (echo "ERROR: $*"; exit 1)` |
| `-include` | Directiva Make que carga un archivo sin abortar si no existe | `-include .env` |
| `export` | Directiva Make que propaga todas las variables al entorno del shell de las recetas | `export` (sin argumentos = exporta todo) |
| SemVer | Versionado semántico: MAJOR.MINOR.PATCH con reglas de compatibilidad | `VERSION := 1.4.2` |
| bump-patch | Incrementar el tercer número de versión; indica corrección de bug sin cambios de API | `make bump-patch` → 0.1.0 → 0.1.1 |
| changelog | Archivo que registra cambios entre versiones del proyecto de forma legible | `CHANGELOG.md` generado por `make changelog` |
| fail fast | Propiedad de un pipeline que aborta en la primera etapa que falla | Make aborta en `lint` si su exit code ≠ 0 |
| sentinel file | Archivo vacío que Make usa para trackear cuándo se ejecutó un comando sin salida | `.venv/.installed: pyproject.toml uv.lock` |
| análisis estático | Análisis del código fuente sin ejecutarlo para detectar errores o estilo | `flake8 src/` en el target `lint` |
| `exit code` | Código de retorno de un proceso: 0 = éxito, ≠ 0 = error | `@test -n "$$VAR" \|\| exit 1` |
