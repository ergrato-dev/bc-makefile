import os

version = os.environ.get("APP_VERSION", "desconocida")
print(f"Hola desde Docker! Versión: {version}")
