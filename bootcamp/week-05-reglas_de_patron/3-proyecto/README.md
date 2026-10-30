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
   - Variables `CC`, `CFLAGS`, `BUILD_DIR`, `SRC_DIR`, `INC_DIR`
   - Targets: `all`, `test`, `clean`, `help`

## Comandos de verificación

```bash
# Build y ejecución
make all
./build/app

# Tests
make test

# Cambio de compilador
make clean && make all CC=clang
touch include/math_ops.h && make all   # recompila solo los objetos que lo incluyen

# Build limpio desde cero
make clean
make all
```

## Rúbrica del proyecto (30 pts)

| Criterio | Pts |
|----------|-----|
| Regla de patrón `build/obj/%.o: src/%.c` funcional para todos los módulos | 10 |
| Static pattern rule para `$(TEST_OBJS)` con ruta `build/test/` | 8 |
| `make clean` + `make all` produce el mismo resultado que el primer build | 7 |
| `make test` compila el runner y ejecuta las pruebas con output correcto | 5 |

## Instrucciones de entrega

```bash
git add 3-proyecto/
git commit -m "week-05: proyecto compilador genérico C con pattern rules"
```
