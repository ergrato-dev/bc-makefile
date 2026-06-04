# Lab 02 — Cadenas de dependencias

⏱ Duración estimada: ~50 min

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

## Criterios de éxito

- [ ] `make run` imprime los 4 pasos en orden correcto
- [ ] `make compile` solo ejecuta `prepare` y `compile`
- [ ] `make prepare` solo ejecuta `prepare`
- [ ] Segunda ejecución de `make run` ejecuta todo de nuevo (PHONY)

## Reto extra

Agrega un quinto target `test` que dependa de `run` y ejecute una verificación ficticia. Luego agrega otro target `ci` que dependa de `test` y simule un reporte de CI. Ejecuta `make ci` y observa la cadena completa de 5 pasos.
