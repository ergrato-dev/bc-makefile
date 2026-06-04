# Proyecto Semana 03 — Build system para proyecto C multi-archivo

⏱ Duración estimada: ~2h 30min

## Contexto

Eres el responsable de infraestructura en un equipo que desarrolla una pequeña librería de utilidades en C. El proyecto tiene tres módulos (`main`, `greet`, `calc`), cada uno con su propio archivo fuente en `src/` y sus headers en `include/`. Hasta ahora compilaban todo manualmente con un script de shell que re-compila todo en cada ejecución. Tu tarea: reemplazarlo con un Makefile que use variables automáticas para hacer builds incrementales, limpios y parametrizables.

## Estructura del proyecto

```
starter/
├── Makefile          ← aquí trabajas
├── include/
│   ├── greet.h
│   └── calc.h
└── src/
    ├── main.c
    ├── greet.c
    └── calc.c
```

El Makefile debe compilar `src/*.c` → `build/*.o` → `build/app` usando exclusivamente variables automáticas en las recetas. Ningún nombre de archivo debe aparecer hardcodeado en ninguna receta.

## Lo que debes construir

### 1. `all`
Compila el proyecto completo desde cero. Output esperado con `make all`:
```
[cc]   src/main.c → build/main.o
[cc]   src/greet.c → build/greet.o
[cc]   src/calc.c → build/calc.o
[link] build/app listo.
```

### 2. Rebuild incremental
Modifica `src/greet.c` y ejecuta `make all` de nuevo:
```
[cc]   src/greet.c → build/greet.o
[link] build/app listo.
```
Solo `greet.o` se recompila; los otros objetos están al día.

### 3. `clean`
```
[clean] Listo.
```
Elimina `build/` completo. `make all` posterior reconstruye desde cero.

### 4. `help`
Lista todos los targets disponibles con descripción.

### 5. El binario funciona
```bash
./build/app
Hola desde Make!
suma(3, 4) = 7
producto(3, 4) = 12
```

## Variables requeridas

| Variable | Tipo | Default | Descripción |
|----------|------|---------|-------------|
| `CC` | `?=` | `gcc` | Compilador C |
| `CFLAGS` | `?=` | `-Wall -Wextra -std=c11` | Flags de compilación |
| `BUILD_DIR` | `:=` | `build` | Directorio de artefactos |
| `SRC_DIR` | `:=` | `src` | Directorio de fuentes |
| `INC_DIR` | `:=` | `include` | Directorio de headers |
| `APP` | `:=` | `$(BUILD_DIR)/app` | Ruta del binario final |
| `SRCS` | `:=` | `$(wildcard $(SRC_DIR)/*.c)` | Todos los fuentes |
| `OBJS` | `:=` | derivado de SRCS | Todos los objetos en BUILD_DIR |

## Reglas requeridas en las recetas

La regla de compilación debe usar:
- `$<` para el archivo fuente (único argumento de `gcc -c`)
- `$@` para el archivo objeto de salida
- `$(@D)` con `mkdir -p` para crear `build/` si no existe

La regla de enlace debe usar:
- `$^` para todos los objetos
- `$@` para el binario de salida

## Verificación

Estos comandos deben funcionar y producir los outputs indicados:

```bash
make help
make all
./build/app
make clean
make all CC=clang
make all CFLAGS="-O2 -std=c11"
touch src/greet.c && make all  # solo recompila greet.o
```

## Rúbrica del proyecto (30 pts)

| Criterio | Pts |
|----------|-----|
| `make all` desde cero produce el binario y lo ejecuta correctamente | 8 |
| Regla `$(BUILD_DIR)/%.o: $(SRC_DIR)/%.c` usa `$@`, `$<`, `$(@D)` | 8 |
| Rebuild incremental: modificar un `.c` recompila solo ese objeto | 5 |
| `make clean` + `make all` produce el mismo binario correcto | 5 |
| `make help` documenta todos los targets | 4 |

## Entrega

Commit con el mensaje:
```
feat(week-03): proyecto - build system C multi-archivo con variables automáticas
```
