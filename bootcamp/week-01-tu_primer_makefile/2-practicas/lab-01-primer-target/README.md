# Lab 01 — Tu primer target

⏱ Duración estimada: ~60 min

## Objetivo

Escribir targets que ejecuten comandos de shell, comprueben que usas GNU Make ≥ 4.3 y muestren cómo Make ejecuta cada línea de receta.

## Contexto

Un Makefile mínimo tiene tres partes: el nombre del target, sus dependencias (pueden ser ninguna) y la receta. La receta son comandos de shell, uno por línea, **cada línea indentada con un TAB real** — no espacios.

El prefijo `@` antes de un comando lo ejecuta sin imprimir el comando mismo en consola. Sin `@`, Make imprime cada línea antes de ejecutarla.

## Instrucciones

1. Comprueba tu versión de Make antes de escribir nada:
   ```bash
   make --version | head -1
   ```
   Debes ver `GNU Make 4.3` o superior. Si ves `3.81` (macOS) o no aparece
   `GNU`, sigue [02-instalacion-y-version.md](../../1-teoria/02-instalacion-y-version.md)
   y vuelve.

2. Entra en `starter/` y ejecuta `make` sin argumentos. Verás la ayuda con los
   cinco targets del lab, aunque aún no hagan nada.

3. Implementa `saludar` para que imprima exactamente:
   ```
   Hola desde Make!
   ```
   Usa `@echo`.

4. Implementa `info` para que imprima:
   ```
   Fecha:       <fecha actual>
   Usuario:     <tu usuario>
   Directorio:  <ruta actual>
   ```
   Usa `$(shell date)`, `$(shell whoami)`, `$(shell pwd)`.

5. Prueba sin el `@`: quita el `@` de un `echo` en `saludar` y ejecuta
   `make saludar`. Make imprime primero el comando y después su salida:
   ```
   echo "Hola desde Make!"
   Hola desde Make!
   ```
   Vuelve a poner el `@`.

6. Implementa `check-make` siguiendo el TODO: imprime la versión con
   `$(MAKE_VERSION)` y falla si es anterior a 4.3. Verifica los dos casos:
   ```bash
   make check-make
   make check-make MAKE_VERSION=3.81   # simula el make de macOS
   echo $?
   ```
   Con tu versión real debes ver `Versión OK.`; con `3.81`:
   ```
   Usando GNU Make 3.81
   Error: necesitas GNU Make >= 4.3
   make: *** [Makefile:NN: check-make] Error 1
   ```
   y `echo $?` imprime `2`: Make devuelve 2 cuando una receta falla.

7. Implementa `donde` con tres líneas de receta: `@cd /tmp`, `@pwd` y
   `@cd /tmp && pwd`. Ejecuta `make donde`:
   ```
   /ruta/a/lab-01-primer-target/starter
   /tmp
   ```
   El primer `pwd` no está en `/tmp`: **cada línea de receta se ejecuta en su
   propia shell**, así que el `cd` de una línea no sobrevive a la siguiente. Para
   encadenar, únelas con `&&` en la misma línea.

8. Verifica todo:
   ```bash
   make saludar
   make info
   make check-make
   make donde
   make help
   ```

## Criterios de éxito

- [ ] `make --version` muestra GNU Make ≥ 4.3 (o `gmake --version` en macOS)
- [ ] `make saludar` imprime `Hola desde Make!` (una sola línea)
- [ ] `make info` imprime tres líneas con Fecha, Usuario y Directorio
- [ ] `make check-make` imprime `Versión OK.`; con `MAKE_VERSION=3.81` sale con código 2
- [ ] `make donde` imprime primero el directorio del lab y después `/tmp`
- [ ] `make help` lista los cinco targets con descripción

## Reto extra

Agrega un cuarto target `sistema` que imprima:
- Sistema operativo (`uname -s`)
- Versión de Make (`$(MAKE) --version | head -1`; compárala con `$(MAKE_VERSION)`)
- Memoria libre (comando libre según tu OS)
