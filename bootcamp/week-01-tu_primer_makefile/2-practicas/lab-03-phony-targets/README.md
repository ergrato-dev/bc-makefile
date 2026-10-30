# Lab 03 — .PHONY: targets que no crean archivos

⏱ Duración estimada: ~60 min

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

9. **Varios objetivos en una línea.** Ejecuta:
   ```bash
   make clean build
   ```
   Make los procesa en el orden en que los escribes: primero `Limpio.`, después
   `Build completo`. Ahora repite un objetivo:
   ```bash
   make build build
   ```
   Debes ver la receta una vez y después:
   ```
   make: Nothing to be done for 'build'.
   ```
   `.PHONY` significa "ejecútalo siempre que se pida", pero en una misma
   ejecución Make construye cada target una sola vez.

10. **¿Quién decide qué hace `make` a secas?** Comenta la línea
    `.DEFAULT_GOAL := help` (pon `#` delante) y ejecuta `make` sin argumentos:
    ```
    Construyendo...
    Build completo: output/app.txt creado
    Todo listo.
    ```
    Sin `.DEFAULT_GOAL`, Make ejecuta el **primer target** del archivo (`all`),
    y un `make` inocente construye cosas. Descomenta la línea, ejecuta `make` y
    comprueba que vuelve a salir la ayuda. Termina con `make clean`.

## Criterios de éxito

- [ ] Sin `.PHONY`, `make clean` con archivo `clean` presente imprime `make: 'clean' is up to date`
- [ ] Con `.PHONY`, `make clean` ejecuta la receta aunque exista el archivo `clean`
- [ ] `make build` crea `output/app.txt`
- [ ] `make clean` elimina `output/`
- [ ] `make build build` ejecuta la receta una vez y dice `Nothing to be done for 'build'`
- [ ] Con `.DEFAULT_GOAL` comentado, `make` ejecuta `all`; restaurado, muestra la ayuda
- [ ] `make help` lista los 4 targets

## Reto extra

Crea un archivo llamado `build` (sin extensión): `touch build`. ¿Qué pasa con `make build` sin `.PHONY`? Agrega `build` al `.PHONY` y verifica que el problema desaparece. Borra el archivo trampa al terminar.
