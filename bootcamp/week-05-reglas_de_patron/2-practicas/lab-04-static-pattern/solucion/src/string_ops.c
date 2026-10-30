#include <ctype.h>
#include "string_ops.h"

void str_uppercase(char *s) {
    for (; *s; s++)
        *s = (char)toupper((unsigned char)*s);
}
