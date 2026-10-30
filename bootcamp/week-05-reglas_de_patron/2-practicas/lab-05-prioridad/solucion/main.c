#include <stdio.h>

void normal_module(void);
void debug_module(void);

int main(void) {
    normal_module();
    debug_module();
    return 0;
}
