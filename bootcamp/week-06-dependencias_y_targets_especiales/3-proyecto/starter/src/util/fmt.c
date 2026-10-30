#include <stdio.h>
#include "fmt.h"

void imprimir(const char *operacion, int a, int b, int resultado) {
    printf("%s(%d, %d) = %d\n", operacion, a, b, resultado);
}
