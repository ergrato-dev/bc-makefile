# Rúbrica de Evaluación — Semana 06

> Dependencias automáticas y targets especiales. Se evalúan tres evidencias por
> separado, y hace falta **70% en cada una**: un build que compila desde cero
> no compensa que tocar un header deje objetos viejos.

---

## 📊 Distribución de Evidencias

| Evidencia | Peso | Instrumento |
|---|:--:|---|
| 🧠 Conocimiento | 30% | Las 10 preguntas de esta rúbrica, respondidas por escrito |
| 💪 Desempeño | 40% | Los 6 labs, con sus criterios de éxito verificados en tu máquina |
| 📦 Producto | 30% | Build C del proyecto: 60 pts de autograding + 40 pts de calidad |

**Mínimo 70% en cada evidencia.** No en el promedio.

| Calificación | Rango |
|---|:--:|
| Sobresaliente | 90-100% |
| Notable | 80-89% |
| Aprobado | 70-79% |
| No aprobado | < 70% |

---

## 🧠 Conocimiento (30%)

Diez preguntas, 3 puntos cada una. No se pide recordar flags: se pide explicar
por qué Make se comporta así.

| # | Pregunta |
|:--:|---|
| 1 | Añades `-MMD` y `-include $(DEPS)` a un proyecto que ya estaba compilado, tocas un header y `make` no recompila nada. ¿Por qué, y qué tienes que hacer una única vez? |
| 2 | ¿Qué problema resuelve `-MP`? ¿Por qué añadir `-MP` **después** de que el build se haya roto por un header borrado no lo desbloquea? |
| 3 | ¿Por qué se usa `-MMD` y no `-MD`? ¿Qué dejaría de detectar tu build con `-MMD`, y por qué se acepta? |
| 4 | Un compañero tiene `CFLAGS := -O0 -g -Iinclude` y ejecuta `make CFLAGS=-O2`. ¿Qué pasa y por qué? ¿Qué cambio en el Makefile lo evita? |
| 5 | El stamp de flags depende de `FORCE`, cuya receta se ejecuta en cada build. ¿Por qué entonces no se recompila todo cada vez? ¿Qué pasaría si la receta fuera solo `echo '...' > $@`? |
| 6 | Explica por qué `build/%.o: src/%.c build` recompila todos los objetos en cada ejecución. ¿Qué comprueba Make de un prerrequisito order-only y qué deja de comprobar? |
| 7 | En el proyecto, `version.h` es prerrequisito order-only de **todos** los objetos. ¿Por qué hace falta si `-MMD` ya registra quién lo incluye? ¿Por qué no un prerrequisito normal? |
| 8 | `version.c version.h: VERSION` funciona con `make` y ejecuta el generador dos veces con `make -j8`. ¿Por qué la diferencia? ¿Por qué `%.c %.h: %.def` no tiene ese problema? |
| 9 | ¿Qué convierte un archivo en intermedio? ¿Por qué `.SECONDARY` es preferible a `.PRECIOUS` para conservar código generado? |
| 10 | ¿Por qué `vpath %.o build` es una mala idea aunque el segundo `make` funcione? Describe qué pasa cuando hay que rehacer un objeto encontrado por `vpath`. |

<details>
<summary><strong>Respuestas</strong></summary>

**1.** gcc escribe el `.d` en la misma compilación que el `.o`. Los objetos ya
estaban al día, así que no se compiló nada y no existe ningún `.d`: `-include`
no carga nada y Make sigue sin saber de los headers. Hace falta un
`make clean && make all` (o `make -B`) una vez; a partir de ahí cada
recompilación mantiene su `.d` al día.

**2.** Sin `-MP`, el `.d` dice "`main.o` depende de `legacy.h`". Si borras el
header, Make lee esa regla antes de compilar, no encuentra cómo crear el
archivo y para con `No rule to make target`. `-MP` añade `legacy.h:` sin
prerrequisitos ni receta: Make lo da por resuelto, recompila y el `.d` nuevo
ya no lo menciona. Añadirlo tarde no ayuda porque el `.d` viejo, el que se
lee, no tiene esas reglas; solo una compilación nueva las escribe.

**3.** `-MD` incluye los headers del sistema (`stdio.h` y decenas más): `.d`
enormes, más trabajo en cada lectura y dependencias de archivos que no cambian
entre builds. Con `-MMD` una actualización del compilador o de la libc no
dispara recompilaciones; se acepta porque ese caso se resuelve con un
`make clean` puntual, y el stamp de flags puede incluir la versión del
compilador si hace falta.

**4.** Las variables de la línea de comandos sustituyen la del Makefile entera:
`CFLAGS` pasa a valer `-O2` y desaparece `-Iinclude`, así que gcc no encuentra
los headers (`fatal error: calc.h: No such file or directory`). Las flags del
preprocesador van en `CPPFLAGS`, que el usuario no tiene por qué tocar al
cambiar la optimización.

**5.** La receta compara con `cmp -s` y solo reescribe si el contenido cambió.
Make decide si rehacer un objeto comparando fechas, no mirando si se ejecutó
una receta: si el stamp no se reescribe, su fecha no avanza y los objetos
siguen al día. Con un `echo > $@` a secas la fecha avanzaría siempre y cada
build recompilaría todo.

**6.** Cada vez que se crea o se borra un archivo dentro de `build/` cambia la
fecha del directorio, y el linker borra y vuelve a crear `build/app` en cada
enlace. Los objetos quedan más viejos que
su prerrequisito `build`, se recompilan, el enlace vuelve a tocar `build/`...
un ciclo sin fin. Con `| build` Make solo comprueba que exista (y lo crea si
no); su fecha no se compara y no aparece en `$^`.

**7.** En el primer build no hay `.d`: nada le dice a Make que `main.o`
necesita `version.h`, y gcc compilaría `main.c` antes de generarlo. Order-only
garantiza que exista antes de compilar cualquier objeto. Si fuera normal, tocar
`VERSION` recompilaría los cuatro objetos; con order-only, a partir del segundo
build manda el `.d`, y solo se recompilan `main.o` y `version.o`.

**8.** Con `:` son dos reglas independientes que comparten receta. En serie,
Make genera uno, y cuando mira el otro ya está al día: funciona por el orden.
Con `-j8` lanza las dos recetas antes de que termine la primera. Las reglas de
patrón con varios targets siempre se han tratado como una sola ejecución que
produce todos; las explícitas necesitan `&:` (Make 4.3+).

**9.** Un archivo es intermedio cuando Make lo construye para una cadena de
reglas implícitas y ningún Makefile lo nombra como target o prerrequisito.
Make lo borra al terminar y su ausencia no obliga a rehacer nada. `.SECONDARY`
evita el borrado; `.PRECIOUS` además evita que `.DELETE_ON_ERROR` lo borre si
la receta falla, así que un `.c` a medio escribir se queda en disco, es más
nuevo que su fuente y Make lo da por bueno en el siguiente build.

**10.** `vpath` busca prerrequisitos que ya existen, no decide dónde se crean
los targets. La primera vez el objeto no existe y `$@`/`$^` valen `main.o`,
sin `build/`. Cuando un objeto encontrado en `build/` por `vpath` está
desactualizado, Make lo rehace en el directorio actual y olvida la ruta:
`$^` mezcla `build/main.o` con `calc.o` y el enlace falla. Los targets se
escriben con su ruta (`build/%.o: %.c`); `vpath` solo para fuentes.

</details>

---

## 💪 Desempeño (40%)

Diez puntos por lab. El Desempeño es la suma sobre 60, llevada a porcentaje.
Cada criterio de éxito se comprueba ejecutando el comando en tu máquina.

| Lab | Criterio | Puntos |
|---|---|:--:|
| [01 — Anatomía del `.d`](2-practicas/lab-01-anatomia-del-d/README.md) | Headers, flags y Makefile recompilan exactamente lo necesario; borrar un header no rompe el build | 10 |
| [02 — Order-only](2-practicas/lab-02-order-only/README.md) | Segunda pasada sin trabajo; `build/net/` se crea con `\| $$(@D)/` sin `mkdir` en recetas | 10 |
| [03 — `vpath`](2-practicas/lab-03-vpath/README.md) | Tres fuentes de tres directorios con una regla; `# FIX:` que explica la trampa de `vpath %.o` | 10 |
| [04 — Grouped targets](2-practicas/lab-04-grouped-targets/README.md) | El generador corre una vez con `-j4` en cinco ejecuciones seguidas | 10 |
| [05 — Intermedios](2-practicas/lab-05-intermedios-y-precious/README.md) | Los `.c` generados se conservan, un fallo los borra, `todos.txt` es temporal | 10 |
| [06 — Dependencias rotas](2-practicas/lab-06-dependencias-rotas/README.md) | Los cinco bugs reproducidos y corregidos, cada uno con su `# FIX X:` | 10 |

Dentro de cada lab: 10 puntos si se cumplen todos los criterios y explicas con
tus palabras qué hace cada prerrequisito o target especial que usaste; 8 si se
cumplen todos; 7 si falla uno; menos de 7 si fallan dos o más.

---

## 📦 Producto (30%)

### Verificable por el autograding — 60 puntos

Lo ejecuta `./scripts/verificar-semana.sh 06`. Es binario: pasa o no pasa.

| Comprobación | Puntos |
|---|:--:|
| `help-por-defecto` — `make` sin argumentos muestra la ayuda | 2 |
| `binario-funciona` — `make all` desde cero produce `build/app` con la versión de `VERSION` | 5 |
| `paralelo-desde-cero` — `make -j8 all` desde cero termina sin errores | 4 |
| `generador-una-vez` — con `-j8` el generador corre una sola vez | 6 |
| `segunda-pasada-sin-trabajo` — una segunda ejecución no compila, no enlaza y no regenera | 5 |
| `fuente-recompila-solo-uno` — tocar `src/util/fmt.c` recompila solo ese objeto | 3 |
| `header-recompila-exacto` — tocar `include/calc.h` recompila exactamente dos objetos | 6 |
| `version-recompila-exacto` — tocar `VERSION` recompila solo los dos objetos que usan el código generado | 5 |
| `crear-en-build-no-recompila` — crear un archivo en `build/` no recompila nada | 5 |
| `header-obsoleto-no-rompe` — dejar de incluir un header y borrarlo no rompe el build | 5 |
| `flags-recompilan` — cambiar `CFLAGS` recompila los cuatro objetos | 5 |
| `clean-borra-build` — `make clean` elimina `build/` | 2 |
| `clean-con-guarda` — `make clean` se niega a borrar si `BUILD_DIR` está vacío | 3 |
| `shellflags-estrictas` — las recetas corren con `bash -eu -o pipefail` | 2 |
| `delete-on-error` — el Makefile declara `.DELETE_ON_ERROR` | 2 |
| **Total** | **60** |

### Calidad — 40 puntos

Lo que el autograding no puede ver.

| Criterio | Excelente | Suficiente | Puntos |
|---|---|---|:--:|
| **Dependencias de headers automáticas** | Ningún header como prerrequisito escrito a mano; todo sale de `-MMD -MP` | Uno escrito a mano con comentario que lo justifica | 10 |
| **Directorios order-only** | Todos los directorios por `\| $$(@D)/`; `mkdir` solo en la regla `%/` | Algún `mkdir -p` suelto en una receta | 8 |
| **Prerrequisitos explicados** | Cada order-only, `&:`, stamp y `.PRECIOUS` lleva un comentario con el porqué | Comentarios genéricos | 8 |
| **Flags separadas** | `CPPFLAGS`, `CFLAGS` y `DEPFLAGS` independientes; ninguna flag fija en recetas | Alguna flag fija | 6 |
| **`.PHONY` y `help`** | Todos los targets que no son archivos en `.PHONY`; `help` lista todos | Falta uno | 4 |
| **Orden y secciones** | Preámbulo, variables por sección, reglas, utilidades | Variables dispersas | 4 |
| **Total** | | | **40** |

### Penalizaciones

| Situación | Deducción |
|---|:--:|
| `rm -rf` sobre una variable sin guarda de vacío | **−15 pts**. Un `BUILD_DIR` vacío por un typo no puede borrar el directorio equivocado |
| `build/`, objetos o código generado comiteados | −10 pts |
| `.PRECIOUS` sobre código generado (`.c`, `.h`) | −5 pts. Un archivo a medio escribir sobrevive a `.DELETE_ON_ERROR` |
| `make` sin argumentos compila en lugar de mostrar la ayuda | −5 pts |

---

## 📋 Checklist de entrega

- [ ] Los 6 labs con sus criterios de éxito comprobados en tu máquina
- [ ] Las 10 preguntas de Conocimiento respondidas por escrito
- [ ] `3-proyecto/starter/Makefile` sin ningún `TODO`
- [ ] `./scripts/verificar-semana.sh 06` con las 15 comprobaciones en verde
- [ ] `make clean` deja el árbol de trabajo limpio (`git status` sin `build/`)

---

[← Volver a la Semana 06](README.md)
