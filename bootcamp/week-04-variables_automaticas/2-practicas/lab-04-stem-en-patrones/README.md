# Lab 04 — `$*`: el stem en reglas de patrón

⏱ Duración estimada: ~60 min

## Objetivo

Usar `$*` para extraer el stem (la parte que coincidió con `%`) en una regla de patrón y derivar nombres de archivo relacionados.

## Contexto

En una regla de patrón como `%.resultado: %.entrada`, el `%` es un wildcard que coincide con cualquier string. El texto que coincide se llama **stem** y se expone en `$*`:

| Target pedido | Stem `$*` | `$@` | `$<` |
|---------------|-----------|------|------|
| `alfa.resultado` | `alfa` | `alfa.resultado` | `alfa.entrada` |
| `beta.resultado` | `beta` | `beta.resultado` | `beta.entrada` |
| `gamma.resultado` | `gamma` | `gamma.resultado` | `gamma.entrada` |

`$*` es útil para derivar rutas adicionales a partir del nombre base: archivos de log, archivos de dependencias `.d`, o carpetas de salida nombradas según el módulo.

**Importante:** `$*` solo tiene valor dentro de una regla de patrón. En reglas explícitas (`main.o: main.c`) siempre expande a cadena vacía.

## Instrucciones

1. Crea los archivos de entrada con `make setup`. Esto genera `alfa.entrada`, `beta.entrada` y `gamma.entrada` con contenido de prueba.

2. Abre `starter/Makefile` y completa la regla de patrón `%.resultado: %.entrada`:
   ```makefile
   %.resultado: %.entrada
   	@echo "[proceso] Stem:    $*"
   	@echo "[proceso] Entrada: $<"
   	@echo "[proceso] Salida:  $@"
   	@cp $< $@
   ```

3. Verifica un archivo individual:
   ```bash
   make alfa.resultado
   # [proceso] Stem:    alfa
   # [proceso] Entrada: alfa.entrada
   # [proceso] Salida:  alfa.resultado
   ```

4. Completa el target `all` para que construya todos los `.resultado` usando la variable `SALIDAS`. Luego ejecuta:
   ```bash
   make all
   ```

5. Modifica `alfa.entrada` y ejecuta `make all` de nuevo. Solo `alfa.resultado` debe reconstruirse.

6. Completa el target `limpiar` para eliminar todos los `.resultado`.

7. **Derivar rutas desde el stem.** Haz que la regla escriba además un log por
   archivo procesado en `logs/<stem>.log`. Completa el TODO del paso 7 y
   ejecuta:
   ```bash
   make -B alfa.resultado
   cat logs/alfa.log
   # alfa procesado desde alfa.entrada
   ```
   `-B` fuerza a rehacer aunque esté al día. El nombre del log no está escrito
   en ningún sitio: sale de `$*`.

8. **El stem incluye el directorio.** `setup` creó también `sub/delta.entrada`.
   Ejecuta:
   ```bash
   make sub/delta.resultado
   ```
   Debes ver:
   ```
   [proceso] Stem:    sub/delta
   [proceso] Entrada: sub/delta.entrada
   [proceso] Salida:  sub/delta.resultado
   [proceso] Log:     logs/delta.log
   ```
   Cuando el target tiene directorio y el patrón no, `%` se ajusta solo al
   nombre y Make añade el directorio al stem: `$*` vale `sub/delta`. Por eso
   el log usa `$(*F)`, la parte de archivo del stem (igual que `$(@F)` con
   `$@`); con `logs/$*.log` intentaría escribir en `logs/sub/delta.log`, un
   directorio que no existe. Termina con `make limpiar`.

## Criterios de éxito

- [ ] `make alfa.resultado` imprime el stem `alfa`, la entrada `alfa.entrada` y la salida `alfa.resultado`
- [ ] `make all` construye los tres archivos `.resultado`
- [ ] Modificar `beta.entrada` y volver a ejecutar `make all` solo reconstruye `beta.resultado`
- [ ] `logs/alfa.log` contiene `alfa procesado desde alfa.entrada`
- [ ] `make sub/delta.resultado` imprime el stem `sub/delta` y escribe `logs/delta.log`
- [ ] `make limpiar` elimina los `.resultado`, `logs/` y `sub/` sin errores
- [ ] `make help` lista todos los targets con descripción

## Reto extra

Cambia el log a `logs/$*.log` y ejecuta `make sub/delta.resultado`: lee el
error. Arréglalo sin volver a `$(*F)`, creando el directorio que haga falta
(pista: `mkdir -p` y la parte de directorio de la ruta del log). ¿Qué
estructura queda dentro de `logs/`?
