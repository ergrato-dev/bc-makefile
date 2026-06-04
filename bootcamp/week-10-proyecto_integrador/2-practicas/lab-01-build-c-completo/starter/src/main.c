#include <stdio.h>
#include "config.h"
#include "math_utils.h"

int main(void) {
    printf("%s v%s\n", APP_NAME, APP_VERSION);
    printf("add(3, 4)      = %d\n", add(3, 4));
    printf("multiply(3, 4) = %d\n", multiply(3, 4));
    return 0;
}
