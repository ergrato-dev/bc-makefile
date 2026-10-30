#include <stdio.h>
#include "build_info.h"
#include "util.h"

int main(void) {
    printf("app %s\n", build_version());
    printf("doble(21) = %d\n", doble(21));
    return 0;
}
