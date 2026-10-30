#include <stdio.h>

#include "check.h"
#include "version.h"

int main(void) {
    int status = check_health();
    printf("[infra] healthcheck %s: %s\n", HEALTHCHECK_VERSION,
           status == 0 ? "ok" : "fallo");
    return status;
}
