# Autograding

`scripts/verificar-semana.sh` te dice qué te falta antes de entregar. No sabe
nada de ninguna semana en concreto: lee `bootcamp/week-NN-*/checks.json` y
ejecuta lo que ahí ponga.

---

## Uso

```bash
./scripts/verificar-semana.sh --doctor   # comprueba tu entorno
./scripts/verificar-semana.sh 03         # comprueba la Semana 03
```

Salida:

```
Semana 03 — Shell y modo estricto

  ✅ El Makefile del proyecto declara .DELETE_ON_ERROR
  ✅ Un fallo dentro de una tubería detiene el build
  ❌ make clean se niega a borrar si BUILD_DIR está vacío
     pista: 2-practicas/lab-05-guardas-rm/README.md, paso 4

  8/9 comprobaciones superadas.
```

Sale con 0 si pasan todas, con 1 si falla alguna. **Cada pista dice en qué lab
y en qué paso se arregla**: si una pista no lleva ahí, es un fallo del material
y merece un issue.

En macOS el script usa `gmake` si está instalado. Para forzar otro binario:
`MAKE_BIN=/ruta/a/make ./scripts/verificar-semana.sh 03`.

---

## Formato de `checks.json`

Un archivo por semana, en la raíz de la carpeta de la semana.

```json
{
  "semana": "03",
  "titulo": "Shell y modo estricto",
  "checks": [
    {
      "id": "delete-on-error",
      "descripcion": "El Makefile del proyecto declara .DELETE_ON_ERROR",
      "cmd": "{make} -C {semana}/3-proyecto/starter -p __nada__ 2>/dev/null | grep -q '^.DELETE_ON_ERROR:'",
      "assert": "exit0",
      "pista": "1-teoria/02-modo-estricto.md"
    },
    {
      "id": "pipefail",
      "descripcion": "Un fallo dentro de una tubería detiene el build",
      "cmd": "{make} -C {semana}/3-proyecto/starter tuberia-rota",
      "assert": "exit!=0",
      "pista": "2-practicas/lab-03-pipefail/README.md, paso 2"
    }
  ]
}
```

### Campos

| Campo | Obligatorio | Qué es |
|---|:--:|---|
| `id` | sí | Identificador estable en kebab-case. **Nunca se renombra** |
| `descripcion` | sí | Qué se comprueba, en una línea. **Se copia literal** a `3-proyecto/README.md` |
| `cmd` | sí | Comando bash que se ejecuta desde la raíz del repositorio |
| `assert` | sí | Qué tiene que cumplirse. Ver la tabla siguiente |
| `pista` | sí | Archivo y paso donde se arregla |

### Aserciones

| `assert` | Se cumple si |
|---|---|
| `exit0` | el comando sale con código 0 |
| `exit!=0` | el comando sale distinto de 0 |
| `exit=N` | el comando sale exactamente con el código `N` |
| `stdout~RE` | la salida (stdout + stderr) casa con la expresión regular extendida `RE` |
| `stdout!~RE` | la salida **no** casa con `RE` |

La salida incluye stderr a propósito: los errores de Make (`*** missing
separator`, `No rule to make target`) salen por ahí.

> [!IMPORTANT]
> **Las expresiones regulares no pueden llevar `\`.** El verificador lee los
> campos con `jq @tsv`, que escapa la barra invertida. Usa `.` para un carácter
> cualquiera y clases como `[*]` en lugar de `\*`.

### Marcadores

| Marcador | Se sustituye por |
|---|---|
| `{raiz}` | Ruta absoluta del repositorio |
| `{semana}` | Ruta de la carpeta de la semana, p. ej. `bootcamp/week-03-shell_y_modo_estricto` |
| `{make}` | `gmake` si existe, si no `make` (o `$MAKE_BIN`) |

Usa siempre `{make}`, nunca `make` a secas: en macOS `make` es la 3.81.

---

## Reglas de diseño

1. **El `checks.json` se escribe antes que el contenido.** Define qué es
   entregable y, por tanto, qué tienen que enseñar los labs.
2. **Entre 6 y 18 comprobaciones**, creciendo con la complejidad de la semana.
3. **Una comprobación, un hecho.** Si la descripción necesita una "y", son dos.
4. **`descripcion` se copia palabra por palabra** a
   `3-proyecto/README.md § ✅ Requisitos verificables`.
5. **Cero lógica de la semana en `verificar-semana.sh`.** Si una comprobación
   necesita código imperativo, va a la rúbrica manual.
6. **La comprobación no puede pasar por accidente.** `test -f Makefile` se
   cumple con un archivo vacío. Comprueba comportamiento: ejecuta el target y
   mira qué produce.
7. **Ninguna comprobación toca la red ni necesita privilegios.**

---

## Lo que sí se puede comprobar

Make deja rastro en disco y en su código de salida, así que casi todo es
verificable:

```json
{ "id": "incremental",
  "descripcion": "Una segunda ejecución de make all no rehace nada",
  "cmd": "{make} -C {semana}/3-proyecto/starter all >/dev/null && {make} -C {semana}/3-proyecto/starter all",
  "assert": "stdout~Nothing to be done|is up to date",
  "pista": "2-practicas/lab-02-dependencias/README.md, paso 5" }
```

```json
{ "id": "sin-for-recursivo",
  "descripcion": "La recursión no usa bucles for que se tragan los fallos",
  "cmd": "grep -nE 'for .*; *do .*[$][(]MAKE[)]' {semana}/3-proyecto/starter/Makefile",
  "assert": "exit!=0",
  "pista": "1-teoria/02-recursion-correcta.md" }
```

```json
{ "id": "fallo-propaga",
  "descripcion": "Si un servicio falla, make ci sale con error",
  "cmd": "{make} -C {semana}/3-proyecto/starter ci FORZAR_FALLO=api",
  "assert": "exit!=0",
  "pista": "2-practicas/lab-03-subdirectorios/README.md, paso 4" }
```

```json
{ "id": "help-documentado",
  "descripcion": "make sin argumentos muestra la ayuda",
  "cmd": "{make} -C {semana}/3-proyecto/starter",
  "assert": "stdout~[Tt]argets disponibles",
  "pista": "3-proyecto/README.md, paso 1" }
```

## Lo que no se puede comprobar

- Que el Makefile sea **legible**. Eso es rúbrica manual.
- Que entiendas lo que escribiste. Eso son las preguntas de Conocimiento.
- Que la elección de diseño sea **la buena**.

Por eso el Producto vale 30% y solo 60 de sus 100 puntos son automáticos.

---

## Escribir una comprobación nueva

1. Ejecuta el comando **a mano**, con un caso que pasa y otro que falla. Si no
   distingue los dos, la comprobación no vale.
2. Comprueba el código de salida con `echo $?`.
3. Añádela al `checks.json` con su `pista`.
4. Copia la `descripcion` al `3-proyecto/README.md`.
5. Corre `./scripts/verificar-semana.sh NN`: tiene que **fallar** contra el
   starter y **pasar** contra la solución. Una comprobación que nunca ha estado
   en rojo no se ha probado.
