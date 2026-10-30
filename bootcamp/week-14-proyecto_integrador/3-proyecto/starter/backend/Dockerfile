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
EXPOSE 8000
# TODO: el contenedor no puede correr como root. Declara un USER sin
# privilegios antes del CMD (lab-02, pasos 7 y 8).

CMD ["python", "src/app.py"]
