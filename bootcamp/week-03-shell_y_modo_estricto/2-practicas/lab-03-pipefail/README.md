# Lab 03 — `pipefail`: tuberías que no esconden fallos

⏱ Duración estimada: ~60 min

## Objetivo

Activar `-o pipefail` y adaptar tres tuberías reales a él: una validación que corta el flujo, un `grep` que puede no encontrar nada y un `head` que provoca SIGPIPE.

## Contexto

- El código de salida de `a | b | c` es el de `c`. Si `a` falla y `c` termina bien, la tubería "funciona": Make no se entera y el reporte sale incompleto.
- Con `-o pipefail`, la tubería devuelve el código de la última etapa que falló. Es la tercera pieza del preámbulo estricto.
- `pipefail` también saca a la luz fallos que no lo son: `grep` sin coincidencias sale con 1, y un productor al que `head` cierra la tubería muere con SIGPIPE (código 141). Hay que tratarlos a propósito, no apagar `pipefail`.

## Instrucciones

Trabaja en `starter/`. Datos: `data/pedidos.csv` (`id,cliente,pais,importe`, 15 líneas) y `data/pedidos-corrupto.csv` (la línea 5 tiene una columna de menos).

1. El caso mínimo:
   ```bash
   cd starter
   make demo; echo "código: $?"
   ```
   ```
   false | true
   código: 0
   ```
   `false` falló y nadie se enteró. Lo mismo, fuera de Make:
   ```bash
   bash -c 'false | true'; echo $?               # 0
   bash -o pipefail -c 'false | true'; echo $?   # 1
   ```

2. Un fallo real escondido. Simula una ruta mal escrita:
   ```bash
   make countries DATA=data/pedido.csv; echo "código: $?"
   ```
   ```
   cat: data/pedido.csv: No such file or directory
   cat build/countries.txt
   código: 0
   ```
   El build "terminó bien" y `build/countries.txt` está vacío (`ls -l build`). Ahora sustituye la línea de `.SHELLFLAGS` según el `# TODO (paso 2)`:
   ```makefile
   .SHELLFLAGS := -eu -o pipefail -c
   ```
   Repite el comando: termina con `make: *** [Makefile:26: countries] Error 1` y `código: 2`. `make demo` también falla ahora: es lo esperado.

3. Comprueba que el caso normal sigue funcionando: `make countries` imprime
   ```
         6 ES
         4 MX
         3 CO
         2 AR
   ```

4. Una etapa que corta la tubería. Ejecuta `make countries DATA=data/pedidos-corrupto.csv`: sale bien y aparece una línea `1 310`, el importe de la línea rota contado como si fuera un país. Sustituye `cat $(DATA) | cut -d, -f3` por una primera etapa que valide y extraiga a la vez:
   ```makefile
   	$(AWK) -F, 'NF != 4 { print FILENAME ":" NR ": línea corrupta" > "/dev/stderr"; exit 1 } { print $$3 }' $(DATA) \
   		| sort | uniq -c | sort -rn > $(BUILD_DIR)/countries.txt
   ```
   Repite el comando:
   ```
   data/pedidos-corrupto.csv:5: línea corrupta
   make: *** [Makefile:26: countries] Error 1
   ```
   Ahora quita `-o pipefail` de `.SHELLFLAGS` un momento y repite: `awk` sale con 1 pero `sort` termina bien, y el build "pasa" con los datos de las 4 primeras líneas (`2 ES`, `1 MX`, `1 CO`). Vuelve a ponerlo.

5. Cuando "no encontrar nada" no es un error. `make amounts` imprime `importes de ES: 75 95 120 180 240 310`. Ahora un país sin pedidos:
   ```bash
   make amounts COUNTRY=PT
   ```
   ```
   make: *** [Makefile:33: amounts] Error 1
   ```
   `grep` sale con **1** si no hay coincidencias y con **2** si hay un error de verdad (archivo ilegible, regex inválida). Tolera solo el 1 agrupando el `grep`:
   ```makefile
   	{ grep ",$(COUNTRY)," $(DATA) || test $$? -eq 1; } | cut -d, -f4 | sort -n > $(BUILD_DIR)/amounts.txt
   ```
   Comprueba los dos lados: `make amounts COUNTRY=PT` imprime `importes de PT: ` y sale con 0; `make amounts DATA=no-existe.csv` sigue fallando con `grep: no-existe.csv: No such file or directory`. No uses `|| true`: se traga también el 2.

6. SIGPIPE. Ejecuta `make sigpipe-demo`:
   ```
   1
   2
   3
   make: *** [Makefile:37: sigpipe-demo] Error 141
   ```
   `head` sale después de 3 líneas, `seq` intenta seguir escribiendo en una tubería cerrada y el sistema lo mata con SIGPIPE (128 + 13 = 141). Cambia `head -n 3` por `$(AWK) 'NR <= 3'`, que lee toda la entrada. Con eso, implementa `top3`:
   ```makefile
   	sort -t, -k4 -rn $(DATA) | $(AWK) 'NR <= 3'
   ```
   ```
   1005,elena,ES,310
   1014,nico,MX,260
   1003,carla,ES,240
   ```

7. `make clean`.

## Criterios de éxito

- [ ] `make countries DATA=data/pedido.csv` termina con error
- [ ] `make countries DATA=data/pedidos-corrupto.csv` imprime `data/pedidos-corrupto.csv:5: línea corrupta` y termina con error
- [ ] `make amounts COUNTRY=PT` termina con código 0; `make amounts DATA=no-existe.csv` termina con error
- [ ] `make sigpipe-demo` imprime 1, 2, 3 y termina con código 0
- [ ] `make top3` imprime los pedidos 1005, 1014 y 1003
- [ ] Puedes explicar por qué `|| true` no es equivalente a `|| test $$? -eq 1`

## Reto extra

Tras el paso 2, `build/countries.txt` quedó **vacío** después de un fallo. Ejecuta `make countries DATA=data/pedido.csv; ls -l build/` y fíjate en que el archivo sigue ahí. ¿Por qué `.DELETE_ON_ERROR` no lo borraría aunque lo declarases? (Pista: ¿cuál es el target de esa regla?) Lo resuelves en el lab-04.
