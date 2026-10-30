from src.main import notificar


def test_notificar():
    resultado = notificar("user@test.com", "Hola")
    assert resultado["destinatario"] == "user@test.com"
    assert resultado["mensaje"] == "Hola"
    assert resultado["enviado"] is True


def test_notificar_vacio():
    resultado = notificar("", "")
    assert resultado["enviado"] is True
