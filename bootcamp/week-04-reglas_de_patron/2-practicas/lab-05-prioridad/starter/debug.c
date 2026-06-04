#include <stdio.h>

void debug_module(void) {
#ifdef DEBUG
    printf("DEBUG: modulo debug activo\n");
#else
    printf("modulo debug (sin flag DEBUG)\n");
#endif
}
