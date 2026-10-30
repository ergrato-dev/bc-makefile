#include "calc.h"
#include "fmt.h"

int main(void) {
    int datos[] = {4, 8, 15, 16, 23, 42};
    int n = (int)(sizeof datos / sizeof datos[0]);
    imprimir_media(n, media(datos, n));
    return 0;
}
