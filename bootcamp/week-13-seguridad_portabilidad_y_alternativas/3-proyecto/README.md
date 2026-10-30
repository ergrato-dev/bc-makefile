# Proyecto Semana 13 — Auditoría y endurecimiento de un Makefile real

⏱ Duración estimada: ~3 h

## Contexto

Acabas de entrar en el equipo de plataforma. El servicio `notify` (un script que manda avisos al canal del equipo) se empaqueta y despliega con un Makefile que nadie ha revisado desde que lo escribió alguien que ya no está. El CI lo llama con valores que controlan otras personas:

```bash
make package VERSION=$TAG BRANCH=$RAMA
make deploy  DEPLOY_TOKEN=$TOKEN
```

Seguridad ha pedido una auditoría antes de dar acceso al token de producción. Tu entrega: el Makefile endurecido y un `AUDITORIA.md` con cada hallazgo, su prueba y su corrección. El "servidor" de despliegue y el "mirror" de herramientas son carpetas locales (`file://`): el proyecto funciona sin red.

## Estructura del starter

```
starter/
├── Makefile                    ← lo auditas y lo corriges
├── AUDITORIA.md                ← plantilla del informe (con TODO)
├── .env.example                ← formato de .env: DEPLOY_URL y DEPLOY_TOKEN
├── .gitignore                  ← build/ y .env
├── src/
│   └── notify.sh               ← lo que se empaqueta
└── vendor/
    └── install-fmt-tool.sh     ← instalador de fmt-tool ("mirror" local)
```

## Contrato que tiene que cumplir el Makefile

El CI y otros equipos dependen de estos nombres. No los cambies.

| Elemento | Valor |
|---|---|
| Targets | `help` (por defecto), `install-tools`, `lint`, `package`, `deploy`, `clean`, `check` |
| Paquete | `build/notify-$(VERSION).tar.gz`, con `src/` y un `BUILDINFO` en la raíz con líneas `version=` y `branch=` |
| Credenciales de curl | `build/curl-auth.conf`, con `header = "Authorization: Bearer <token>"`, que `deploy` pasa con `curl -K` |
| Herramienta | `make install-tools` instala `build/tools/fmt-tool` desde `TOOL_URL` |
| Variables de entrada | `VERSION` (por defecto `0.1.0`), `BRANCH` (por defecto, la rama de git), `DEPLOY_TOKEN`, `DEPLOY_URL`, `ENV_FILE` (por defecto `.env`), `TOOL_URL`, `BUILD_DIR` (por defecto `build`), `MIN_MAKE_VERSION` (por defecto `4.3`) |
| `.env` | Solo `DEPLOY_URL` y `DEPLOY_TOKEN`, formato `CLAVE=valor` sin espacios, comillas ni `$` |

## Entregables

1. **El Makefile endurecido** en `starter/Makefile`, sin ningún `TODO`. Cada corrección lleva un comentario con el ID de su hallazgo (`# H7: ...`).
2. **`AUDITORIA.md`** con al menos 8 hallazgos en la tabla (`| H1 | ... |`), cada uno con severidad, la prueba que lo demuestra **con un payload inofensivo** (un `touch` en una carpeta de `mktemp -d`) y la corrección. Incluye una sección "Riesgos aceptados" con lo que decides no corregir y por qué.
3. **`make check`**, una autoprueba que falla si reaparece cualquiera de los hallazgos de inyección, guardas, dry-run o `make -q`.

## Cómo trabajar

1. **Reconocimiento (30 min).** Lee el Makefile entero. Ejecuta cada target con valores normales. Haz una lista de sospechas: hay al menos diez problemas, señalados con `TODO 0` a `TODO 10`, y algunos que no tienen `TODO`.
2. **Prueba antes de corregir (45 min).** Para cada sospecha, escribe el comando que la demuestra y apúntalo en `AUDITORIA.md`. Usa siempre una carpeta temporal y un `touch`:
   ```bash
   D=$(mktemp -d)
   make package "VERSION=1.0.0\`touch $D/pwned\`"; ls $D
   ```
   Lo destructivo (`clean`) se prueba **solo con `-n`**.
3. **Corrige (75 min).** Aplica las técnicas de los labs: preámbulo y guarda de versión (lab 05), nada al parsear y `.env` validado (lab 01), validación y paso por entorno (lab 02), secretos, `umask` y descarga verificada (lab 03), target de archivo y autoprueba (lab 04).
4. **Verifica (30 min).** `make check`, los comandos de abajo y `./scripts/verificar-semana.sh 13`.

## Verificación

```bash
make                                              # Targets disponibles: ...
make package VERSION=1.4.2                        # Paquete: build/notify-1.4.2.tar.gz (... bytes)
tar -xzOf build/notify-1.4.2.tar.gz BUILDINFO     # version=1.4.2 / branch=<tu rama>
make package 'VERSION=1;touch pwned'              # VERSION inválida ... Stop.
make -n deploy DEPLOY_TOKEN=canario | grep -c canario   # 0
DEPLOY_TOKEN=x make deploy                        # Desplegado notify 0.1.0 en file://.../build/remote/
make install-tools && make lint                   # fmt-tool 1.2.0: 1 archivo(s) OK
make -n clean BUILD_DIR=/                         # BUILD_DIR debe ser relativa ... Stop.
make check                                        # 1/6 ... 6/6, check: OK
```

## ✅ Requisitos verificables

Los comprueba `./scripts/verificar-semana.sh 13` desde la raíz del repositorio
(60 de los 100 puntos del Producto). Los otros 40 son de calidad: ver la
[rúbrica](../rubrica-evaluacion.md#-producto-30).

- [ ] El Makefile se niega a correr con una versión de Make anterior a MIN_MAKE_VERSION
- [ ] El Makefile ejecuta las recetas con bash -eu -o pipefail
- [ ] make help y make -n no crean nada en disco
- [ ] Un ENV_FILE con código Make no se ejecuta y uno con claves válidas se acepta
- [ ] Las recetas no reciben variables que el Makefile no exporta explícitamente
- [ ] Una VERSION con código de shell se rechaza sin ejecutar nada
- [ ] Una BRANCH con código de shell se guarda como texto en BUILDINFO sin ejecutarse
- [ ] make -n deploy muestra $DEPLOY_TOKEN y nunca el valor del token
- [ ] build/curl-auth.conf se crea legible solo por su dueño
- [ ] make clean se niega a borrar si BUILD_DIR está vacío
- [ ] make clean se niega a borrar rutas absolutas o con ..
- [ ] make install-tools solo ejecuta el instalador si su SHA-256 coincide
- [ ] make --warn-undefined-variables -n no avisa de ninguna variable indefinida
- [ ] El paquete es un target de archivo: make -q lo da por bueno tras package y por obsoleto tras tocar src/
- [ ] make check ejecuta la autoprueba del Makefile y termina sin errores
- [ ] AUDITORIA.md existe y no contiene ningún TODO
- [ ] AUDITORIA.md documenta al menos 8 hallazgos en su tabla

Todas las comprobaciones usan payloads inofensivos (`touch` en una carpeta
temporal) y prueban `clean` solo con `make -n`.

## Calidad (40 pts)

| Criterio | Puntos |
|---|:--:|
| Cada hallazgo de `AUDITORIA.md` tiene una prueba reproducible y la corrección enlaza con un comentario `# Hn` en el Makefile | 12 |
| Defensa adecuada a cada dato: lista blanca para lo que tiene formato, entorno para el texto libre, nunca al revés | 8 |
| Mínimo privilegio con el token: `unexport` y `export` específico de target, archivo de credenciales borrado tras el deploy | 6 |
| `make check` falla de verdad: probado reintroduciendo al menos dos hallazgos | 6 |
| `.PHONY` completo, `help` útil, secciones y variables agrupadas | 4 |
| Comandos portables (sin `stat -c`, `sed -i`, `sha256sum` a secas) | 4 |
| **Total** | **40** |

## Entrega

Commit con el mensaje:

```
feat(week-13): proyecto - auditoría y endurecimiento del Makefile de notify
```
