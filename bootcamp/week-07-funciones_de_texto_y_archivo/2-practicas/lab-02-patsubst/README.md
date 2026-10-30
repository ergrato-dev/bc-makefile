# Lab 02 — patsubst

⏱ Duración estimada: ~60 min

## Objetivo

Transformar una lista de fuentes en varias listas derivadas con `$(patsubst)`, su atajo `$(VAR:a=b)` y `$(subst)`, y demostrar con casos límite por qué `patsubst` es la opción segura para rutas.

## Contexto

- `$(patsubst patrón,reemplazo,texto)` trabaja **palabra a palabra**: transforma las que casan con el patrón completo y deja intactas las demás. El `%` captura el stem.
- `$(VAR:src/%.c=build/%.o)` es una *referencia de sustitución*: exactamente lo mismo que `$(patsubst src/%.c,build/%.o,$(VAR))`, más corto.
- `$(subst desde,hasta,texto)` reemplaza **cada aparición** del texto literal, esté donde esté, incluso a mitad de un nombre.

## Instrucciones

1. Entra al starter y añade el preámbulo estricto:
   ```bash
   cd lab-02-patsubst/starter
   ```

2. Ejecuta `make demo`: `OBJS`, `TEST_BINS`, `RELEASE_SRCS` y `OBJS_REF` salen vacíos.

3. Completa `OBJS`:
   ```makefile
   OBJS := $(patsubst src/%.c,build/%.o,$(SRCS))
   ```

4. Completa `TEST_BINS` encadenando sobre `OBJS` (`build/%.o` → `bin/%`, sin extensión):
   ```makefile
   TEST_BINS := $(patsubst build/%.o,bin/%,$(OBJS))
   ```

5. Completa `RELEASE_SRCS` con sustitución literal:
   ```makefile
   RELEASE_SRCS := $(subst src,release,$(SRCS))
   ```

6. Ejecuta `make demo` y compara con los criterios de éxito.

7. **Referencia de sustitución.** Escribe `OBJS_REF` con el atajo, sin llamar a `patsubst`:
   ```makefile
   OBJS_REF := $(SRCS:src/%.c=build/%.o)
   ```
   `make demo` debe mostrar `OBJS_REF` idéntica a `OBJS`.

8. **Casos límite.** Implementa el target `trampas` con tres líneas:
   ```makefile
   trampas: ## Compara subst y patsubst en casos límite
   	@echo "subst:        $(subst src,release,$(TRAMPA))"
   	@echo "patsubst:     $(patsubst src/%,release/%,$(TRAMPA))"
   	@echo "sin casar:    $(patsubst %.c,%.o,$(MIXTA))"
   ```
   Antes de ejecutar, escribe en papel qué esperas en cada línea. Luego:
   ```bash
   make trampas
   ```
   ```
   subst:        release/releasemap.c
   patsubst:     release/srcmap.c
   sin casar:    main.o README.md utils.o
   ```
   `subst` destrozó `srcmap.c` porque contiene `src`; `patsubst` solo tocó el prefijo `src/`. Y `README.md` sobrevivió intacto: `patsubst` no descarta las palabras que no casan, las deja pasar. Si necesitas quitarlas, primero `$(filter %.c,...)` (lab-03).

## Criterios de éxito

- [ ] `make demo` imprime exactamente:
  ```
  SRCS:         src/main.c src/utils.c src/network.c src/config.c
  OBJS:         build/main.o build/utils.o build/network.o build/config.o
  TEST_BINS:    bin/main bin/utils bin/network bin/config
  RELEASE_SRCS: release/main.c release/utils.c release/network.c release/config.c
  OBJS_REF:     build/main.o build/utils.o build/network.o build/config.o
  ```
- [ ] `make trampas` imprime las tres líneas del paso 8
- [ ] Puedes explicar por qué `RELEASE_SRCS` es correcto con estas fuentes pero `subst` sería un bug si existiera `src/srcmap.c`

## Reto extra

Agrega `DEPS := $(patsubst src/%.c,deps/%.d,$(SRCS))` y muéstrala en `make demo`. Después reescribe `RELEASE_SRCS` con `patsubst` para que no tenga la trampa del paso 8.
