#include <stdio.h>

int add(int a, int b);
int greet(const char *name);

int main(void) {
    printf("add(3, 4) = %d\n", add(3, 4));
    greet("Make");
    return 0;
}
