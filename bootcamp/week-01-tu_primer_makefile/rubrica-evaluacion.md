# Rúbrica de Evaluación — Semana 01

> Tu primer Makefile. Se evalúan tres evidencias por separado, y hace falta
> **70% en cada una**: un Makefile que funciona no compensa no saber por qué
> `make clean` dejó de hacer nada el día que apareció un archivo llamado `clean`.

---

## 📊 Distribución de Evidencias

| Evidencia | Peso | Instrumento |
|---|:--:|---|
| 🧠 Conocimiento | 30% | Las 10 preguntas de esta rúbrica, respondidas por escrito |
| 💪 Desempeño | 40% | Los 6 labs, con sus criterios de éxito verificados en tu máquina |
| 📦 Producto | 30% | Makefile del sitio estático: 60 pts de autograding + 40 pts de calidad |

**Mínimo 70% en cada evidencia.** No en el promedio.

| Calificación | Rango |
|---|:--:|
| Sobresaliente | 90-100% |
| Notable | 80-89% |
| Aprobado | 70-79% |
| No aprobado | < 70% |

---

## 🧠 Conocimiento (30%)

Diez preguntas, 3 puntos cada una. No se pide recordar sintaxis: se pide
explicar por qué Make se comporta así.

| # | Pregunta |
|:--:|---|
| 1 | Una receta indentada con cuatro espacios produce `*** missing separator.  Stop.` ¿Por qué Make no puede deducir que esa línea es una receta? |
| 2 | Existe un archivo llamado `clean` en el directorio y `make clean` responde `'clean' is up to date` sin ejecutar nada. ¿Qué razonamiento sigue Make para llegar a esa conclusión? |
| 3 | En el lab 04, `reporte.txt` **no** se declara `.PHONY`. ¿Por qué sería un error declararlo, si `.PHONY` evita el problema de la pregunta 2? |
| 4 | Antes de añadir `datos.csv` como dependencia, modificar los datos no regeneraba `reporte.txt`. ¿Por qué, si el archivo de entrada había cambiado? |
| 5 | ¿Por qué conviene que `make` sin argumentos ejecute `help` y no `build` o `deploy`? ¿Qué decide cuál es ese target? |
| 6 | El starter del proyecto imprime líneas como `# TODO: ...` al ejecutar `make check`, y aun así sale con código 0. ¿Por qué Make las imprime y por qué no fallan? |
| 7 | `deploy` depende de `check`. Si `check` falla, ¿por qué `deploy` no llega a ejecutarse, y qué pasaría si `check` solo imprimiera el error sin `exit 1`? |
| 8 | `cp -r src/ dist/` funciona la primera vez, pero la segunda deja una copia en `dist/src/`. ¿Por qué cambia el resultado, y por qué `cp -r src/. dist/` no tiene ese problema? |
| 9 | En la receta de `help` el `awk` usa `$$1` y `$$2`. ¿Por qué hace falta duplicar el `$`, y por qué se usa `$(MAKEFILE_LIST)` en lugar de escribir `Makefile`? |
| 10 | Con una dependencia circular, Make imprime `Circular b <- a dependency dropped.` y sigue con código 0. ¿Por qué eso es más peligroso que un error que detenga el build? |

<details>
<summary><strong>Respuestas</strong></summary>

**1.** Make distingue las recetas del resto del Makefile solo por el TAB inicial.
Una línea que empieza con espacios se lee como sintaxis de Makefile (una
asignación o una regla), y al no encontrar ni `=` ni `:` Make no sabe qué
separa sus partes. No adivina porque una línea indentada con espacios puede ser
legítimamente la continuación de otra construcción.

**2.** `clean` es un target sin dependencias. Make comprueba si existe un
archivo con ese nombre: existe, y como no tiene dependencias que puedan ser más
nuevas, lo da por construido. Make no sabe que tu intención era una acción;
para él todo target es un archivo salvo que lo declares `.PHONY`.

**3.** `.PHONY` le dice a Make que ignore el archivo y ejecute siempre la
receta. `reporte.txt` sí es un archivo real, y su fecha es justo lo que permite
saltarse el trabajo cuando `datos.csv` no ha cambiado. Declararlo `.PHONY`
regeneraría el reporte en cada ejecución.

**4.** Sin dependencias, Make solo pregunta si `reporte.txt` existe. Como
existe, no hay nada que hacer. Make compara fechas únicamente contra las
dependencias declaradas: si no le dices de qué depende un archivo, no puede
saber que quedó viejo.

**5.** Porque `make` sin argumentos es lo primero que escribe alguien que no
conoce el proyecto, y no debería tener efectos. Por defecto Make ejecuta el
primer target del archivo; `.DEFAULT_GOAL := help` lo fija explícitamente sin
depender del orden.

**6.** Una línea que empieza con TAB dentro de una regla es una línea de
receta, aunque empiece por `#`. Make la imprime (no lleva `@`) y se la pasa a la
shell; la shell la interpreta como comentario, no hace nada y devuelve 0.

**7.** Make construye primero las dependencias. Si la receta de `check` sale
con un código distinto de 0, Make se detiene y no ejecuta ninguna regla que
dependa de ella. Make solo mira el código de salida: si `check` imprime
`Error: ...` pero termina en 0, Make lo considera un éxito y el deploy sigue
adelante con archivos que faltan.

**8.** Si el destino no existe, `cp -r src/ dist/` crea `dist` como copia de
`src`. Si ya existe como directorio, copia `src` *dentro* de él, y aparece
`dist/src/`. `src/.` significa "el contenido de `src`": se copia dentro de
`dist/` igual la primera vez que la décima, siempre que `dist/` exista
(`mkdir -p` antes).

**9.** Make expande `$` antes de pasar la receta a la shell: `$1` sería la
variable de Make `1`, vacía. `$$` se convierte en un `$` literal que llega a
`awk`. `$(MAKEFILE_LIST)` contiene los Makefiles que Make leyó realmente, así
que `help` sigue funcionando con `make -f otro.mk` o si el archivo se llama
`GNUmakefile`.

**10.** Make rompe el ciclo descartando una de las dependencias y continúa,
así que el build termina en verde con un orden de ejecución que nadie eligió.
El mensaje es un aviso que se pierde entre el resto de la salida; un error con
código distinto de 0 lo verías al momento.

</details>

---

## 💪 Desempeño (40%)

Diez puntos por lab. El Desempeño es la suma sobre 60, llevada a porcentaje.
Cada criterio de éxito se comprueba ejecutando el comando en tu máquina.

| Lab | Criterio | Puntos |
|---|---|:--:|
| [01 — Primer target](2-practicas/lab-01-primer-target/README.md) | GNU Make ≥ 4.3 comprobado; `saludar` e `info` imprimen lo pedido; `check-make` falla con `MAKE_VERSION=3.81`; `donde` demuestra una shell por línea | 10 |
| [02 — Dependencias](2-practicas/lab-02-dependencias/README.md) | `make run` ejecuta los 4 pasos en orden; `make compile` solo ejecuta `prepare` y `compile`; `make check` compila una sola vez | 10 |
| [03 — `.PHONY`](2-practicas/lab-03-phony-targets/README.md) | Con un archivo `clean` presente, `make clean` ejecuta la receta gracias a `.PHONY`; `build` crea `output/app.txt`; explicas qué hace `make` sin `.DEFAULT_GOAL` | 10 |
| [04 — Targets y archivos](2-practicas/lab-04-targets-y-archivos/README.md) | La segunda ejecución de `make reporte.txt` dice `is up to date`; tras `touch datos.csv` lo regenera; en la cadena `resumen.txt` solo se rehace el eslabón necesario | 10 |
| [05 — Makefile roto](2-practicas/lab-05-makefile-roto/README.md) | Los 4 errores corregidos; `make all` sin errores ni avisos; `make validate-output` termina en `Salida validada.`; usas `cat -A` y `make -n` | 10 |
| [06 — Patrón `help`](2-practicas/lab-06-patron-help/README.md) | `make` sin argumentos muestra la ayuda en dos columnas; un target nuevo con `##` aparece sin tocar `help`; `make -f otro.mk help` demuestra `$(MAKEFILE_LIST)` | 10 |

Dentro de cada lab: 10 puntos si se cumplen todos los criterios y explicas con
tus palabras por qué funciona; 8 si se cumplen todos; 7 si falla uno; menos de
7 si fallan dos o más.

---

## 📦 Producto (30%)

### Verificable por el autograding — 60 puntos

Lo ejecuta `./scripts/verificar-semana.sh 01`. Es binario: pasa o no pasa.

| Comprobación | Puntos |
|---|:--:|
| `help-por-defecto` — `make` sin argumentos lista los siete targets con su descripción | 5 |
| `build-copia-src` — `make build` copia los HTML y el CSS a `dist/` | 7 |
| `build-repetible` — ejecutar `make build` dos veces no anida `src/` dentro de `dist/` | 5 |
| `sitemap-en-build` — `make build` genera `dist/sitemap.txt` con una línea por página HTML | 6 |
| `sitemap-al-dia` — sin cambios en `src/`, `make dist/sitemap.txt` no lo regenera | 6 |
| `sitemap-se-regenera` — tocar `src/about.html` regenera `dist/sitemap.txt` | 6 |
| `check-ok` — tras `make build`, `make check` termina con `Check OK.` | 5 |
| `check-falla-sin-dist` — `make check` sale con error si `dist/` no existe | 6 |
| `deploy-lista-archivos` — `make deploy` lista los archivos de `dist/` | 4 |
| `clean-borra-dist` — `make clean` elimina `dist/` por completo | 4 |
| `clean-es-phony` — `make clean` se ejecuta aunque exista un archivo llamado `clean` | 6 |
| **Total** | **60** |

### Calidad — 40 puntos

Lo que el autograding no puede ver.

| Criterio | Excelente | Suficiente | Puntos |
|---|---|---|:--:|
| **`.PHONY` completo** | Los siete targets declarados en una sola línea al inicio, y `dist/sitemap.txt` fuera de `.PHONY` | Falta uno | 8 |
| **Variables en las recetas** | Ninguna receta escribe `src`, `dist` ni `8080`: todo sale de `SRC_DIR`, `DIST_DIR`, `PORT` | Un literal en un mensaje `@echo` | 8 |
| **Errores útiles en `check`** | Cada archivo que falta tiene su mensaje y dice qué ejecutar para arreglarlo | Mensaje genérico | 6 |
| **`serve` funcional** | Depende de `build`, imprime la URL antes de arrancar y sirve `dist/` | Arranca pero no imprime la URL | 6 |
| **Default seguro** | `.DEFAULT_GOAL := help` explícito | `help` es el primer target, sin `.DEFAULT_GOAL` | 6 |
| **Estilo** | Recetas con TAB, variables en `UPPER_SNAKE_CASE`, targets en `lower-kebab-case`, `@` en los `echo` | Alguna receta imprime el comando y el mensaje duplicados | 6 |
| **Total** | | | **40** |

### Penalizaciones

| Situación | Deducción |
|---|:--:|
| `dist/` comiteado | −10 pts |
| Archivos de `src/` modificados | −10 pts. El proyecto trabaja sobre el sitio, no lo cambia |
| `make` sin argumentos construye o despliega en lugar de mostrar la ayuda | −5 pts |

---

## 📋 Checklist de entrega

- [ ] Los 6 labs con sus criterios de éxito comprobados en tu máquina
- [ ] Las 10 preguntas de Conocimiento respondidas por escrito
- [ ] `3-proyecto/starter/Makefile` sin ningún `TODO`
- [ ] `./scripts/verificar-semana.sh 01` con las 11 comprobaciones en verde
- [ ] `make clean` deja el árbol de trabajo limpio (`git status` sin `dist/`)

---

[← Volver a la Semana 01](README.md)
