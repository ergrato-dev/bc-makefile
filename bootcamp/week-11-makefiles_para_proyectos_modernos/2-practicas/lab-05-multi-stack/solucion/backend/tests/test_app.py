import sys
import os
sys.path.insert(0, os.path.join(os.path.dirname(__file__), '..'))

from src.app import saludar, sumar


def test_saludar():
    assert saludar("mundo") == "Hola desde backend, mundo!"


def test_sumar():
    assert sumar(2, 3) == 5
