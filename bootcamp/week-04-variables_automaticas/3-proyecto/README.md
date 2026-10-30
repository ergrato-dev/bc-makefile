# Proyecto Semana 04 — Build system para proyecto C multi-archivo

⏱ Duración estimada: ~3 h

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
Elimina `build/` y `dist/` completos, cada uno con su guarda de la semana 03
(se niega a ejecutar `rm -rf` si la variable está vacía). `make all` posterior
reconstruye desde cero.

### 4. `help`
Lista todos los targets disponibles con descripción.

### 5. El binario funciona
```bash
./build/app
Hola desde Make!
suma(3, 4) = 7
producto(3, 4) = 12
```

### 6. `dist`
Empaqueta el binario en `dist/app-$(VERSION).tar.gz` (`VERSION ?= 1.0.0`).
`dist` es `.PHONY` y depende del **archivo** `$(TARBALL)`, que a su vez
depende de `$(APP)`. La receta no escribe ninguna ruta:

- `$(@D)` con `mkdir -p` crea `dist/`
- `tar -czf $@ -C $(<D) $(<F)` entra en `build/` y guarda solo `app`

```
$ make dist
...
tar -czf dist/app-1.0.0.tar.gz -C build app
[dist] dist/app-1.0.0.tar.gz listo.
$ tar -tzf dist/app-1.0.0.tar.gz
app
$ make dist
make: Nothing to be done for 'dist'.
```

Con `make dist VERSION=2.0.0` se genera `dist/app-2.0.0.tar.gz` sin tocar el
Makefile. Si el tarball contiene `build/app` en lugar de `app`, revisa el
`-C $(<D)`.

## Variables requeridas

| Variable | Tipo | Default | Descripción |
|----------|------|---------|-------------|
| `CC` | `:=` | `gcc` | Compilador C. `make CC=clang` lo sobrescribe igual |
| `CFLAGS` | `?=` | `-Wall -Wextra -std=c11` | Flags de compilación |
| `BUILD_DIR` | `:=` | `build` | Directorio de artefactos |
| `SRC_DIR` | `:=` | `src` | Directorio de fuentes |
| `INC_DIR` | `:=` | `include` | Directorio de headers |
| `APP` | `:=` | `$(BUILD_DIR)/app` | Ruta del binario final |
| `SRCS` | `:=` | `$(wildcard $(SRC_DIR)/*.c)` | Todos los fuentes |
| `OBJS` | `:=` | derivado de SRCS | Todos los objetos en BUILD_DIR |
| `DEPS` | `:=` | `$(OBJS:.o=.d)` | Dependencias de headers que genera `-MMD -MP` |
| `DIST_DIR` | `:=` | `dist` | Directorio de paquetes |
| `VERSION` | `?=` | `1.0.0` | Versión del paquete; `make dist VERSION=2.0.0` |
| `TARBALL` | `:=` | `$(DIST_DIR)/app-$(VERSION).tar.gz` | Ruta del paquete |

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
touch src/greet.c && make all     # solo recompila greet.o
touch include/calc.h && make all  # recompila calc.o y main.o (los que lo incluyen)
make dist && tar -tzf dist/app-1.0.0.tar.gz   # app
make dist VERSION=2.0.0
make clean                        # borra build/ y dist/
```

## ✅ Requisitos verificables

Los comprueba `./scripts/verificar-semana.sh 04` desde la raíz del repositorio
(60 de los 100 puntos del Producto). Los otros 40 son de calidad: ver la
[rúbrica](../rubrica-evaluacion.md#-producto-30).

- [ ] make all desde cero produce build/app y el binario imprime producto(3, 4) = 12
- [ ] Cada src/*.c produce su objeto en build/
- [ ] Una segunda ejecución de make all no rehace nada
- [ ] Tocar un .c recompila solo ese objeto
- [ ] El build genera un archivo .d de dependencias por objeto
- [ ] Tocar include/calc.h recompila exactamente los dos objetos que lo incluyen
- [ ] CC se puede cambiar desde la línea de comandos
- [ ] make dist genera dist/app-1.0.0.tar.gz con el binario app en la raíz
- [ ] make dist VERSION=2.0.0 genera dist/app-2.0.0.tar.gz
- [ ] make clean elimina también dist/
- [ ] make clean elimina build/ por completo
- [ ] make clean se niega a borrar si BUILD_DIR está vacío
- [ ] El Makefile ejecuta las recetas con bash -eu -o pipefail
- [ ] El Makefile declara .DELETE_ON_ERROR

## Entrega

Commit con el mensaje:
```
feat(week-04): proyecto - build system C multi-archivo con variables automáticas
```
