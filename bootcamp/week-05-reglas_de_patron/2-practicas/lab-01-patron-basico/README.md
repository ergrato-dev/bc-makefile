# Lab 01 — `%.o: %.c`: compilar sin repetir recetas

⏱ Duración estimada: ~50 min

## Objetivo

Escribir una regla de patrón `%.o: %.c` que compile tres módulos C sin usar ninguna regla explícita por archivo.

## Contexto

Antes de las reglas de patrón, compilar tres módulos requería tres reglas:

```makefile
main.o: main.c
	$(CC) $(CFLAGS) -c main.c -o main.o

math.o: math.c
	$(CC) $(CFLAGS) -c math.c -o math.o

greet.o: greet.c
	$(CC) $(CFLAGS) -c greet.c -o greet.o
```

Con una regla de patrón, todo esto colapsa a:

```makefile
%.o: %.c
	$(CC) $(CFLAGS) -c $< -o $@
```

Make instancia esta regla para cada `.o` que necesita construir. El `%` captura el stem (`main`, `math`, `greet`), y las variables automáticas resuelven los nombres concretos en cada instancia.

## Instrucciones

1. Abre `starter/Makefile`. Los archivos `main.c`, `math.c` y `greet.c` ya están disponibles.

2. Define la variable `OBJS` como lista de objetos derivada de `SRCS`:
   ```makefile
   SRCS := main.c math.c greet.c
   OBJS := $(SRCS:.c=.o)
   ```

3. Escribe la regla de patrón que compile cualquier `.c` a `.o`:
   ```makefile
   %.o: %.c
   	$(CC) $(CFLAGS) -c $< -o $@
   ```

4. Completa el target `app` para que enlace todos los objetos:
   ```makefile
   app: $(OBJS)
   	$(CC) $^ -o $@
   ```

5. Verifica paso a paso:
   ```bash
   make math.o       # compila solo math.o
   make greet.o      # compila solo greet.o
   make app          # compila main.o y enlaza todo
   ./app
   ```

6. Elimina los `.o` manualmente y ejecuta `make -n app` para ver qué comandos ejecutaría Make sin ejecutarlos.

## Criterios de éxito

- [ ] `make math.o` produce `math.o` sin errores
- [ ] `make app` compila los tres módulos e imprime:
  ```
  add(3, 4) = 7
  Hola desde Make!
  ```
- [ ] El Makefile no contiene las palabras `main.o:`, `math.o:` ni `greet.o:` como targets explícitos
- [ ] `make clean` elimina todos los `.o` y el binario `app`
- [ ] `make help` lista los targets disponibles

## Reto extra

Parametriza la lista de fuentes de forma dinámica usando `$(wildcard *.c)`. El Makefile debe compilar todos los `.c` del directorio sin listarlos manualmente. Agrega un cuarto archivo `extra.c` con una función nueva llamada desde `main.c` y verifica que `make app` lo incluya automáticamente.
