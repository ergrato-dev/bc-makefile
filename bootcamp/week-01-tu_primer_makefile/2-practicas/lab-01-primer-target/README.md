# Lab 01 — Tu primer target

⏱ Duración estimada: ~50 min

## Objetivo

Escribir targets Make funcionales que ejecuten comandos de shell e integren variables de entorno capturadas con `$(shell ...)`.

## Contexto

Un Makefile mínimo tiene tres partes: el nombre del target, sus dependencias (pueden ser ninguna) y la receta. La receta son comandos de shell, uno por línea, **cada línea indentada con un TAB real** — no espacios.

El prefijo `@` antes de un comando lo ejecuta sin imprimir el comando mismo en consola. Sin `@`, Make imprime cada línea antes de ejecutarla.

## Instrucciones

1. Abre `starter/Makefile`. Verás dos targets con TODOs.

2. Implementa `saludar` para que imprima exactamente:
   ```
   Hola desde Make!
   ```
   Usa `@echo`.

3. Implementa `info` para que imprima:
   ```
   Fecha:       <fecha actual>
   Usuario:     <tu usuario>
   Directorio:  <ruta actual>
   ```
   Usa `$(shell date)`, `$(shell whoami)`, `$(shell pwd)`.

4. Verifica:
   ```bash
   make saludar
   make info
   make help
   ```

5. Prueba sin el `@`:
   - Quita el `@` de un `echo` en `saludar`
   - Ejecuta `make saludar` — observa la diferencia en el output

## Criterios de éxito

- [ ] `make saludar` imprime `Hola desde Make!` (una sola línea)
- [ ] `make info` imprime tres líneas con Fecha, Usuario y Directorio
- [ ] `make help` lista los tres targets con descripción
- [ ] Las recetas usan `@echo` (sin `@` también cuenta, pero entiende la diferencia)

## Reto extra

Agrega un cuarto target `sistema` que imprima:
- Sistema operativo (`uname -s`)
- Versión de Make (`$(MAKE) --version | head -1`)
- Memoria libre (comando libre según tu OS)
