#include <stdio.h>

void parser_run(void);
void formatter_run(void);
void validator_run(void);

int main(void) {
    printf("=== Pipeline de procesamiento ===\n");
    parser_run();
    formatter_run();
    validator_run();
    return 0;
}
