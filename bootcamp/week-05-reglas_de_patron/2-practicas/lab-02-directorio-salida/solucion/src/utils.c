#include <ctype.h>
#include "utils.h"

int add(int a, int b) {
    return a + b;
}

void to_uppercase(char *s) {
    for (; *s; s++)
        *s = (char)toupper((unsigned char)*s);
}
