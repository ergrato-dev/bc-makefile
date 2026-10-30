# Rúbrica de Evaluación — Semana 10

> Paralelismo y recursión. Se evalúan tres evidencias por separado, y hace falta
> **70% en cada una**: un build que pasa con `-j8` una vez no compensa no saber
> por qué falló la anterior.

---

## 📊 Distribución de Evidencias

| Evidencia | Peso | Instrumento |
|---|:--:|---|
| 🧠 Conocimiento | 30% | Las 10 preguntas de esta rúbrica, respondidas por escrito |
| 💪 Desempeño | 40% | Los 6 labs, con sus criterios de éxito verificados en tu máquina |
| 📦 Producto | 30% | Monorepo del proyecto: 60 pts de autograding + 40 pts de calidad |

**Mínimo 70% en cada evidencia.** No en el promedio.

| Calificación | Rango |
|---|:--:|
| Sobresaliente | 90-100% |
| Notable | 80-89% |
| Aprobado | 70-79% |
| No aprobado | < 70% |

---

## 🧠 Conocimiento (30%)

Diez preguntas, 3 puntos cada una. No se pide recordar opciones: se pide
explicar por qué Make se comporta así.

| # | Pregunta |
|:--:|---|
| 1 | Un Makefile funciona siempre con `make` y falla a veces con `make -j8`. ¿Por qué no es un bug de `-j`, y por qué `.NOTPARALLEL:` no es el arreglo? |
| 2 | ¿Por qué contar cuántas recetas se solapan (marcas `start`/`end`) es una medida de paralelismo más fiable en CI que comparar tiempos con `time`? |
| 3 | `rebuild: clean all` funciona en serie y falla con `-j`. ¿Por qué? Da el arreglo para Make 4.3 y el de Make 4.4+. |
| 4 | Con Make 4.3, `make -j4` sobre un sub-make lanzado con `make` literal tarda cuatro veces más que con `$(MAKE)`. ¿Por qué? En 4.4 tarda lo mismo: ¿por qué sigue estando mal? |
| 5 | ¿Por qué `make -n` ejecuta de verdad las líneas que contienen `$(MAKE)`? ¿Qué verías sin esa excepción? |
| 6 | `for d in $(MODULES); do $(MAKE) -C $$d test; done` dejó el CI en verde con un módulo roto. ¿Por qué? ¿Por qué ejecutar la receta con `bash -e` no lo arregla del todo? |
| 7 | En el raíz escribes `STAGE := prod` y el sub-make ve `STAGE` vacía; con `make all STAGE=prod` sí la ve. ¿Por qué la diferencia, y por qué no basta con un `export` a secas? |
| 8 | Escribes `$(MAKE) -j4 -C lib` en dos recetas y lanzas `make -j4`. ¿Cuántas tareas pueden correr a la vez y por qué Make avisa con `-j4 forced in submake`? |
| 9 | Con `-O`, `grep --color=auto` deja de colorear. ¿Por qué? ¿Qué diferencia hay entre `-Otarget` y `-Orecurse` con un sub-make que tiene varios targets? |
| 10 | ¿Qué problema de fondo resuelve el Make no recursivo frente a la recursión bien hecha, qué cuesta, y por qué importa el orden de los `include` de cada `module.mk`? |

<details>
<summary><strong>Respuestas</strong></summary>

**1.** En serie, Make construye los prerrequisitos en el orden de la lista, y
ese orden tapa una dependencia que nunca se declaró: una receta lee un archivo
que no figura en sus prerrequisitos, o dos recetas escriben el mismo temporal.
Con `-j` solo se respeta el grafo, así que lo no declarado puede ir a la vez.
`.NOTPARALLEL:` vuelve a la serie y esconde el bug; el arreglo es declarar la
arista que falta (o usar un temporal por target, `$@.tmp`).

**2.** El tiempo depende de la carga de la máquina: en un runner compartido, un
build paralelo puede tardar más que uno en serie en tu portátil. El número de
recetas en marcha a la vez solo depende del grafo y de `-j`: si cada receta
tarda un segundo, con `-j4` se solapan cuatro, esté la máquina cargada o no.

**3.** `all` no depende de `clean`, así que con `-j` arrancan a la vez y `all`
da por buenos archivos que `clean` está borrando. En 4.3: una receta con dos
sub-makes en secuencia (`$(MAKE) clean` y luego `$(MAKE) all`). En 4.4+:
`rebuild: clean .WAIT all`, que no empieza nada a la derecha de `.WAIT` hasta
terminar lo de la izquierda.

**4.** Make solo da acceso al jobserver a las líneas que reconoce como
recursivas (`$(MAKE)` literal o prefijo `+`). En 4.3 el jobserver son dos
descriptores de tubería que Make cierra para los demás comandos: el hijo recibe
`-j4` pero no las fichas, avisa `jobserver unavailable: using -j1` y va en serie.
En 4.4 el jobserver es una FIFO con nombre y el hijo puede abrirla igualmente,
pero `make` literal sigue sin ejecutarse con `-n`, y puede ser otro binario
(`make` 3.81 en macOS cuando lanzaste `gmake`).

**5.** Para que el simulacro sea completo: el sub-make recibe `-n` en
`MAKEFLAGS` y muestra sus propias recetas sin ejecutarlas. Sin esa excepción,
`make -n` solo imprimiría `make -C lib` y no sabrías qué va a hacer `lib`.

**6.** Sin `-e`, el código de salida de un `for` es el del último comando: si
falla `api` y pasa `frontend`, el bucle sale con 0. Con `-e` la receta se para
en el primer fallo, pero sigue siendo una sola receta: `-j` no puede repartir
los módulos, `-k` no puede continuar con los demás y no hay forma de declarar
que un módulo depende de otro. Cada módulo tiene que ser un target.

**7.** Las variables de la línea de comandos viajan en `MAKEFLAGS` a todos los
sub-makes, y además tienen prioridad sobre lo que el hijo asigne. Las definidas
en el Makefile solo pasan si se exportan: `export STAGE`. `export` a secas
exporta todas las variables del Makefile al entorno de todas las recetas,
incluidas las que no deberían salir de él (rutas internas, credenciales).

**8.** Hasta 8. Un `-j` explícito hace que cada hijo descarte el jobserver del
padre y cree el suyo con 4 fichas; el aviso es justo eso, `resetting jobserver
mode`. El `-j` se pasa una vez, en la línea de comandos, y los sub-makes lo
heredan.

**9.** Con `-O`, Make redirige la salida de cada receta a un archivo temporal
para imprimirla en bloque; la herramienta comprueba si su stdout es una
terminal, ve que no y apaga los colores. Con `-Otarget`, el sub-make agrupa cada
uno de sus targets por separado, y entre sus bloques pueden aparecer los de
otros targets del padre; con `-Orecurse`, toda la salida del sub-make sale en un
único bloque cuando termina.

**10.** Cada sub-make ve solo su directorio: `app/` no sabe reconstruir
`../lib/libx.a` ni ve que un header de `lib/` cambió, así que puede enlazar con
una versión vieja. Con un solo grafo (un `module.mk` por directorio incluido en
el raíz), todas las aristas existen. Cuesta rutas relativas a la raíz, nombres
de variable sin colisiones y perder `make -C dir` independiente. El orden
importa porque los prerrequisitos se expanden al leer la regla: si `app` usa
`$(LIB)` y `lib/module.mk` se incluye después, `LIB` está vacía en ese momento.

</details>

---

## 💪 Desempeño (40%)

Diez puntos por lab. El Desempeño es la suma sobre 60, llevada a porcentaje.
Cada criterio de éxito se comprueba ejecutando el comando en tu máquina.

| Lab | Criterio | Puntos |
|---|---|:--:|
| [01 — `-j`](2-practicas/lab-01-jobs-paralelos/README.md) | `make concurrency` da 1 en serie, 4 con `-j4` y 1 con `-j4 SERIAL=1` | 10 |
| [02 — Carreras (roto)](2-practicas/lab-02-carrera-roto/README.md) | Los cuatro bugs corregidos con `# FIX:`; diez `make -j8 rebuild && make check` seguidos en verde | 10 |
| [03 — `-O`](2-practicas/lab-03-output-sync/README.md) | `make -j4 test` agrupado sin `-O`; `OUTPUT_SYNC=none` y `recurse` se comportan como describe el lab | 10 |
| [04 — Recursión](2-practicas/lab-04-recursion/README.md) | Los fallos se propagan, `-j3 -k` sigue con los demás, `STAGE` llega exportada y por línea de comandos | 10 |
| [05 — Jobserver](2-practicas/lab-05-jobserver/README.md) | `recursive` y `hidden` comparten jobserver y entran con `-n`; `twice` da máximo 4 | 10 |
| [06 — No recursivo](2-practicas/lab-06-no-recursivo/README.md) | Un solo grafo: tocar `lib/greet.h` recompila los dos `.c`; comentario sobre el orden de `MODULES` | 10 |

Dentro de cada lab: 10 puntos si se cumplen todos los criterios y explicas con
tus palabras por qué funciona cada arreglo; 8 si se cumplen todos; 7 si falla
uno; menos de 7 si fallan dos o más.

---

## 📦 Producto (30%)

### Verificable por el autograding — 60 puntos

Lo ejecuta `./scripts/verificar-semana.sh 10`. Es binario: pasa o no pasa.

| Comprobación | Puntos |
|---|:--:|
| `build-completo` — `make all` desde cero construye `app` con el trabajo de `core` y `util` | 5 |
| `paquete-como-target` — `make packages/util/build` construye `util` y nada más | 3 |
| `dependencias-con-j` — con `make -j8 all` desde cero, `app` se construye después de `core` y `util` | 6 |
| `paralelo-real` — con `make -j4 all`, al menos dos paquetes se construyen a la vez | 5 |
| `fallo-propaga` — si un paquete falla, `make all` sale con error aunque el último pase | 6 |
| `keep-going` — con `make -k all FAIL=core`, `util` y `docs` se construyen y `app` no | 4 |
| `sin-for` — el Makefile raíz no recorre los paquetes con un bucle `for` | 3 |
| `sin-make-literal` — los sub-makes se invocan con `$(MAKE)` | 3 |
| `dry-run-recursivo` — `make -n all` llega hasta las recetas de los paquetes sin construir nada | 4 |
| `salida-agrupada` — con `make -j4 all` la salida sale agrupada sin pasar `-O` | 4 |
| `rebuild-con-j` — `make -j8 rebuild` rehace los cuatro paquetes y deja `app` construida | 5 |
| `clean-limpia` — `make clean` borra el `dist/` de todos los paquetes | 3 |
| `clean-con-guarda` — `make clean DIST_DIR=` se niega a borrar | 4 |
| `shellflags-estrictas` — las recetas corren con `bash -eu -o pipefail` | 3 |
| `delete-on-error` — el Makefile raíz declara `.DELETE_ON_ERROR` | 2 |
| **Total** | **60** |

### Calidad — 40 puntos

Lo que el autograding no puede ver.

| Criterio | Excelente | Suficiente | Puntos |
|---|---|---|:--:|
| **Grafo explícito** | Las dependencias entre paquetes están declaradas como prerrequisitos, con un comentario que dice qué consume quién; nada depende del orden de `PACKAGES` | Declaradas sin explicar | 10 |
| **Una regla de recursión** | Una sola regla con `$(MAKE) -C $(@D) $(@F)` sirve para todos los paquetes y metas; añadir un paquete es tocar `PACKAGES` | Alguna regla copiada por paquete | 8 |
| **Variables a sub-makes** | Solo se exporta lo necesario y por nombre; `OUTPUT_SYNC` se puede cambiar desde la línea de comandos | Exporta de más | 6 |
| **`.PHONY` completo** | Todos los targets de paquete y los generales declarados | Falta alguno | 6 |
| **Orden y secciones** | Preámbulo, paralelismo, paquetes, grafo, recursión y utilidades separados con comentario | Secciones mezcladas | 6 |
| **`help` útil** | `make` sin argumentos lista los targets y explica cómo pedir un paquete concreto | Lista incompleta | 4 |
| **Total** | | | **40** |

### Penalizaciones

| Situación | Deducción |
|---|:--:|
| `.NOTPARALLEL` o `-j1` para que pasen las comprobaciones | **−15 pts**. Esconde la carrera en lugar de arreglarla |
| `-j` escrito dentro de una receta | −10 pts. Cada sub-make crea su propio jobserver |
| `export` sin argumentos | −10 pts |
| `dist/` o archivos de traza comiteados | −10 pts |
| `make` sin argumentos construye en lugar de mostrar la ayuda | −5 pts |

---

## 📋 Checklist de entrega

- [ ] Los 6 labs con sus criterios de éxito comprobados en tu máquina
- [ ] Las 10 preguntas de Conocimiento respondidas por escrito
- [ ] `3-proyecto/starter/Makefile` sin ningún `TODO` y sin `legacy-all`
- [ ] `./scripts/verificar-semana.sh 10` con las 15 comprobaciones en verde
- [ ] `make clean` deja el árbol de trabajo limpio (`git status` sin `dist/`)

---

[← Volver a la Semana 10](README.md)
