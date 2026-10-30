# Lab 02 — Expansión recursiva

⏱ Duración estimada: ~60 min

## Objetivo

Demostrar que el operador `=` evalúa la variable en el momento de uso, permitiendo referenciar variables definidas más adelante en el archivo — y entender cuándo eso se convierte en un peligro.

## Contexto

Con `=`, Make no evalúa el valor al momento de la asignación sino cuando la variable se usa en una receta. Esto significa:

```makefile
# Con =: funciona aunque DESTINATARIO se defina DESPUÉS
SALUDO = Hola, $(DESTINATARIO)!
DESTINATARIO = Mundo
```

Con `:=` (inmediato), `SALUDO` capturaría el valor de `DESTINATARIO` en el momento en que se define `SALUDO`. Si `DESTINATARIO` no está definido aún, `SALUDO` queda como `"Hola, !"`.

El riesgo de `=` aparece cuando una variable se referencia a sí misma:

```makefile
VERSION = $(VERSION)-snapshot   # ERROR: recursión infinita con =
```

GNU Make detecta esto y falla con: `Recursive variable 'VERSION' references itself (eventually).`

## Instrucciones

1. Abre `starter/Makefile`.

2. Define `SALUDO_LAZY` con `=` (no `:=`), referenciando `$(DESTINATARIO_LAZY)`:
   ```makefile
   SALUDO_LAZY = Hola, $(DESTINATARIO_LAZY)!
   ```

3. Define `DESTINATARIO_LAZY` con `=` y valor `"Mundo"` — **después** de `SALUDO_LAZY` en el archivo.

4. Define `SALUDO_EAGER` con `:=`, referenciando `$(DESTINATARIO_EAGER)`:
   ```makefile
   SALUDO_EAGER := Hola, $(DESTINATARIO_EAGER)!
   ```

5. Define `DESTINATARIO_EAGER` con `:=` y valor `"Mundo"` — **después** de `SALUDO_EAGER`.

6. Completa los dos targets. Ejecuta:
   ```bash
   make lazy
   make eager
   ```

7. Compara los outputs e intenta explicar la diferencia.

8. **Mira cómo guarda Make cada variable.** `make -p` vuelca su base de datos
   interna; pídele un target inexistente para que no ejecute nada:
   ```bash
   make -p __nada__ 2>/dev/null | grep -E '^SALUDO_'
   ```
   Debes ver (el orden puede variar):
   ```
   SALUDO_EAGER := Hola, !
   SALUDO_LAZY = Hola, $(DESTINATARIO_LAZY)!
   ```
   La recursiva guarda el texto sin expandir; la simple guarda el resultado
   ya calculado, con el hueco vacío incluido.

9. **Recursión infinita.** El starter define `PELIGROSO = $(PELIGROSO)-snapshot`.
   Ejecuta:
   ```bash
   make peligro
   ```
   Make se detiene antes de ejecutar nada:
   ```
   Makefile:NN: *** Recursive variable 'PELIGROSO' references itself (eventually).  Stop.
   ```
   Para expandir `PELIGROSO` necesita expandir `PELIGROSO`, sin fin.

10. Ahora la versión que sí funciona. Completa el TODO del paso 10:
    ```makefile
    VERSION_RELEASE := v1.0
    VERSION_RELEASE := $(VERSION_RELEASE)-snapshot
    ```
    y ejecuta `make corregido`. Debes ver `VERSION_RELEASE: v1.0-snapshot`. Con
    `:=` el lado derecho se expande una sola vez, con el valor anterior, y el
    resultado se guarda: no queda ninguna referencia pendiente. Es el patrón
    para "añadir un sufijo a lo que ya había".

## Criterios de éxito

- [ ] `make lazy` imprime:
  ```
  SALUDO_LAZY: Hola, Mundo!
  ```
- [ ] `make eager` imprime:
  ```
  SALUDO_EAGER: Hola, !
  ```
  (DESTINATARIO_EAGER estaba vacío cuando se evaluó `:=`)
- [ ] `make -p` muestra `SALUDO_LAZY` sin expandir y `SALUDO_EAGER` expandido
- [ ] `make peligro` falla con `Recursive variable 'PELIGROSO' references itself`
- [ ] `make corregido` imprime `VERSION_RELEASE: v1.0-snapshot`
- [ ] Puedes explicar verbalmente por qué los resultados son distintos
- [ ] `make help` funciona correctamente

## Reto extra

> [!NOTE]
> **Make 4.4+.** El operador `:::=` expande el lado derecho al momento, como
> `:=`, pero crea una variable **recursiva**. Si tienes Make 4.4 (o Docker:
> `docker run --rm -v "$PWD":/w -w /w debian:13 bash -c 'apt-get update -qq && apt-get install -y -qq make >/dev/null && make ...'`),
> prueba:
> ```makefile
> NOMBRE := Ana
> SALUDO :::= Hola $(NOMBRE)
> NOMBRE := Luis
> SALUDO += $(NOMBRE)
> ```
> `$(SALUDO)` vale `Hola Ana Luis` y `$(flavor SALUDO)` dice `recursive`.
> ¿Por qué `Ana` quedó congelado y `Luis` no? En Make 4.3 la línea `:::=` da
> `*** empty variable name.  Stop.`; allí la alternativa es `:=`.
