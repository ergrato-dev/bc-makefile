#include <stdio.h>

void plugin_init(void) { printf("[encrypt] inicializado\n"); }
void plugin_run(void)  { printf("[encrypt] cifrando datos\n"); }
