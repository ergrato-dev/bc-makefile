FROM python:3.11-slim

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

CMD ["python", "src/main.py"]
