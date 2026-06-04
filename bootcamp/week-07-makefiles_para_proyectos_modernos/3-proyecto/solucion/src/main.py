import os


def notificar(destinatario: str, mensaje: str) -> dict:
    env = os.environ.get("ENV", "dev")
    return {
        "destinatario": destinatario,
        "mensaje": mensaje,
        "entorno": env,
        "enviado": True,
    }


if __name__ == "__main__":
    resultado = notificar("equipo@empresa.com", "Servicio iniciado correctamente")
    print(f"Notificación enviada a {resultado['destinatario']} [{resultado['entorno']}]")
