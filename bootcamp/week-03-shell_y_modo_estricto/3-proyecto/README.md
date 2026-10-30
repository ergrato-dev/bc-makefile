# Proyecto Semana 03 — Reportes de accesos a prueba de fallos

⏱ Duración estimada: ~3 h

## Contexto

El equipo de operaciones recibe cada mañana un CSV con las peticiones a su API (`timestamp,method,path,status`) y saca tres reportes con un script de shell: peticiones por código HTTP, rutas más visitadas y la lista de errores 5xx. El script tiene historia:

- Un día el exportador cortó el CSV a mitad de una línea. El reporte salió con los números de media mañana, y nadie se dio cuenta durante una semana: `cut | sort | uniq` terminó "bien".
- Otro día, un `rm -rf $DIR/*` con `DIR` sin definir en el runner de CI borró lo que el usuario del runner podía borrar.
- Un día sin errores 5xx, `grep` no encontró nada, el script murió y no hubo reporte.

Tu tarea: sustituir el script por un Makefile que **falle de forma ruidosa** cuando los datos están mal, **no falle** cuando simplemente no hay nada que reportar, no deje nunca un reporte a medias que parezca bueno, y cuya limpieza no pueda borrar nada fuera del proyecto.

## Estructura del starter

```
starter/
├── Makefile            ← aquí trabajas (7 TODO)
└── data/
    ├── access.csv      ← 40 peticiones válidas (4 con código 5xx)
    ├── corrupt.csv     ← 12 peticiones; la línea 7 tiene 3 columnas
    └── no-5xx.csv      ← 12 peticiones, ninguna 5xx
```

Lo que genera `make report`:

```
build/
├── status.txt      ← peticiones por código HTTP
├── top-paths.txt   ← las 3 rutas más visitadas
├── errors.csv      ← las líneas con código 5xx
└── summary.txt     ← resumen de todo lo anterior
```

## Lo que debes construir

Cada paso corresponde al `TODO` con el mismo número del `starter/Makefile`. Trabaja en `3-proyecto/starter/`.

### 1. Preámbulo estricto

Las tres líneas de la [teoría](../1-teoria/02-modo-estricto.md#preámbulo-estricto), antes de cualquier otra. `make` sin argumentos sigue mostrando la ayuda:

```
Targets disponibles:
  report               Genera los reportes en build/
  package              Empaqueta los reportes en build/reportes.tar.gz
  clean                Borra build/ (con guardas)
  help                 Muestra los targets disponibles
```

### 2. `build/status.txt` que valida

La regla ya funciona con datos limpios. Añade `$(VALIDATE)` a la primera etapa. Con datos buenos:

```bash
make build/status.txt && cat build/status.txt
```
```
     26 200
      6 404
      3 500
      2 301
      2 201
      1 503
```

Con datos corruptos tiene que fallar **y no dejar el archivo**:

```bash
make -B build/status.txt LOG=data/corrupt.csv; ls build/status.txt
```
```
data/corrupt.csv:7: línea corrupta (3 columnas)
make: *** [Makefile:NN: build/status.txt] Error 1
make: *** Deleting file 'build/status.txt'
ls: cannot access 'build/status.txt': No such file or directory
```

### 3. `build/top-paths.txt`

Las 3 rutas más visitadas, con la misma validación y el formato de `uniq -c`:

```
     14 /api/users
     10 /api/orders
      7 /health
```

No uses `head`: ya sabes lo que hace con `pipefail` ([lab-03](../2-practicas/lab-03-pipefail/README.md), paso 6).

### 4. `build/errors.csv`

Las líneas del log con código `5xx`, tal cual. Con `data/access.csv` son 4. Con `data/no-5xx.csv`, un `errors.csv` vacío **y el build en verde**; con un log ilegible, el build en rojo.

### 5. `build/summary.txt` y `make report`

Formato exacto:

```
Reporte de accesos: data/access.csv
Total de peticiones: 40
Errores 5xx: 4
Rutas más visitadas:
     14 /api/users
     10 /api/orders
      7 /health
```

Los números salen del log y de los otros reportes, no se escriben a mano. Una segunda ejecución de `make report` dice `Nothing to be done for 'report'`.

### 6. `make package`

`build/reportes.tar.gz` con los cuatro reportes en la raíz del archivo:

```bash
make package && tar -tzf build/reportes.tar.gz
```
```
summary.txt
status.txt
top-paths.txt
errors.csv
```

### 7. `make clean` con guardas

Borra `build/`. Antes, dos guardas: la de variable vacía, con el mensaje exacto `BUILD_DIR vacía: rm -rf no se ejecuta`, y la de ruta fuera del proyecto, con un mensaje que contenga `fuera del proyecto` ([lab-05](../2-practicas/lab-05-guardas-rm/README.md), pasos 4 y 6). Pruébalas **siempre con `-n`**:

```bash
make -n clean BUILD_DIR=     # *** BUILD_DIR vacía: rm -rf no se ejecuta.  Stop.
make -n clean BUILD_DIR=/    # *** BUILD_DIR='/' está fuera del proyecto: rm -rf no se ejecuta.  Stop.
make -n clean                # rm -rf -- 'build'   (y build/ sigue ahí)
```

## Verificación

```bash
make
make report && cat build/summary.txt
make report                                  # Nothing to be done for 'report'.
make -B report LOG=data/no-5xx.csv           # termina bien; Errores 5xx: 0
make -B build/status.txt LOG=data/corrupt.csv; echo $?   # 2, y sin build/status.txt
make package && tar -tzf build/reportes.tar.gz
make -n clean BUILD_DIR=/
make clean
```

Y desde la raíz del repositorio:

```bash
./scripts/verificar-semana.sh 03
```

## ✅ Requisitos verificables

Los comprueba `./scripts/verificar-semana.sh 03` desde la raíz del repositorio
(60 de los 100 puntos del Producto). Los otros 40 son de calidad: ver la
[rúbrica](../rubrica-evaluacion.md#-producto-30).

- [ ] make sin argumentos muestra la ayuda
- [ ] El Makefile ejecuta las recetas con bash, no con /bin/sh
- [ ] El Makefile ejecuta las recetas con bash -eu -o pipefail
- [ ] El Makefile declara .DELETE_ON_ERROR
- [ ] make report genera build/summary.txt con el total de peticiones del log
- [ ] build/status.txt cuenta las peticiones por código HTTP
- [ ] build/errors.csv contiene exactamente las peticiones con código 5xx
- [ ] Una segunda ejecución de make report no rehace nada
- [ ] make package empaqueta los reportes sin el prefijo build/
- [ ] Un log sin peticiones 5xx no rompe el build
- [ ] Una línea corrupta en mitad de la tubería detiene el build
- [ ] Si la tubería falla, el reporte a medio escribir se borra
- [ ] make -n clean no borra nada
- [ ] make clean se niega a borrar si BUILD_DIR está vacío
- [ ] make clean se niega a borrar un BUILD_DIR fuera del proyecto
- [ ] make clean elimina build/ por completo

## Calidad (40 pts)

| Criterio | Puntos |
|---|:--:|
| Ninguna tolerancia de errores de más: sin `-` en recetas, sin `\|\| true`, sin `2>/dev/null` que oculte fallos | 10 |
| Recetas legibles: tuberías largas partidas con `\`, un comentario que explica cada excepción (`grep`, `awk 'NR <= 3'`) | 8 |
| Nada escrito a mano: rutas y comandos salen de variables (`$(BUILD_DIR)`, `$(LOG)`, `$(AWK)`) | 8 |
| `.PHONY` completo y `help` con todos los targets documentados | 6 |
| Comandos destructivos visibles: sin `@` ni `+` delante de `rm` | 4 |
| Orden: preámbulo, variables agrupadas, reportes, paquete, limpieza, ayuda | 4 |

## Entrega

Commit con el mensaje:

```
feat(week-03): proyecto - reportes de accesos a prueba de fallos
```
