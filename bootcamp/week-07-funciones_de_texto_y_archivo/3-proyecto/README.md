# Proyecto Semana 07 — Sistema de Build Multi-Módulo Auto-Configurable

**Duración estimada:** 3 horas

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
4. `make report` imprime estadísticas del proyecto usando funciones de texto, incluida la lista de módulos (`Módulos: auth config logger`)
5. `make objs MODULE=<nombre>` imprime solo los objetos de ese módulo; tolera espacios alrededor del nombre (`'MODULE= logger '`) y, si el módulo no existe, falla con un `$(error)` que lista los disponibles
6. `make clean` elimina todo lo generado, con guarda de variable vacía
7. Preámbulo estricto de la semana 03 (`SHELL`, `.SHELLFLAGS`, `.DELETE_ON_ERROR`)

## Variables requeridas en el Makefile

| Variable | Cómo generarla | Valor esperado |
|----------|---------------|----------------|
| `CORE_SRCS` | `$(wildcard src/*.c)` | `src/app.c src/main.c` |
| `MODULE_SRCS` | `$(wildcard modules/*/*.c)` | `modules/auth/auth.c modules/config/config.c modules/logger/logger.c` |
| `ALL_SRCS` | `$(CORE_SRCS) $(MODULE_SRCS)` | todas las fuentes |
| `OBJS` | `$(patsubst %.c,$(BUILD)/%.o,$(ALL_SRCS))` | objetos con estructura de directorios |
| `MODULE_DIRS` | `$(sort $(dir $(MODULE_SRCS)))` | directorios únicos de módulos |
| `MODULES` | `$(notdir $(patsubst %/,%,$(MODULE_DIRS)))` | `auth config logger` |
| `CFLAGS` | `+= $(addprefix -I,$(MODULE_DIRS))` | flags -I para cada módulo |
| `MOD` | `$(strip $(MODULE))` | el módulo pedido, sin espacios |

> `$(notdir modules/auth/)` devuelve una cadena vacía: para `notdir` todo lo
> que hay hasta la última `/` es directorio. Por eso `MODULES` quita primero la
> barra final (lab-04, paso 10).

## Comandos de verificación

```bash
cd 3-proyecto/solucion

# Verificar variables
make report

# Compilar
make all
./build/sistema

# Objetos de un módulo
make objs MODULE=logger
make objs 'MODULE= logger '   # misma salida
make objs MODULE=nope         # debe fallar listando los módulos

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
Módulos:         auth config logger
Target:          sistema
Total objetos:   5
```

## Salida esperada de `make objs`

```
$ make -s objs MODULE=logger
build/modules/logger/logger.o

$ make objs MODULE=nope
Makefile:NN: *** Módulo 'nope' no existe; disponibles: auth config logger.  Stop.
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

## ✅ Requisitos verificables

Los comprueba `./scripts/verificar-semana.sh 07` desde la raíz del repositorio
(60 de los 100 puntos del Producto). Los otros 40 son de calidad: ver la
[rúbrica](../rubrica-evaluacion.md#-producto-30).

- [ ] make all desde cero produce build/sistema y el binario inicia los tres módulos
- [ ] Los objetos conservan la estructura de directorios de las fuentes dentro de build/
- [ ] Cada directorio de módulo llega al compilador como flag -I
- [ ] Un .c nuevo en modules/logger/ se compila sin editar el Makefile
- [ ] Una segunda ejecución de make all no rehace nada
- [ ] make report cuenta las fuentes core y las lista sin directorio
- [ ] make report muestra los directorios de módulo ordenados y sin repetir
- [ ] make report cuenta 5 objetos con $(words)
- [ ] make manifest escribe build/manifest.txt con las 5 fuentes, una por línea
- [ ] make report lista los nombres de módulo sin directorio ni barra final
- [ ] make objs MODULE=logger lista solo los objetos de ese módulo
- [ ] make objs normaliza con $(strip) los espacios alrededor de MODULE
- [ ] make objs con un módulo inexistente falla listando los módulos disponibles
- [ ] make clean elimina build/ por completo
- [ ] make clean se niega a borrar si BUILD está vacío
- [ ] El Makefile ejecuta las recetas con bash -eu -o pipefail
- [ ] El Makefile declara .DELETE_ON_ERROR

## Instrucciones de entrega

```bash
git add bootcamp/week-07-funciones_de_texto_y_archivo/3-proyecto/
git commit -m "feat(week-07): proyecto - build multi-módulo auto-configurable"
```
