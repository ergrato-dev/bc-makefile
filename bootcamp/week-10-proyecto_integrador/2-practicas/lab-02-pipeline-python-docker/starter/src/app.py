def greet(name: str) -> str:
    return f"Hola, {name}!"


def add(a: int, b: int) -> int:
    return a + b


if __name__ == "__main__":
    print(greet("mundo"))
    print(f"2 + 3 = {add(2, 3)}")
