# Lab 06 — Variables rotas

⏱ Duración estimada: ~60 min

## Objetivo

Identificar y corregir cuatro bugs de expansión de variables en un Makefile que carga sin errores de sintaxis pero produce outputs incorrectos o falla en tiempo de ejecución.

## Contexto

Los bugs de variables en Make son silenciosos: el Makefile carga sin error, los targets se ejecutan, pero los valores son vacíos, incorrectos o causan un fallo inesperado. Cuatro patrones comunes:

1. **Forward reference con `:=`** — una variable se construye con `:=` antes de que sus dependencias estén definidas
2. **Append con `=` en lugar de `+=`** — sobreescribe el valor en lugar de acumular
3. **Orden incorrecto de `?=`** — la asignación `?=` aparece después de una `:=` que depende de ella
4. **Self-reference con `=`** — una variable de tipo `=` se referencia a sí misma → recursión infinita

## Instrucciones

1. Abre `starter/Makefile`. El archivo carga, pero tiene cuatro bugs.

2. Ejecuta cada target y observa el comportamiento incorrecto:
   ```bash
   make check-image    # Bug 1: IMAGE vacío
   make check-flags    # Bug 2: FLAGS incompleto
   make check-url      # Bug 3: DB_URL mal construido
   make check-version  # Bug 4: recursión infinita
   ```

3. **Diagnostica antes de tocar nada.** `make diagnostico` usa `$(flavor)`,
   que informa del tipo sin expandir la variable (por eso no explota con
   `VERSION`). Y `make -p` muestra lo que Make guardó:
   ```bash
   make diagnostico
   make -p __nada__ 2>/dev/null | grep -E '^(IMAGE|FLAGS|DB_URL|VERSION) '
   ```
   Debes ver:
   ```
   IMAGE:   simple
   FLAGS:   recursive
   DB_URL:  simple
   VERSION: recursive
   DB_HOST: recursive, origen file
   ```
   y, en el volcado, `IMAGE := /myapp:latest` y `DB_URL := postgres://:5432/`:
   las dos se expandieron cuando sus piezas aún no existían. `FLAGS = -O2` es
   `recursive` aunque empezó con `:=`: la última asignación cambió su tipo.
   Anota qué te dice cada línea sobre su bug.

4. Lee los comentarios `# BUG:` en el starter, identifica cada problema y corrígelo.

5. Verifica que los cuatro targets producen el output correcto (ver Criterios de éxito) y repite `make diagnostico`: tras las correcciones de la solución de referencia, las cuatro primeras líneas dicen `simple`.

## Criterios de éxito

- [ ] `make check-image` imprime:
  ```
  IMAGE: registry.local/myapp:latest
  ```
- [ ] `make check-flags` imprime:
  ```
  FLAGS: -Wall -Wextra -O2
  ```
- [ ] `make check-url` imprime:
  ```
  DB_URL: postgres://localhost:5432/myapp_dev
  ```
- [ ] `make check-version` imprime:
  ```
  VERSION: v1.0-rc1
  ```
- [ ] `make diagnostico` antes y después de corregir: puedes explicar cada cambio de `recursive` a `simple`
- [ ] Puedes describir brevemente cada bug y su causa

## Reto extra

Corrige el bug 4 de otra forma: deja `VERSION` como recursiva (`VERSION = $(BASE)-rc1`)
y comprueba con `make diagnostico` y `make check-version` que también funciona.
¿Qué diferencia hay entre las dos correcciones si más abajo alguien escribe
`BASE := v2.0`?
