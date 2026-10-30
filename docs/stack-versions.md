# Versiones del stack

Revisado: 2026-10-30. Se actualiza al inicio de cada cohorte.

## GNU Make

| Versión | Fecha | Dónde la encuentras | Uso en el bootcamp |
|---|---|---|---|
| 3.81 | 2006 | macOS (`/usr/bin/make`) | **No soportada.** Instala `gmake` con Homebrew |
| 4.3 | 2020 | Ubuntu 22.04 / 24.04, WSL | **Mínimo.** Todo el contenido funciona aquí |
| 4.4.1 | 2023-02 | Debian 13, Fedora, Arch, Homebrew | Última versión. Las features 4.4 van marcadas |

Features que exigen 4.4 y aparecen en recuadros **Make 4.4+** con su
alternativa para 4.3: `.WAIT`, `--shuffle`, `.NOTINTERMEDIATE`, `:::=`,
`$(let)`, `$(intcmp)`, `--jobserver-style=fifo`.

Features que exigen 4.3 (por eso es el mínimo): grouped targets `&:`,
`.EXTRA_PREREQS`.

Comprueba la tuya:

```bash
make --version | head -1
```

## Toolchain C (semanas 04–10 y 14)

| Herramienta | Versión mínima |
|---|---|
| gcc | 11 |
| clang (alternativa) | 14 |

## Stack moderno (semanas 11–14)

| Herramienta | Versión fijada | Notas |
|---|---|---|
| Python | 3.14 | 3.15 salió el 2026-10-09; se adopta cuando el ecosistema la soporte |
| uv | 0.12.x | Gestor de proyectos Python. **Nunca pip.** `pyproject.toml` + `uv.lock` comiteado, `uv sync --locked`, `uv run`. En Docker: `COPY --from=ghcr.io/astral-sh/uv:0.12.2` |
| ruff | 0.16.x | Lint + formato (`uv run --no-sync ruff check`, `ruff format`). Fijado en el grupo dev de `pyproject.toml` |
| pytest | 9.x | Grupo `dev` de `pyproject.toml` |
| Node.js | 26 LTS | Active LTS desde 2026-10-28. 24 sigue en Maintenance LTS |
| pnpm | 11.x | Gestor de paquetes Node.js. **Nunca npm.** Siempre `pnpm install --frozen-lockfile` con `pnpm-lock.yaml` comiteado |
| Docker Engine | 27+ | |
| Docker Compose | v2 (`docker compose`) | v1 (`docker-compose`) está en EOL desde 2023 |

## Imágenes base

| Imagen | Uso |
|---|---|
| `python:3.14-slim` | Servicios Python |
| `node:26-alpine` | Servicios Node |
| `postgres:18-alpine` | Base de datos en compose |
| `nginx:1.30-alpine` | Proxy / estáticos |

Las imágenes llevan siempre tag de versión, nunca `latest`. Todas corren con
usuario no-root.
