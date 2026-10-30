# Proyecto Semana 06 — Build C con dependencias de headers exactas

⏱ Duración estimada: ~3 h

## Contexto

El equipo mantiene `calc`, una pequeña CLI en C con módulos en `src/core/` y
`src/util/` y un archivo de versión que un script convierte en código. El
Makefile actual hace un build completo cada vez, y aun así ha dado tres sustos
este trimestre:

1. Un cambio en `include/calc.h` llegó a producción con un `main.o` viejo: el
   binario enlazaba, pero calculaba mal.
2. En CI (`make -j8`) el generador de versión corrió dos veces a la vez y una de
   cada veinte builds compilaba un `version.c` a medio escribir.
3. Alguien cambió `CFLAGS` a `-O2` en el pipeline y el artefacto salió compilado
   sin optimizar, porque había objetos de una ejecución anterior.

Tu trabajo: un Makefile en el que el equipo pueda **confiar** sin `make clean`.
Cada build hace exactamente el trabajo necesario, ni más ni menos.

## Estructura del proyecto

```
starter/
├── Makefile              ← aquí trabajas
├── VERSION               ← 1.4.2
├── tools/
│   └── gen-version.sh    ← genera version.c Y version.h en una ejecución
├── include/
│   ├── calc.h            ← lo incluyen main.c y core/calc.c
│   └── fmt.h             ← lo incluyen main.c y util/fmt.c
└── src/
    ├── main.c            ← incluye también version.h (generado)
    ├── core/calc.c
    └── util/fmt.c
```

El build produce:

```
build/
├── app
├── compile-flags.txt     ← stamp de flags
├── main.o  main.d
├── core/calc.o  core/calc.d
├── util/fmt.o   util/fmt.d
└── gen/version.c  version.h  version.o  version.d
```

## Entregables

1. **`help` por defecto.** `make` sin argumentos lista los targets.
2. **Build desde cero, también en paralelo.** `make all` y `make -j8 all` producen
   `build/app`, que imprime:
   ```
   calc v1.4.2
   suma(3, 4) = 7
   producto(3, 4) = 12
   ```
   La versión sale de `VERSION` a través de `tools/gen-version.sh`, no escrita a mano.
3. **Incremental exacto.** Con `-MMD -MP`, el árbol `build/` replicando `src/`
   (order-only `| $$(@D)/` y `.SECONDEXPANSION`), y un grouped target `&:` para el
   generador. Formato de salida obligatorio: `[cc]   <fuente>`, `[link] <binario>`;
   el `[gen]` lo imprime el script.
4. **Stamp de flags.** Cambiar `CFLAGS` o `CPPFLAGS` recompila todos los objetos;
   no cambiarlas no recompila nada.
5. **`clean` seguro**, con la guarda de la semana 03, y preámbulo estricto.

Los TODO del `starter/Makefile` están numerados en el orden en que conviene
resolverlos.

## Verificación

```bash
make clean && make -j8 all            # un solo [gen], cuatro [cc], un [link]
./build/app                           # calc v1.4.2 ...
make all                              # no imprime [cc], [link] ni [gen]
touch include/calc.h && make all      # [cc] src/main.c y src/core/calc.c
touch src/util/fmt.c && make all      # [cc] src/util/fmt.c
touch VERSION && make all             # [gen], [cc] src/main.c y build/gen/version.c
touch build/marca.txt && make all     # nada
make all CFLAGS='-O2 -Wall'           # cuatro [cc]
make clean BUILD_DIR=                 # error: BUILD_DIR vacía
```

## ✅ Requisitos verificables

Los comprueba `./scripts/verificar-semana.sh 06` desde la raíz del repositorio
(60 de los 100 puntos del Producto). Los otros 40 son de calidad: ver la
[rúbrica](../rubrica-evaluacion.md#-producto-30).

- [ ] make sin argumentos muestra la ayuda
- [ ] make all desde cero produce build/app y el binario imprime la versión de VERSION
- [ ] make -j8 all desde cero termina sin errores
- [ ] Con make -j8 desde cero, el generador de version.c y version.h corre una sola vez
- [ ] Una segunda ejecución de make all no compila, no enlaza y no regenera nada
- [ ] Tocar src/util/fmt.c recompila solo ese objeto
- [ ] Tocar include/calc.h recompila exactamente los dos objetos que lo incluyen
- [ ] Tocar VERSION recompila solo los dos objetos que usan el código generado
- [ ] Crear un archivo dentro de build/ no provoca recompilaciones
- [ ] Dejar de incluir un header y borrarlo no rompe el build
- [ ] Cambiar CFLAGS en la línea de comandos recompila los cuatro objetos
- [ ] make clean elimina build/ por completo
- [ ] make clean se niega a borrar si BUILD_DIR está vacío
- [ ] El Makefile ejecuta las recetas con bash -eu -o pipefail
- [ ] El Makefile declara .DELETE_ON_ERROR

> [!NOTE]
> La comprobación del header obsoleto añade temporalmente
> `#include <obsoleto.h>` a `src/util/fmt.c` y crea `include/obsoleto.h`; al
> terminar restaura el archivo original, pase o falle.

## Calidad (40 pts)

| Criterio | Puntos |
|---|:--:|
| Ningún header escrito a mano como prerrequisito: todo sale de `-MMD -MP` | 10 |
| Directorios siempre order-only; ninguna receta con `mkdir` salvo la regla `%/` | 8 |
| Comentarios que explican cada prerrequisito "raro" (order-only, `&:`, stamp, `.PRECIOUS`) | 8 |
| `CPPFLAGS`, `CFLAGS` y `DEPFLAGS` separadas | 6 |
| `.PHONY` completo y `help` con todos los targets | 4 |
| Orden: preámbulo, variables por sección, reglas, utilidades | 4 |

## Entrega

Commit con el mensaje:

```
feat(week-06): proyecto - build C con dependencias de headers exactas
```
