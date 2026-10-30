# Proyecto Semana 07 — Sistema de Build Multi-Módulo Auto-Configurable

**Duración estimada:** 2 horas 30 minutos

## Contexto

Eres el nuevo mantenedor de un sistema C con tres módulos independientes (`auth`, `logger`, `config`) y un core en `src/`. El Makefile anterior tenía todas las fuentes hardcodeadas. Cada vez que un módulo crecía, alguien olvidaba actualizar el Makefile y la build fallaba en producción.

Tu misión: reescribir el Makefile desde cero usando funciones de texto para que cualquier archivo `.c` nuevo en `src/` o dentro de un módulo existente se compile automáticamente sin tocar el Makefile.

## Estructura del starter

```
starter/
├── Makefile
├── src/
│   ├── main.c       # Punto de entrada, llama a app_run()
│   └── app.c        # Coordina los módulos
└── modules/
    ├── auth/
    │   └── auth.c
    ├── logger/
    │   └── logger.c
    └── config/
        └── config.c
```

## Entregables

1. `Makefile` con todas las variables generadas por funciones de texto, sin ninguna lista hardcodeada
2. `make all` compila el binario `build/sistema`
3. `make manifest` genera `build/manifest.txt` con la lista de todas las fuentes
4. `make report` imprime estadísticas del proyecto usando funciones de texto
5. `make clean` elimina todo lo generado

## Variables requeridas en el Makefile

| Variable | Cómo generarla | Valor esperado |
|----------|---------------|----------------|
| `CORE_SRCS` | `$(wildcard src/*.c)` | `src/app.c src/main.c` |
| `MODULE_SRCS` | `$(wildcard modules/*/*.c)` | `modules/auth/auth.c modules/config/config.c modules/logger/logger.c` |
| `ALL_SRCS` | `$(CORE_SRCS) $(MODULE_SRCS)` | todas las fuentes |
| `OBJS` | `$(patsubst %.c,$(BUILD)/%.o,$(ALL_SRCS))` | objetos con estructura de directorios |
| `MODULE_DIRS` | `$(sort $(dir $(MODULE_SRCS)))` | directorios únicos de módulos |
| `CFLAGS` | `+= $(addprefix -I,$(MODULE_DIRS))` | flags -I para cada módulo |

## Comandos de verificación

```bash
cd 3-proyecto/solucion

# Verificar variables
make report

# Compilar
make all
./build/sistema

# Generar manifest
make manifest
cat build/manifest.txt

# Probar resistencia al cambio (sin editar Makefile)
cat > modules/logger/metrics.c << 'EOF'
#include <stdio.h>
void metrics_init(void) { printf("[metrics] inicializado\n"); }
EOF
make clean && make all
```

## Salida esperada de `make report`

```
=== Reporte del Proyecto ===
Fuentes core:    2 archivos (app.c main.c)
Fuentes módulos: 3 archivos
Directorios:     modules/auth/ modules/config/ modules/logger/
Target:          sistema
Total objetos:   5
```

## Salida esperada de `make all`

```
gcc ... -c src/app.c -o build/src/app.o
gcc ... -c src/main.c -o build/src/main.o
gcc ... -c modules/auth/auth.c -o build/modules/auth/auth.o
gcc ... -c modules/config/config.c -o build/modules/config/config.o
gcc ... -c modules/logger/logger.c -o build/modules/logger/logger.o
gcc ... build/src/app.o ... -o build/sistema
Sistema compilado: build/sistema
```

## Rúbrica del proyecto (30 pts)

| Criterio | Puntos |
|----------|--------|
| `make all` compila sin errores, binario ejecuta correctamente | 10 |
| `make report` muestra estadísticas correctas usando funciones de texto | 10 |
| Agregar un nuevo `.c` en `modules/logger/` compila automáticamente sin editar Makefile | 10 |

## Instrucciones de entrega

```bash
git add bootcamp/week-07-funciones_de_texto_y_archivo/3-proyecto/
git commit -m "feat(week-07): proyecto - build multi-módulo auto-configurable"
```
