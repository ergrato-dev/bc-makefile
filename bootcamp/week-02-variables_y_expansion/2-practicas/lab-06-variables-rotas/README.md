# Lab 06 — Variables rotas

⏱ Duración estimada: ~50 min

## Objetivo

Identificar y corregir cuatro bugs de expansión de variables en un Makefile que carga sin errores de sintaxis pero produce outputs incorrectos o falla en tiempo de ejecución.

## Contexto

Los bugs de variables en Make son silenciosos: el Makefile carga sin error, los targets se ejecutan, pero los valores son vacíos, incorrectos o causan un fallo inesperado. Cuatro patrones comunes:

1. **Forward reference con `:=`** — una variable se construye con `:=` antes de que sus dependencias estén definidas
2. **Append con `=` en lugar de `+=`** — sobreescribe el valor en lugar de acumular
3. **Self-reference con `=`** — una variable de tipo `=` se referencia a sí misma → recursión infinita
4. **Orden incorrecto de `?=`** — la asignación `?=` aparece después de una `:=` que depende de ella

## Instrucciones

1. Abre `starter/Makefile`. El archivo carga, pero tiene cuatro bugs.

2. Ejecuta cada target y observa el comportamiento incorrecto:
   ```bash
   make check-image    # Bug 1: IMAGE vacío
   make check-flags    # Bug 2: FLAGS incompleto
   make check-url      # Bug 3: DB_URL mal construido
   make check-version  # Bug 4: recursión infinita
   ```

3. Lee los comentarios `# BUG:` en el starter, identifica cada problema y corrígelo.

4. Verifica que los cuatro targets producen el output correcto (ver Criterios de éxito).

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
- [ ] Puedes describir brevemente cada bug y su causa

## Reto extra

Usa `make --print-data-base | grep "^[A-Z]"` para inspeccionar las variables que Make conoce. Identifica cuáles tienen el valor esperado y cuáles no. Este comando es útil para depurar cualquier Makefile en producción.
