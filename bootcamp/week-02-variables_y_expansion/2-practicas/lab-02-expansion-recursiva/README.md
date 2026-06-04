# Lab 02 — Expansión recursiva

⏱ Duración estimada: ~50 min

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
- [ ] Puedes explicar verbalmente por qué los resultados son distintos
- [ ] `make help` funciona correctamente

## Reto extra

Añade un target `peligro` que demuestre la recursión infinita. En el `starter`, `PELIGROSO` ya está definido con `=` de forma circular. Ejecuta `make peligro` y observa el mensaje de error. Luego corrige la variable para que imprima `"v1.0-snapshot"` sin recursión.
