# Lab 05 — combinadas

**Duración estimada:** 50 minutos

## Objetivo

Construir un build system completo que combina `$(wildcard)`, `$(patsubst)`, `$(filter)`, `$(dir)` y `$(addprefix)` para compilar un proyecto C sin ninguna lista hardcodeada.

## Contexto

El starter tiene 4 archivos fuente en `src/` pero el Makefile está incompleto. A diferencia de los labs anteriores, aquí no hay listas predefinidas: debes usar `$(wildcard)` para descubrirlas y el resto de funciones para transformarlas.

La cadena completa es:

```
$(wildcard)       → SRCS (archivos reales en disco)
$(patsubst)       → OBJS (rutas de objetos)
$(sort $(dir))    → OBJ_DIRS (directorios únicos a crear)
$(addprefix -I,)  → INCS (flags de include)
```

Una vez que las variables están correctas, el pattern rule compila cada par sin cambios adicionales.

## Instrucciones

1. Entra al directorio starter:
   ```bash
   cd lab-05-combinadas/starter
   ```

2. Ejecuta `make info`. Varias variables estarán vacías.

3. Completa `SRCS` con `$(wildcard src/*.c)`.

4. Completa `OBJS` con `$(patsubst src/%.c,$(BUILD)/%.o,$(SRCS))`.

5. Completa `OBJ_DIRS` con `$(sort $(dir $(OBJS)))`.

6. Completa `INCS` con `$(addprefix -I,include)`.

7. En el target `$(TARGET)`, agrega `$(OBJS)` como prerequisito y la receta de enlazado.

8. Verifica con:
   ```bash
   make info
   make all
   ./build/pipeline
   ```

9. Prueba agregar un módulo nuevo sin tocar el Makefile:
   ```bash
   cat > src/reporter.c << 'EOF'
   #include <stdio.h>
   void reporter_run(void) { printf("[reporter] reporte generado\n"); }
   EOF
   make clean && make all
   ```

## Criterios de éxito

```
$ make info
SRCS:     src/formatter.c src/main.c src/parser.c src/validator.c
OBJS:     build/formatter.o build/main.o build/parser.o build/validator.o
OBJ_DIRS: build/
INCS:     -Iinclude
```

```
$ ./build/pipeline
=== Pipeline de procesamiento ===
[parser]    analizando entrada
[formatter] formateando salida
[validator] validando datos
```

Después de agregar `src/reporter.c` y recompilar, el binario debe incluir el nuevo módulo sin haber editado el Makefile.

## Reto extra

Agrega un target `count` que muestre:
- Número de fuentes encontradas
- Número de fuentes que cambiaron desde la última compilación (tip: usa `$?` dentro de la receta de `$(TARGET)`)
