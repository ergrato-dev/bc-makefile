# Webgrafía — Semana 11

| Recurso | Descripción |
|---------|-------------|
| [GNU Make — Empty Target Files](https://www.gnu.org/software/make/manual/html_node/Empty-Targets.html) | El patrón sentinel en el manual oficial: un archivo vacío cuya fecha registra cuándo corrió la receta |
| [uv — Locking and syncing](https://docs.astral.sh/uv/concepts/projects/sync/) | Qué hacen `uv sync`, `--locked`, `--frozen`, `--no-dev`, `--inexact` y `uv run --no-sync` |
| [Ruff — The Ruff Formatter](https://docs.astral.sh/ruff/formatter/) | `ruff format` y `ruff format --check`: lo que usa el target `check` del proyecto |
| [pnpm install](https://pnpm.io/cli/install) | Opciones de `pnpm install`, incluido `--frozen-lockfile` |
| [docker buildx build](https://docs.docker.com/reference/cli/docker/buildx/build/) | Flags de `docker build`: `--build-arg`, `--tag`, `--iidfile` |
| [Compose — Interpolation](https://docs.docker.com/reference/compose-file/interpolation/) | Sintaxis `${VAR:?mensaje}` que usa el lab 04 para exigir la contraseña en `.env` |
| [How to replace tox with uv and a Makefile](https://pydevtools.com/handbook/how-to/how-to-replace-tox-with-uv-and-a-makefile/) | Makefile con targets `uv run` para tests, `ruff check` y `ruff format` |
