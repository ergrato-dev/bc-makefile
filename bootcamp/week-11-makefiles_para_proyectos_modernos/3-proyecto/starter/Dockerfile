FROM python:3.14-slim
# uv como binario fijado desde su imagen oficial: sin pip en ningún paso
COPY --from=ghcr.io/astral-sh/uv:0.12.2 /uv /bin/uv
# Usa el Python de la imagen; nunca descargues otro a escondidas
ENV UV_PYTHON_DOWNLOADS=never

ARG VERSION=unknown
ARG BUILD_DATE=unknown

LABEL version="${VERSION}"
LABEL build-date="${BUILD_DATE}"
LABEL maintainer="tu-equipo@empresa.com"

WORKDIR /app

# Solo dependencias de producción (sin grupo dev), exactamente las de uv.lock
COPY pyproject.toml uv.lock ./
RUN uv sync --locked --no-dev --no-cache
ENV PATH="/app/.venv/bin:$PATH"

COPY src/ ./src/

ENV APP_VERSION=${VERSION}
ENV ENV=prod

# Nunca como root: si la app se compromete, el atacante no es root en el contenedor
RUN useradd --system --uid 10001 app
USER app

CMD ["python", "src/main.py"]
