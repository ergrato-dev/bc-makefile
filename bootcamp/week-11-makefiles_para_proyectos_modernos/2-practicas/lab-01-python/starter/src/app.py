def saludar(nombre: str) -> str:
    return f"Hola, {nombre}!"


def sumar(a: int, b: int) -> int:
    return a + b


if __name__ == "__main__":
    print(saludar("mundo"))
    print(f"2 + 3 = {sumar(2, 3)}")
