#include <stdio.h>

void auth_init(void);
void logger_init(void);
void config_load(void);

void app_run(void) {
    auth_init();
    logger_init();
    config_load();
    printf("[app] todos los modulos iniciados\n");
}
