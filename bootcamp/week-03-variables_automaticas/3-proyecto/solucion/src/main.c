#include <stdio.h>
#include "greet.h"
#include "calc.h"

int main(void) {
    greet("Make");
    printf("suma(3, 4) = %d\n", suma(3, 4));
    printf("producto(3, 4) = %d\n", producto(3, 4));
    return 0;
}
