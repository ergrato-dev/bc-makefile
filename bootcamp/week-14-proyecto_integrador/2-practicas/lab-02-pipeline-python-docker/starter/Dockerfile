FROM python:3.14-slim
# uv como binario fijado desde su imagen oficial: sin pip en ningún paso
COPY --from=ghcr.io/astral-sh/uv:0.12.2 /uv /bin/uv
# Usa el Python de la imagen; nunca descargues otro a escondidas
ENV UV_PYTHON_DOWNLOADS=never

WORKDIR /app

# Solo dependencias de producción (sin grupo dev), exactamente las de uv.lock
COPY pyproject.toml uv.lock ./
RUN uv sync --locked --no-dev --no-cache
ENV PATH="/app/.venv/bin:$PATH"

COPY src/ ./src/

# TODO: crea un usuario de sistema (useradd --system --uid 10001 app) y
# cámbiate a él con USER antes del CMD. Sin USER, el contenedor corre como
# root y  falla.

CMD ["python", "src/app.py"]
