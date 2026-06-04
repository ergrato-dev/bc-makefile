def procesar(datos):
    resultado = []
    for item in datos:
        if item > 0:
            resultado.append(item * 2)
    return resultado


def calcular_promedio(lista):
    if not lista:
        return 0
    return sum(lista) / len(lista)
