#include <stdio.h>
#include "app.h"

int main(void) {
    printf("módulos: %s, %s\n", lexer_nombre(), parser_nombre());
    return 0;
}
