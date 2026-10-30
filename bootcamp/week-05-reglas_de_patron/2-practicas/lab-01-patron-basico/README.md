# Lab 01 — `%.o: %.c`: compilar sin repetir recetas

⏱ Duración estimada: ~60 min

## Objetivo

Escribir una regla de patrón `%.o: %.c` que compile tres módulos C sin ninguna regla explícita por archivo, y comprobar cuándo Make la usa y cuándo no.

## Contexto

Antes de las reglas de patrón, compilar tres módulos requería tres reglas casi idénticas (`main.o: main.c`, `math.o: math.c`, `greet.o: greet.c`). Con una regla de patrón todo colapsa a una:

```makefile
%.o: %.c
	$(CC) $(CFLAGS) -c $< -o $@
```

Make instancia esta plantilla para cada `.o` que necesita. El `%` captura el stem (`main`, `math`, `greet`) y `$*` lo contiene dentro de la receta.

## Instrucciones

1. Entra en `starter/` y comprueba que la ayuda funciona:
   ```bash
   cd starter && make
   ```
   ```
   Targets disponibles:
     all                  Compila la aplicación completa
     clean                Elimina objetos y binario
     help                 Muestra los targets disponibles
   ```

2. Añade el preámbulo estricto y define `OBJS` a partir de `SRCS`:
   ```makefile
   OBJS := $(SRCS:.c=.o)
   ```

3. Escribe la regla de patrón (columna 0, receta con TAB):
   ```makefile
   %.o: %.c
   	@echo "[cc] stem=$*"
   	$(CC) $(CFLAGS) -c $< -o $@
   ```

4. Da receta a `$(APP)`: `$(CC) $^ -o $@`. Compila un solo objeto y luego todo:
   ```bash
   make math.o
   make all && ./app
   ```
   ```
   [cc] stem=math
   gcc -Wall -std=c11 -c math.c -o math.o
   [cc] stem=main
   gcc -Wall -std=c11 -c main.c -o main.o
   [cc] stem=greet
   gcc -Wall -std=c11 -c greet.c -o greet.o
   gcc main.o math.o greet.o -o app
   add(3, 4) = 7
   Hola desde Make!
   ```
   `math.o` ya estaba al día, así que en el segundo comando solo se compilan `main` y `greet`.

5. Comprueba la incrementalidad: una segunda pasada no hace nada y tocar un `.c` recompila solo ese objeto.
   ```bash
   make all
   touch math.c && make all
   ```
   ```
   make: Nothing to be done for 'all'.
   [cc] stem=math
   gcc -Wall -std=c11 -c math.c -o math.o
   gcc main.o math.o greet.o -o app
   ```

6. Borra los objetos y pide a Make que **muestre** lo que haría sin ejecutarlo:
   ```bash
   rm -f *.o && make -n all
   ```
   Verás tres pares `echo "[cc] stem=…"` + `gcc … -c`, y el enlace. `-n` es tu herramienta para comprobar qué regla elegiría Make antes de tocar nada.

7. La regla es una plantilla, no una lista. Pide un objeto cuyo `.c` no existe, créalo y repite:
   ```bash
   make extra.o
   printf 'int extra(void) { return 42; }\n' > extra.c
   make extra.o
   ```
   ```
   make: *** No rule to make target 'extra.o'.  Stop.
   [cc] stem=extra
   gcc -Wall -std=c11 -c extra.c -o extra.o
   ```
   Sin `extra.c` la regla se descarta en silencio; con él, la misma regla sirve sin cambiar el Makefile. Borra `extra.c` y `extra.o`.

8. Comenta tus tres líneas de la regla de patrón y fuerza la recompilación:
   ```bash
   make -B math.o
   ```
   ```
   gcc -Wall -std=c11   -c -o math.o math.c
   ```
   Sigue compilando: es la regla `%.o: %.c` **de serie** de GNU Make (sin tu `echo`, con otro orden de flags). Lo arreglarás en el [lab-05](../lab-05-prioridad/README.md). Descomenta tu regla antes de seguir.

## Criterios de éxito

- [ ] `make math.o` imprime `[cc] stem=math` y produce `math.o`
- [ ] `make all && ./app` imprime `add(3, 4) = 7` y `Hola desde Make!`
- [ ] Una segunda ejecución de `make all` imprime `Nothing to be done for 'all'`
- [ ] `touch math.c && make all` ejecuta exactamente un `gcc … -c` (el de `math.c`)
- [ ] `make extra.o` sin `extra.c` falla con `No rule to make target 'extra.o'`
- [ ] El Makefile no contiene `main.o:`, `math.o:` ni `greet.o:` como targets explícitos
- [ ] `make clean` elimina todos los `.o` y el binario `app`

## Reto extra

Rellena `SRCS` con `$(wildcard *.c)`. Agrega `extra.c` con una función llamada desde `main.c` y verifica que `make all` lo compila y enlaza sin tocar el Makefile.
