#include <stdio.h>
#include "utils.h"

int main(void) {
    printf("add(10, 5) = %d\n", add(10, 5));
    char buf[64] = "hola make";
    to_uppercase(buf);
    printf("uppercase: %s\n", buf);
    return 0;
}
