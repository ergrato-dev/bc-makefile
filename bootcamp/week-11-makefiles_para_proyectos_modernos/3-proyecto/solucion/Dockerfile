FROM python:3.14-slim

ARG VERSION=unknown
ARG BUILD_DATE=unknown

LABEL version="${VERSION}"
LABEL build-date="${BUILD_DATE}"
LABEL maintainer="tu-equipo@empresa.com"

WORKDIR /app

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY src/ ./src/

ENV APP_VERSION=${VERSION}
ENV ENV=prod

# Nunca como root: si la app se compromete, el atacante no es root en el contenedor
RUN useradd --system --uid 10001 app
USER app

CMD ["python", "src/main.py"]
