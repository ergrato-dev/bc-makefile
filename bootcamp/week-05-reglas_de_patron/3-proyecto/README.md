# Proyecto — Compilador genérico para proyectos C

## Contexto

Eres el primer ingeniero de build en una startup que acaba de decidir escribir su servicio de cálculo en C. El proyecto tiene tres módulos (`math_ops`, `string_ops`, `io`) y un ejecutable principal. Tu tarea es escribir el Makefile de manera que:

- Agregar un nuevo módulo en `src/` no requiera tocar el Makefile
- Los objetos se generen en `build/obj/` y el binario en `build/`
- Exista un target `test` que compila y ejecuta un runner de pruebas mínimas
- El build soporte compilación con `gcc` o `clang` via `make CC=clang`

Este proyecto integra las tres técnicas de la semana: regla de patrón con directorios, static pattern rule para los tests, y regla explícita para el binario final.

## Estructura del proyecto

```
3-proyecto/starter/
├── Makefile            ← tu trabajo
├── src/
│   ├── main.c
│   ├── math_ops.c
│   ├── string_ops.c
│   └── io.c
├── include/
│   ├── math_ops.h
│   ├── string_ops.h
│   └── io.h
└── tests/
    └── test_runner.c
```

## Entregables

1. **`build/app`** — binario principal que imprime:
   ```
   suma(3, 4) = 7
   producto(3, 4) = 12
   potencia(2, 8) = 256
   ```

2. **`build/test_runner`** — binario de tests que imprime:
   ```
   [PASS] test_sum
   [PASS] test_product
   [PASS] test_power
   Todos los tests pasaron.
   ```

3. **Makefile** con:
   - Regla de patrón `build/obj/%.o: src/%.c` para módulos de aplicación
   - Static pattern rule para `$(TEST_OBJS): build/test/%.o: tests/%.c`
   - Variables `CC`, `CFLAGS`, `BUILD`, `SRC_DIR`, `INC_DIR`
   - Targets: `all`, `test`, `clean`, `help`
   - Dependencias de headers con `-MMD -MP` y `-include` de los `.d` (semana 04)
   - Preámbulo estricto (`SHELL := bash`, `.SHELLFLAGS := -eu -o pipefail -c`, `.DELETE_ON_ERROR:`) y `clean` con guarda de variable vacía (semana 03)

## Comandos de verificación

```bash
# Build y ejecución
make all
./build/app

# Tests
make test

# Cambio de compilador
make clean && make all CC=clang
touch include/math_ops.h && make all   # recompila solo main.o y math_ops.o

# Build limpio desde cero
make clean
make all
```

## ✅ Requisitos verificables

Los comprueba `./scripts/verificar-semana.sh 05` desde la raíz del repositorio
(60 de los 100 puntos del Producto). Los otros 40 son de calidad: ver la
[rúbrica](../rubrica-evaluacion.md#-producto-30).

- [ ] make all desde cero produce build/app y el binario imprime potencia(2, 8) = 256
- [ ] Cada src/*.c produce su objeto en build/obj/
- [ ] Un .c nuevo en src/ se compila sin tocar el Makefile
- [ ] Una segunda ejecución de make all no rehace nada
- [ ] Tocar un .c recompila solo ese objeto
- [ ] Tocar include/math_ops.h recompila exactamente los dos objetos de la app que lo incluyen
- [ ] make test compila el runner y termina con Todos los tests pasaron.
- [ ] El objeto del runner de tests se genera en build/test/
- [ ] CC se puede cambiar desde la línea de comandos
- [ ] make clean elimina build/ por completo
- [ ] make clean se niega a borrar si BUILD está vacía
- [ ] El Makefile ejecuta las recetas con bash -eu -o pipefail
- [ ] El Makefile declara .DELETE_ON_ERROR

## Instrucciones de entrega

```bash
git add 3-proyecto/
git commit -m "week-05: proyecto compilador genérico C con pattern rules"
```
