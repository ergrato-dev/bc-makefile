#include <stdio.h>
#include "colores.h"

int main(void) {
    for (int i = 0; i < COLORES_N; i++) {
        printf("%-6s #%06x\n", colores[i].nombre, colores[i].valor);
    }
    return 0;
}
