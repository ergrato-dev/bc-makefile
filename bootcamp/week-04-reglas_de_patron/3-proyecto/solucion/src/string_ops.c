#include <ctype.h>
#include "string_ops.h"

void str_upper(char *s) {
    for (; *s; s++)
        *s = (char)toupper((unsigned char)*s);
}

int str_length(const char *s) {
    int n = 0;
    while (*s++) n++;
    return n;
}
