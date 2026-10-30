# Lab 01 — `-j`: cuántas tareas a la vez

⏱ Duración estimada: ~60 min

## Objetivo

Medir el efecto de `-j` en un build de tareas independientes contando cuántas se ejecutan a la vez, en lugar de fiarse solo del reloj.

## Contexto

- El Makefile genera seis informes. Cada uno tarda un segundo (`sleep`) y no depende de ningún otro: es justo el trabajo que `-j` reparte.
- `time` te dice cuánto tardó el build, pero en un portátil cargado o en CI la cifra baila. Contar **solapes** (cuántas recetas estaban en marcha a la vez) es estable: cada receta escribe `start` y `end` en un archivo de traza y `awk` calcula el máximo.
- `.NOTPARALLEL:` sin prerrequisitos apaga el paralelismo de todo el Makefile aunque pases `-j`. Es el freno de emergencia para un Makefile que todavía no es seguro en paralelo.

## Instrucciones

1. Copia el starter y mira los targets:
   ```bash
   cp -r starter/ mi-lab-01 && cd mi-lab-01
   make help
   ```

2. Mide la línea base en serie:
   ```bash
   make clean && time make all
   ```
   Verás los seis `[x] generando...` uno detrás de otro y `real` de unos 6 s.

3. Repite con tres trabajos a la vez:
   ```bash
   make clean && time make -j3 all
   ```
   Los mensajes salen de tres en tres y `real` baja a unos 2 s. Prueba también `-j6`: 1 s. Más allá de 6 no gana nada, porque solo hay seis tareas.

4. Implementa los **TODO 1 y 2**: la traza en la regla de patrón y el target `concurrency`. Después:
   ```bash
   make clean && make -j4 all && make concurrency
   ```
   Debes ver:
   ```
   Máximo simultáneo: 4
   ```
   Con `make clean && make all && make concurrency` debe salir `1`; con `-j2`, `2`. Esta es la medida que usa el autograding del proyecto para comprobar que tu build es paralelo de verdad.

5. Prueba `-j` sin número:
   ```bash
   make clean && make -j all && make concurrency
   ```
   Sale `6`: sin número, Make lanza **todo** lo que esté listo. Con seis tareas da igual; con 2 000 objetos C, saturas la memoria. Usa `-j$(nproc)` (en macOS, `-j$(sysctl -n hw.ncpu)`).

6. Implementa el **TODO 3** (`SERIAL=1` declara `.NOTPARALLEL:`) y comprueba que gana a `-j`:
   ```bash
   make clean && make -j4 all SERIAL=1 && make concurrency
   ```
   Debes ver `Máximo simultáneo: 1`.

7. Lanza `clean` y `all` en la misma invocación paralela, y observa:
   ```bash
   make -j4 clean all; make concurrency
   ```
   A veces funciona y a veces no: `clean` y la creación de `out/` compiten. Esto es una **carrera**, y la arreglas en el [lab-02](../lab-02-carrera-roto/README.md). Mientras tanto: `make clean && make -j4 all`, en dos invocaciones.

## Criterios de éxito

- [ ] `make clean && make all && make concurrency` imprime `Máximo simultáneo: 1`
- [ ] `make clean && make -j4 all && make concurrency` imprime `Máximo simultáneo: 4`
- [ ] `make clean && make -j4 all SERIAL=1 && make concurrency` imprime `Máximo simultáneo: 1`
- [ ] `make concurrency` sin build previo avisa y sale distinto de 0
- [ ] `make clean OUT_DIR=` se niega a borrar

## Reto extra

Cambia `sleep $(DELAY)` por `sleep $$(( RANDOM % 3 + 1 ))` y mide `make -j6 all` varias veces. Explica en un comentario por qué el tiempo total con `-j6` es siempre el del informe más lento, y por qué con `-j2` depende del orden en que Make reparte las tareas.
