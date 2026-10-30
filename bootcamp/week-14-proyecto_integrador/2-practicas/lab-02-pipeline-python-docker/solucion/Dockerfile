FROM python:3.14-slim

WORKDIR /app

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY src/ ./src/

# Nunca como root: si la app se compromete, el atacante no es root en el contenedor
RUN useradd --system --uid 10001 app
USER app

CMD ["python", "src/app.py"]
