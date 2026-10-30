import pytest
import sys
import os
sys.path.insert(0, os.path.join(os.path.dirname(__file__), '..', 'src'))

from calculadora import sumar, restar, multiplicar, dividir


def test_sumar():
    assert sumar(2, 3) == 5


def test_restar():
    assert restar(5, 3) == 2


def test_multiplicar():
    assert multiplicar(4, 3) == 12


def test_dividir():
    assert dividir(10, 2) == 5.0


def test_dividir_por_cero():
    with pytest.raises(ValueError):
        dividir(10, 0)
