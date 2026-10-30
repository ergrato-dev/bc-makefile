# Rúbrica de Evaluación — Semana 13

> Seguridad, portabilidad y alternativas. Se evalúan tres evidencias por
> separado, y hace falta **70% en cada una**: un Makefile que pasa el
> autograding no compensa no saber por qué `make -n` no es inofensivo.

---

## 📊 Distribución de Evidencias

| Evidencia | Peso | Instrumento |
|---|:--:|---|
| 🧠 Conocimiento | 30% | Las 10 preguntas de esta rúbrica, respondidas por escrito |
| 💪 Desempeño | 40% | Los 6 labs, con sus criterios de éxito verificados en tu máquina |
| 📦 Producto | 30% | Makefile de `notify` auditado y endurecido: 60 pts de autograding + 40 pts de calidad |

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
explicar por qué las cosas se comportan así.

| # | Pregunta |
|:--:|---|
| 1 | ¿Por qué `VERSION := $(shell curl -s https://api.example.com/latest)` hace que `make help` dependa de la red, y por qué cambiar `:=` por `=` no basta si `VERSION` se usa en una receta y alguien ejecuta `make -n`? |
| 2 | Pones `@` delante de una línea que contiene `$(TOKEN)` y rediriges su salida a `/dev/null`. ¿Por qué el token sigue siendo visible para otros usuarios de la máquina? |
| 3 | ¿Por qué `include .env` es más peligroso que `source .env` en un script, y por qué una lista blanca de claves es mejor que buscar `$(shell` en el archivo? |
| 4 | Una receta usa `"$(BRANCH)"`, con comillas dobles. ¿Por qué no basta para una rama llamada `` feat`id` ``, y por qué `"$$BRANCH"` sí? |
| 5 | `make notes 'NOTE=$(shell touch x)'` crea `x` aunque la receta use comillas simples. ¿Quién ejecuta el código, y qué hace `override NOTE := $(value NOTE)` para impedirlo? |
| 6 | Quitas el `export` a secas del Makefile, pero `API_TOKEN=x make lint` sigue entregando el token al linter. ¿Por qué, y qué cambia `unexport`? |
| 7 | ¿Por qué `umask 077` tiene que ir en la misma línea de receta que crea el archivo de credenciales? |
| 8 | ¿Qué te garantiza verificar un SHA-256 fijado en el Makefile antes de ejecutar un instalador, y qué no te garantiza? |
| 9 | `make all` funciona, pero `make clean && make build/report.txt` falla. ¿Qué tipo de bug revela, por qué `all` lo tapaba y qué herramienta de Make 4.4 lo encuentra sin construir targets uno a uno? |
| 10 | Tu Makefile usa `.SHELLFLAGS := -eu -o pipefail -c`. ¿Qué pasa al ejecutarlo con el make 3.81 de macOS, por qué no hay ningún error, y por qué la guarda de versión se escribe con sintaxis que 3.81 entiende? |

<details>
<summary><strong>Respuestas</strong></summary>

**1.** Un `:=` se expande al leer el Makefile, antes de saber qué target se
pidió: `make help` lanza `curl` y, sin red, tarda o falla. Con `=` la expansión
se aplaza hasta que alguien use `$(VERSION)`; pero `make -n` expande las
recetas para imprimirlas, así que el `$(shell)` corre igualmente. La consulta
tiene que ser shell dentro de la receta (`v=$$(curl ...)`), que `-n` imprime
sin ejecutar.

**2.** Make ejecuta cada línea como `bash -c '<línea expandida>'`. El `@` solo
evita que Make la imprima; el texto con el token es el argv de ese proceso
bash, y la tabla de procesos (`ps`) es legible por todos los usuarios. La
redirección afecta a la salida del comando, no a sus argumentos. Si la receta
usa `"$$TOKEN"`, el argv solo contiene el nombre de la variable.

**3.** `source` interpreta el archivo con el shell; `include` lo interpreta Make
**al parsear**, con todo su lenguaje: `$(shell ...)` se ejecuta en `make help`,
y una línea `SHELL=...` cambia el intérprete de todas las recetas sin usar `$`.
Una lista negra siempre olvida algo (`SHELL`, `MAKEFLAGS`, `.SHELLFLAGS`,
reglas con recetas); una lista blanca de claves conocidas con valores de
caracteres seguros rechaza todo lo que no esperabas.

**4.** Dentro de comillas dobles bash sigue interpretando `` ` `` y `$( )`, así
que el texto de la rama se ejecuta como sustitución de comando. Con
`"$$BRANCH"`, Make escribe `"$BRANCH"` en la receta: bash expande una
variable, y el resultado de expandir una variable entre comillas dobles nunca
se vuelve a interpretar como código.

**5.** Lo ejecuta Make, no bash: las variables de la línea de comandos son
recursivas, y al expandir `$(NOTE)` en la receta Make evalúa el `$(shell)`
antes de que exista ningún shell. `$(value NOTE)` devuelve el texto sin
expandir y `override ... :=` lo congela en una variable simple: a partir de
ahí `$(NOTE)` es texto literal.

**6.** Make exporta siempre a las recetas las variables que vinieron del
entorno o de la línea de comandos, con o sin `export`. `unexport API_TOKEN` la
quita del entorno de todas las recetas; después, `target: export API_TOKEN :=
$(API_TOKEN)` se la devuelve solo a quien la necesita.

**7.** Cada línea de receta es un shell distinto. Un `umask 077` en una línea
cambia la máscara de ese shell, que termina al acabar la línea; el `printf` de
la línea siguiente corre en un shell nuevo con el `umask` heredado de Make
(normalmente `022`), y el archivo nace `644`.

**8.** Garantiza que ejecutas exactamente el archivo que revisaste o en el que
decidiste confiar cuando fijaste el hash: si el servidor, el CDN o la cuenta
del proyecto cambian el instalador, el build falla. No garantiza que ese
archivo fuera seguro: solo convierte "lo que sirva la URL hoy" en "lo que
alguien aprobó".

**9.** Un prerrequisito no declarado: la receta lee un archivo que no está en
su lista de dependencias. `all` lo tapaba porque construye sus prerrequisitos
de izquierda a derecha y el archivo necesario estaba antes. `make --shuffle`
(o `--shuffle=reverse`) cambia ese orden y el bug aparece; en 4.3, construir
cada target aislado desde cero lo detecta igual.

**10.** `.SHELLFLAGS` apareció en 3.82. Para 3.81 es una variable cualquiera
que nadie lee: las recetas corren con `bash -c` sin `-e` ni `pipefail`, y
`fallo | tee log` da éxito. No hay error porque la sintaxis es válida. La
guarda usa solo `ifneq`, `$(sort)`, `$(firstword)` y `$(error)`, que existen
en 3.81, para que ese make pueda leerla y parar con un mensaje claro en vez de
ejecutar mal.

</details>

---

## 💪 Desempeño (40%)

Diez puntos por lab. El Desempeño es la suma sobre 60, llevada a porcentaje.
Cada criterio de éxito se comprueba ejecutando el comando en tu máquina.

| Lab | Criterio | Puntos |
|---|---|:--:|
| [01 — Parse-time vs run-time](2-practicas/lab-01-parse-time-vs-run-time/README.md) | `make help` instantáneo y sin efectos; `make -n publish` no crea nada; `.env` malicioso rechazado por número de línea | 10 |
| [02 — Inyección (roto)](2-practicas/lab-02-inyeccion-rota/README.md) | Los cinco payloads sin efecto; texto libre guardado literal; `clean` rechaza vacía, absoluta y `..`; un `# FIX:` por bug | 10 |
| [03 — Secretos y descargas](2-practicas/lab-03-secretos-y-descargas/README.md) | `lint` no ve el token; `spy` y `make -n` no muestran el valor; `auth.conf` en `600`; log enmascarado; instalador alterado rechazado | 10 |
| [04 — Testing de Makefiles](2-practicas/lab-04-testing-de-makefiles/README.md) | `make check` con 4 pruebas en verde; vuelve a fallar si se reintroduce cualquiera de los dos bugs | 10 |
| [05 — Portabilidad](2-practicas/lab-05-portabilidad/README.md) | Guarda de versión y de features; cinco comandos portables; `Makefile.posix` sin extensiones GNU y `portability-check` funcionando | 10 |
| [06 — Alternativas](2-practicas/lab-06-alternativas-a-make/README.md) | `make verify` en verde; las seis decisiones justificadas con un criterio concreto | 10 |

Dentro de cada lab: 10 puntos si se cumplen todos los criterios y explicas con
tus palabras el porqué de cada corrección; 8 si se cumplen todos; 7 si falla
uno; menos de 7 si fallan dos o más.

---

## 📦 Producto (30%)

### Verificable por el autograding — 60 puntos

Lo ejecuta `./scripts/verificar-semana.sh 13`. Es binario: pasa o no pasa.

| Comprobación | Puntos |
|---|:--:|
| `version-minima` — se niega a correr con una Make anterior a `MIN_MAKE_VERSION` | 3 |
| `shellflags-estrictas` — recetas con `bash -eu -o pipefail` | 3 |
| `sin-efectos-al-parsear` — `make help` y `make -n` no crean nada en disco | 4 |
| `env-validado` — un `ENV_FILE` con código Make no se ejecuta; uno válido se acepta | 4 |
| `sin-export-global` — las recetas no reciben variables no exportadas | 3 |
| `version-sin-inyeccion` — una VERSION con código se rechaza sin ejecutar nada | 4 |
| `branch-como-dato` — una BRANCH con código se guarda como texto | 4 |
| `secreto-fuera-de-dry-run` — `make -n deploy` muestra `$DEPLOY_TOKEN`, no el valor | 4 |
| `credenciales-600` — `build/curl-auth.conf` legible solo por su dueño | 3 |
| `clean-guarda-vacia` — `make clean` se niega con `BUILD_DIR` vacío | 3 |
| `clean-rutas-peligrosas` — `make clean` se niega con rutas absolutas o con `..` | 3 |
| `instalador-verificado` — el instalador solo se ejecuta si su SHA-256 coincide | 4 |
| `sin-avisos-undefined` — `--warn-undefined-variables` no avisa de nada | 3 |
| `paquete-make-q` — el paquete es un target de archivo que `make -q` sabe evaluar | 3 |
| `autoprueba-check` — `make check` termina sin errores | 4 |
| `auditoria-sin-todo` — `AUDITORIA.md` existe y no tiene `TODO` | 4 |
| `auditoria-hallazgos` — `AUDITORIA.md` documenta al menos 8 hallazgos | 4 |
| **Total** | **60** |

### Calidad — 40 puntos

Lo que el autograding no puede ver.

| Criterio | Excelente | Suficiente | Puntos |
|---|---|---|:--:|
| **Trazabilidad** | Cada hallazgo tiene prueba reproducible con payload inofensivo y un `# Hn` en el Makefile | Pruebas descritas, no reproducibles | 12 |
| **Defensa adecuada** | Lista blanca para lo que tiene formato, entorno para el texto libre, `$(value)` donde Make podría expandir | Una sola técnica para todo | 8 |
| **Mínimo privilegio** | `unexport` + `export` específico de target; credenciales borradas tras el deploy | `export` selectivo global | 6 |
| **`check` que falla de verdad** | Probado reintroduciendo al menos dos hallazgos, documentado en `AUDITORIA.md` | Solo probado en verde | 6 |
| **Estructura** | `.PHONY` completo, `help` útil, secciones y variables agrupadas | Falta algún target en `.PHONY` | 4 |
| **Portabilidad** | Sin `stat -c`, `sed -i`, `sha256sum` a secas ni `date --iso-8601` | Uno de ellos | 4 |
| **Total** | | | **40** |

### Penalizaciones

| Situación | Deducción |
|---|:--:|
| Un payload de prueba en `AUDITORIA.md` o en `check` que no sea inofensivo (`rm`, red, escritura fuera de una carpeta temporal o de `build/`) | **−20 pts** |
| `rm -rf` sobre una variable sin guarda | **−15 pts** |
| Un secreto real comiteado (`.env`, token en el Makefile o en `AUDITORIA.md`) | −15 pts |
| `curl \| sh` o equivalente en cualquier target | −10 pts |
| `make` sin argumentos ejecuta algo en lugar de mostrar la ayuda | −5 pts |

---

## 📋 Checklist de entrega

- [ ] Los 6 labs con sus criterios de éxito comprobados en tu máquina
- [ ] Las 10 preguntas de Conocimiento respondidas por escrito
- [ ] `3-proyecto/starter/Makefile` y `AUDITORIA.md` sin ningún `TODO`
- [ ] `./scripts/verificar-semana.sh 13` con las 17 comprobaciones en verde
- [ ] `make clean` deja el árbol limpio (`git status` sin `build/` ni `.env`)

---

[← Volver a la Semana 13](README.md)
