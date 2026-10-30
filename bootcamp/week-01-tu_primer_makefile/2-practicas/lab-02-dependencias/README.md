# Lab 02 — Cadenas de dependencias

⏱ Duración estimada: ~60 min

## Objetivo

Conectar targets en una cadena de dependencias para que Make los ejecute en el orden correcto automáticamente.

## Contexto

Make resuelve dependencias antes de ejecutar un target. Si `run` depende de `link`, y `link` depende de `compile`, ejecutar `make run` dispara la cadena completa en orden: `compile` → `link` → `run`.

Si un target no tiene dependencias declaradas, Make no sabe qué ejecutar antes — el orden queda indefinido.

## Instrucciones

1. Abre `starter/Makefile`. El pipeline tiene 4 pasos: `prepare → compile → link → run`.

2. Ejecuta `make run` tal como está:
   ```bash
   make run
   ```
   Observa: solo imprime `[4/4]`, no los pasos anteriores.

3. Agrega las dependencias faltantes (indicadas con `# TODO` en cada target):
   - `run` debe depender de `link`
   - `link` debe depender de `compile`
   - `compile` debe depender de `prepare`

4. Ejecuta `make run` de nuevo. Debes ver los 4 pasos en orden:
   ```
   [1/4] Preparando entorno...
   [2/4] Compilando fuentes...
   [3/4] Vinculando objetos...
   [4/4] Ejecutando programa...
   >>> ¡Programa corriendo!
   ```

5. Ejecuta `make run` una segunda vez. ¿Qué pasa? (todos son PHONY → siempre corren)

6. Ejecuta solo `make compile`:
   ```bash
   make compile
   ```
   Observa qué targets se ejecutan — solo `prepare` y `compile`.

7. **Dependencias en diamante.** `test` y `lint` necesitan los dos el código
   compilado, y `check` necesita ambos. Completa los TODO del paso 7:
   `test: compile`, `lint: compile` y `check: test lint`. Antes de ejecutarlo,
   predice cuántas veces aparecerá `[2/4] Compilando fuentes...`. Luego:
   ```bash
   make check
   ```
   Debes ver:
   ```
   [1/4] Preparando entorno...
   [2/4] Compilando fuentes...
   [test] Pruebas OK.
   [lint] Estilo OK.
   [check] Todo verificado.
   ```
   `compile` aparece **una sola vez**: en una misma ejecución Make construye
   cada target como mucho una vez, aunque varios dependan de él. Las
   dependencias se recorren de izquierda a derecha: por eso `test` va antes que
   `lint`.

8. Comprueba la misma regla con varios objetivos en la línea de comandos:
   ```bash
   make link compile
   ```
   Debes ver los pasos 1 a 3 y al final:
   ```
   make: Nothing to be done for 'compile'.
   ```
   `compile` ya se hizo como dependencia de `link`; pedirlo otra vez en la
   misma ejecución no lo repite.

9. Usa `make -n check` para ver qué ejecutaría Make sin ejecutar nada. Salen
   los `echo` como texto: es la forma segura de revisar el orden antes de
   lanzar un pipeline real.

## Criterios de éxito

- [ ] `make run` imprime los 4 pasos en orden correcto
- [ ] `make compile` solo ejecuta `prepare` y `compile`
- [ ] `make prepare` solo ejecuta `prepare`
- [ ] Segunda ejecución de `make run` ejecuta todo de nuevo (PHONY)
- [ ] `make check` imprime `[2/4] Compilando fuentes...` exactamente una vez, antes de `[test]` y `[lint]`
- [ ] `make link compile` termina con `Nothing to be done for 'compile'`

## Reto extra

Agrega un target `ci` que dependa de `check` y de `run`. Antes de ejecutar
`make ci`, escribe en papel la secuencia exacta de líneas que esperas ver
(¿cuántas veces sale `[2/4]`?). Compruébalo con `make -n ci` y luego con
`make ci`. Después cambia el orden a `ci: run check`: ¿qué líneas cambian de
sitio y cuáles no?
