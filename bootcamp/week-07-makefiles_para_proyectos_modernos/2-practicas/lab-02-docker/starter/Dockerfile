FROM python:3.11-slim

ARG VERSION=unknown
ARG BUILD_DATE=unknown

LABEL version="${VERSION}"
LABEL build-date="${BUILD_DATE}"

WORKDIR /app
COPY app.py .

ENV APP_VERSION=${VERSION}

CMD ["python", "app.py"]
