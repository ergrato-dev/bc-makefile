# Lab 03 — Múltiples reglas de patrón para distintas extensiones

⏱ Duración estimada: ~50 min

## Objetivo

Definir dos reglas de patrón independientes que procesen tipos de archivo distintos en el mismo Makefile, y entender cómo Make selecciona cuál regla aplica a cada target.

## Contexto

Un Makefile puede tener múltiples reglas de patrón. Make selecciona la primera que coincida con el target solicitado. Si tienes:

```makefile
%.processed: %.raw
	@cp $< $@
	@echo "[procesado] $@"

%.backup: %.raw
	@cp $< $@.bak && mv $@.bak $@
	@echo "[backup] $@"
```

Cuando Make necesita `data.processed`, usa la primera regla (stem `data`). Cuando necesita `data.backup`, usa la segunda.

No hay conflicto porque los sufijos de los targets son distintos. El `%` captura el mismo stem en ambos casos, pero las reglas son independientes.

## Instrucciones

1. Abre `starter/Makefile`. Un target `setup` genera los archivos `.raw` de entrada.

2. Ejecuta `make setup` para crear los archivos de prueba:
   ```bash
   make setup
   ls *.raw   # debe mostrar alpha.raw, beta.raw, gamma.raw
   ```

3. Escribe la regla de patrón para `.processed`:
   ```makefile
   %.processed: %.raw
   	@cp $< $@
   	@echo "[ok] $@"
   ```

4. Escribe la regla de patrón para `.backup`:
   ```makefile
   %.backup: %.raw
   	@cp $< $@
   	@echo "[backup] $@"
   ```

5. Completa los targets que usan estas reglas:
   ```makefile
   process: alpha.processed beta.processed gamma.processed
   backup:  alpha.backup beta.backup gamma.backup
   ```

6. Verifica:
   ```bash
   make setup
   make process
   make backup
   ls *.processed *.backup
   make clean
   ```

## Criterios de éxito

- [ ] `make setup` crea `alpha.raw`, `beta.raw`, `gamma.raw`
- [ ] `make process` crea los tres `.processed` usando la regla de patrón (sin tres reglas explícitas)
- [ ] `make backup` crea los tres `.backup` usando la segunda regla de patrón
- [ ] `make alpha.processed` funciona de forma aislada (Make instancia la regla para un solo stem)
- [ ] `make clean` elimina todos los archivos generados
- [ ] El Makefile no tiene reglas explícitas `alpha.processed:`, `beta.processed:`, etc.

## Reto extra

Agrega una tercera regla de patrón `%.summary: %.raw` que use `wc -l $< > $@` para contar las líneas del archivo. Crea un target `summarize` que genere los tres `.summary` y un target `report` que muestre el contenido de todos los `.summary` con `@cat`.
