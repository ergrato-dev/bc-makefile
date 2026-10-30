#include "math_ops.h"

int math_sum(int a, int b) {
    return a + b;
}

int math_product(int a, int b) {
    return a * b;
}

int math_power(int base, int exp) {
    int result = 1;
    for (int i = 0; i < exp; i++)
        result *= base;
    return result;
}
