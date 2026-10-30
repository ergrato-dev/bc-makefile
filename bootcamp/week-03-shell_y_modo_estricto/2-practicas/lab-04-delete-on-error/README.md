# Lab 04 — `.DELETE_ON_ERROR` y qué hace Make cuando una receta falla

⏱ Duración estimada: ~60 min

## Objetivo

Evitar que un archivo a medio escribir pase por "al día" declarando `.DELETE_ON_ERROR`, y distinguir cuándo usar (y cuándo no) el prefijo `-`, `make -k` y `make -i`.

## Contexto

- Una redirección `> $@` crea el archivo **antes** de que el comando termine. Si el comando falla a mitad, queda un archivo con fecha nueva y contenido incompleto. Para Make, un archivo más nuevo que sus prerrequisitos está al día.
- `.DELETE_ON_ERROR:` le dice a Make que borre el target cuando su receta falla. Es la última línea del preámbulo estricto.
- Hay tres formas de seguir adelante tras un error: el prefijo `-` (una línea), `make -k` (otros targets independientes) y `make -i` (todo). Solo una de ellas es segura en CI.

## Instrucciones

Trabaja en `starter/`. Datos: `data/productos.csv` (`sku,nombre,precio,stock`) y `data/productos-roto.csv`, con `N/A` como precio en la línea 4.

1. El camino feliz:
   ```bash
   cd starter
   make report
   cat build/catalog.txt build/stock.txt
   make clean
   ```
   El catálogo tiene 6 productos y el stock dice `unidades en stock: 130`.

2. Un fallo a mitad de escritura:
   ```bash
   make catalog DATA=data/productos-roto.csv
   ```
   ```
   precio inválido en la línea 4
   make: *** [Makefile:32: build/catalog.txt] Error 1
   ```
   Hasta aquí, bien: falló y lo dijo. Pero mira lo que quedó y vuelve a ejecutar:
   ```bash
   cat build/catalog.txt
   make catalog DATA=data/productos-roto.csv; echo "código: $?"
   ```
   ```
   teclado        45 EUR
   raton          20 EUR
   monitor       180 EUR
   make: Nothing to be done for 'catalog'.
   código: 0
   ```
   Un catálogo con 3 de 6 productos, y la segunda ejecución sale con **0**. Si el CI reintenta, pasa en verde.

3. Sustituye `# TODO (paso 3)` por:
   ```makefile
   .DELETE_ON_ERROR:
   ```
   Repite `make catalog DATA=data/productos-roto.csv` (dos veces):
   ```
   precio inválido en la línea 4
   make: *** [Makefile:32: build/catalog.txt] Error 1
   make: *** Deleting file 'build/catalog.txt'
   ```
   Ahora falla siempre, y `ls build` no muestra `catalog.txt`. Comprueba que Make lo registra:
   ```bash
   make -p __nada__ 2>/dev/null | grep '^.DELETE_ON_ERROR'
   ```

4. La excepción: Ctrl-C. Ejecuta `make clean && make slow` y pulsa **Ctrl-C** antes de 10 segundos:
   ```
   ^Cmake: *** Deleting file 'build/slow.txt'
   make: *** [Makefile:43: build/slow.txt] Interrupt
   ```
   Make borra el target interrumpido incluso sin `.DELETE_ON_ERROR`. Compruébalo comentando esa línea y repitiendo; luego descoméntala.

5. El prefijo `-`. En la receta de `$(CATALOG)`, pon un `-` delante de `$(AWK)` (`	-$(AWK) -F, ...`) y ejecuta:
   ```bash
   make catalog DATA=data/productos-roto.csv; echo "código: $?"
   ```
   ```
   precio inválido en la línea 4
   make: [Makefile:32: build/catalog.txt] Error 1 (ignored)
   código: 0
   ```
   Fíjate en lo que **no** aparece: `Deleting file`. Si el error se ignora, para Make no hubo error, y el catálogo roto sobrevive. Quita el `-` y ejecuta `make clean`. Regla: `-` solo en comandos cuyo fallo no cambia el resultado (una notificación opcional), nunca en uno que escribe el target.

6. `make -k`. Con datos rotos, `make report` para en el primer error y `stock.txt` ni se intenta:
   ```bash
   make report DATA=data/productos-roto.csv; ls build
   ```
   La carpeta `build/` queda vacía. Ahora con `-k` (keep going):
   ```bash
   make -k report DATA=data/productos-roto.csv; echo "código: $?"
   ```
   ```
   make: *** [Makefile:32: build/catalog.txt] Error 1
   make: *** Deleting file 'build/catalog.txt'
   ...
   make: Target 'report' not remade because of errors.
   código: 2
   ```
   Make construye todo lo que no depende del fallo (`stock.txt`) y aun así termina con error. Útil en CI para ver **todos** los fallos de una vez.

7. `make -i`. Ejecuta `make clean` y luego:
   ```bash
   make -i report DATA=data/productos-roto.csv; echo "código: $?"
   cat build/catalog.txt
   ```
   ```
   make: [Makefile:32: build/catalog.txt] Error 1 (ignored)
   código: 0
   ```
   Es un `-` delante de cada línea del Makefile: código 0, sin `Deleting file`, y el catálogo de 3 productos queda como bueno. No tiene uso legítimo en un build.

8. `make clean`.

## Criterios de éxito

- [ ] Con `.DELETE_ON_ERROR`, `make catalog DATA=data/productos-roto.csv` imprime `Deleting file 'build/catalog.txt'` y falla en cada ejecución
- [ ] `make -p __nada__ | grep '^.DELETE_ON_ERROR'` encuentra la declaración
- [ ] Viste el `Deleting file` de Ctrl-C en `make slow`
- [ ] `make -k report DATA=data/productos-roto.csv` crea `build/stock.txt` y termina con código 2
- [ ] La receta de `$(CATALOG)` no tiene prefijo `-`
- [ ] Puedes explicar por qué `make -i` deja pasar el catálogo roto aunque declares `.DELETE_ON_ERROR`

## Reto extra

Otra defensa, compatible con `.DELETE_ON_ERROR`: escribir en un temporal y renombrar al final (`... > $@.tmp && mv $@.tmp $@`). `mv` dentro del mismo sistema de archivos es atómico: nadie ve nunca un `catalog.txt` a medias, ni siquiera mientras la receta corre. Aplícalo a `$(CATALOG)` y responde en un comentario: si la receta falla, ¿qué archivo queda ahora en `build/`, y lo borra `.DELETE_ON_ERROR`?
