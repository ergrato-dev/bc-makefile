#include <stdio.h>

void plugin_init(void) { printf("[compress] inicializado\n"); }
void plugin_run(void)  { printf("[compress] comprimiendo datos\n"); }
