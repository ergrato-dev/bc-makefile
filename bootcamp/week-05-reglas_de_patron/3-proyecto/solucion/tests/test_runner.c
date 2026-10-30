#include <stdio.h>
#include "math_ops.h"

static int fallos = 0;

#define ASSERT_EQ(name, got, expected) \
    do { \
        if ((got) == (expected)) { \
            printf("[PASS] %s\n", name); \
        } else { \
            printf("[FAIL] %s: got %d, expected %d\n", name, got, expected); \
            fallos++; \
        } \
    } while (0)

int main(void) {
    ASSERT_EQ("test_sum",     math_sum(3, 4),     7);
    ASSERT_EQ("test_product", math_product(3, 4), 12);
    ASSERT_EQ("test_power",   math_power(2, 8),   256);
    if (fallos > 0) {
        printf("%d test(s) fallaron.\n", fallos);
        return 1;
    }
    printf("Todos los tests pasaron.\n");
    return 0;
}
