#include "calc.h"

int media(const int *valores, int n) {
    int total = 0;
    for (int i = 0; i < n; i++) total += valores[i];
    return n > 0 ? total / n : 0;
}
