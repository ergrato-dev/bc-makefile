#include <stdio.h>

void plugin_init(void) { printf("[format] inicializado\n"); }
void plugin_run(void)  { printf("[format] formateando salida\n"); }
