from src.app import saludar, sumar


def test_saludar():
    assert saludar("mundo") == "Hola, mundo!"
    assert saludar("Python") == "Hola, Python!"


def test_sumar():
    assert sumar(2, 3) == 5
    assert sumar(-1, 1) == 0
    assert sumar(0, 0) == 0
