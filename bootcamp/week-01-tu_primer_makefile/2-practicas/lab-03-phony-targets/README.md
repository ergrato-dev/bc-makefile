# Lab 03 — .PHONY: targets que no crean archivos

⏱ Duración estimada: ~50 min

## Objetivo

Demostrar por qué `.PHONY` es obligatorio para targets que no producen un archivo, y corregir el comportamiento cuando Make confunde un target con un archivo existente.

## Contexto

Make compara el nombre del target con archivos en el filesystem. Si existe un archivo con ese nombre y nadie lo declaró `.PHONY`, Make asume que el target "ya está construido" y no ejecuta la receta. Esto es el bug más silencioso y frustrante del ecosistema Make.

## Instrucciones

1. Abre `starter/Makefile`. Tiene targets `build` y `clean` sin `.PHONY`.

2. Ejecuta `make build` para crear el directorio `output/`:
   ```bash
   make build
   ```
   Debe funcionar. Ejecuta de nuevo:
   ```bash
   make build
   ```
   Segunda vez: ¿sigue funcionando? (sí, porque `build` no es un archivo).

3. Ahora crea un archivo llamado exactamente `clean`:
   ```bash
   touch clean
   ```

4. Ejecuta `make clean`:
   ```bash
   make clean
   ```
   Observa el mensaje de Make. No ejecuta la receta.

5. Agrega `.PHONY: all build clean help` al Makefile (ver TODO).

6. Ejecuta `make clean` de nuevo — ahora sí debe ejecutar la receta.

7. Elimina el archivo trampa:
   ```bash
   rm clean
   ```

8. Verifica que `make build` y `make clean` funcionan correctamente.

## Criterios de éxito

- [ ] Sin `.PHONY`, `make clean` con archivo `clean` presente imprime `make: 'clean' is up to date`
- [ ] Con `.PHONY`, `make clean` ejecuta la receta aunque exista el archivo `clean`
- [ ] `make build` crea `output/app.txt`
- [ ] `make clean` elimina `output/`
- [ ] `make help` lista los 4 targets

## Reto extra

Crea un archivo llamado `build` (sin extensión): `touch build`. ¿Qué pasa con `make build` sin `.PHONY`? Agrega `build` al `.PHONY` y verifica que el problema desaparece. Borra el archivo trampa al terminar.
