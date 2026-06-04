# Lab 05 — Prioridad: la regla explícita anula al patrón

⏱ Duración estimada: ~50 min

## Objetivo

Demostrar que una regla explícita para un target específico tiene prioridad sobre una regla de patrón, y usar esto para aplicar opciones de compilación especiales a un módulo concreto.

## Contexto

Make aplica reglas en este orden de prioridad (de mayor a menor):

1. Regla explícita (target nombrado directamente)
2. Static pattern rule
3. Regla de patrón definida por el usuario
4. Regla implícita interna de Make

Esto significa que puedes tener una regla de patrón genérica para el 95% de los archivos y una regla explícita para el módulo que necesita trato especial:

```makefile
# Regla general para todos los .o
%.o: %.c
	$(CC) $(CFLAGS) -c $< -o $@

# Excepción explícita: debug.o necesita -g -DDEBUG
debug.o: debug.c
	$(CC) $(CFLAGS) -g -DDEBUG -c $< -o $@
```

Cuando Make necesita `debug.o`, encuentra primero la regla explícita y la usa. La regla de patrón se ignora para ese target.

## Instrucciones

1. Abre `starter/Makefile`. Contiene una regla de patrón `%.o: %.c` genérica.

2. Agrega una regla explícita para `debug.o` que compila con `-g -DDEBUG`:
   ```makefile
   debug.o: debug.c
   	$(CC) $(CFLAGS) -g -DDEBUG -c $< -o $@
   	@echo "[debug mode] $@ compilado con -g -DDEBUG"
   ```

3. Verifica qué regla usa Make para cada objeto:
   ```bash
   make main.o    # debe usar la regla de patrón (sin -DDEBUG)
   make debug.o   # debe usar la regla explícita (con -DDEBUG)
   ```

4. Usa `make -p 2>/dev/null | grep -A3 "debug.o"` para ver la regla que Make internalizó para `debug.o`.

5. Completa el target `all` para enlazar `main.o` y `debug.o` en `app`:
   ```bash
   make all
   ./app
   ```

6. Verifica el output: el binario debe imprimir tanto el mensaje normal como el de debug.

## Criterios de éxito

- [ ] `make main.o` usa la regla de patrón (el `@echo` de debug NO aparece)
- [ ] `make debug.o` usa la regla explícita (el `@echo "[debug mode]"` SÍ aparece)
- [ ] `./app` imprime:
  ```
  modulo normal activo
  DEBUG: modulo debug activo
  ```
- [ ] `make -p 2>/dev/null | grep -A3 "^debug.o"` muestra la regla explícita, no la de patrón
- [ ] `make clean` elimina objetos y binario

## Reto extra

Agrega una variable `MODULES_WITH_DEBUG := debug io` y convierte la excepción en una static pattern rule que aplique `-g -DDEBUG` a todos los módulos listados en esa variable. Esto es más mantenible que una regla explícita por módulo.
