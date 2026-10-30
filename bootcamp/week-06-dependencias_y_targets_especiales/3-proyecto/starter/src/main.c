#include <stdio.h>
#include "calc.h"
#include "fmt.h"
#include "version.h"

int main(void) {
    printf("calc v%s\n", version_string());
    imprimir("suma", 3, 4, suma(3, 4));
    imprimir("producto", 3, 4, producto(3, 4));
    return 0;
}
