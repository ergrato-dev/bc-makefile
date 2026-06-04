# Lab 04 — `$*`: el stem en reglas de patrón

⏱ Duración estimada: ~50 min

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

## Criterios de éxito

- [ ] `make alfa.resultado` imprime el stem `alfa`, la entrada `alfa.entrada` y la salida `alfa.resultado`
- [ ] `make all` construye los tres archivos `.resultado`
- [ ] Modificar `beta.entrada` y volver a ejecutar `make all` solo reconstruye `beta.resultado`
- [ ] `make limpiar` elimina todos los `.resultado` sin errores
- [ ] `make help` lista todos los targets con descripción

## Reto extra

Agrega en la regla de patrón un tercer echo que imprime la ruta de un hipotético archivo de log: `"[proceso] Log: logs/$*.log"`. No es necesario crear el archivo; solo demostrar que `$*` permite derivar rutas arbitrarias desde el stem.
