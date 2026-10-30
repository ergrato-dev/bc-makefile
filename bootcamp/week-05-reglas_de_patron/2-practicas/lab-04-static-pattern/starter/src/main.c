#include <stdio.h>
#include "math_ops.h"
#include "string_ops.h"

int main(void) {
    printf("suma(3, 4) = %d\n", sum(3, 4));
    printf("producto(3, 4) = %d\n", product(3, 4));
    char buf[64] = "hola";
    str_uppercase(buf);
    printf("uppercase: %s\n", buf);
    return 0;
}
