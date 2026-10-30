#include <stdio.h>

extern const char *msg_es;
extern const char *msg_en;

int main(void) {
    printf("es: %s\n", msg_es);
    printf("en: %s\n", msg_en);
    return 0;
}
