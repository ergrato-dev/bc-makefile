FROM python:3.14-slim

ARG VERSION=unknown
ARG BUILD_DATE=unknown

LABEL version="${VERSION}"
LABEL build-date="${BUILD_DATE}"

WORKDIR /app
COPY app.py .

ENV APP_VERSION=${VERSION}

# Nunca como root: si la app se compromete, el atacante no es root en el contenedor
RUN useradd --system --uid 10001 app
USER app

CMD ["python", "app.py"]
