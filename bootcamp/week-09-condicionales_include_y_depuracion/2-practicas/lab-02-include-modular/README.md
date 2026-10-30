# Lab 02 — Include y Makefiles modulares

**Duración estimada:** 60 min

## Objetivo

Separar un Makefile en módulos `.mk` con `include` y `-include`, y generar
uno de ellos con una regla que Make rehace antes de leerlo.

## Contexto

- `include archivo` inserta el texto del archivo en ese punto, como si
  estuviera escrito ahí. El **orden** importa: un módulo que hace
  `X := $(APP_NAME)-...` necesita `APP_NAME` definida antes del `include`.
- `-include` no falla si el archivo no existe: es para overrides locales.
- Si un archivo incluido tiene regla, Make lo rehace cuando está desactualizado
  y **vuelve a leer el Makefile entero** desde el principio.

## Instrucciones

1. Copia el starter y mira las piezas:
   ```bash
   cp -r starter/ mi-lab-02 && cd mi-lab-02
   ls mk/ && cat VERSION
   make info
   ```
   `VERSION` sale vacía: todavía no la lee nadie.

2. Lee la cabecera de cada `mk/*.mk`: dice qué variables necesita. Ese
   comentario es el contrato del módulo.

3. **Incluir los módulos (TODO 1).** Añade los tres `include` y el
   `-include mk/local.mk`, y ejecuta:
   ```bash
   make help
   ```
   Cada línea sale con el nombre del archivo delante (`mk/build.mk  Compilar...`):
   con varios archivos en `$(MAKEFILE_LIST)`, `grep` antepone el nombre de
   cada uno. Arréglalo con `grep -h` y comprueba que la columna izquierda
   vuelve a ser el target.

4. **Recetas de los módulos (TODOs 3, 4 y 5).** Completa `build`, `clean`,
   `test` y `deploy`:
   ```bash
   make build                 # [build] Compilando mi-app-
   make deploy ENV=staging    # [deploy] Desplegando mi-app  en staging
   ```
   La versión sigue vacía; la conectas en el paso 7.

5. **El orden de los include.** Mueve temporalmente la línea
   `APP_NAME := mi-app` debajo de los `include` y ejecuta `make build` y
   `make test`. `build` imprime `Compilando -` y `test` sigue mostrando
   `mi-app`. Explica en un comentario por qué uno ve la variable y el otro no
   (pista: `:=` en `build.mk` frente a la referencia dentro de la receta en
   `test.mk`). Devuelve la línea a su sitio.

6. **Override local opcional.**
   ```bash
   make info | grep LOCAL      # LOCAL_OVERRIDE = false
   echo 'LOCAL_OVERRIDE := true' > mk/local.mk
   make info | grep LOCAL      # LOCAL_OVERRIDE = true
   rm mk/local.mk
   ```
   Cambia `-include` por `include`, borra `mk/local.mk` y ejecuta `make info`:
   anota el error y vuelve a poner el guion.

7. **Include generado (TODO 2).** Añade `include mk/version.mk` antes de los
   módulos y la regla que lo genera desde `VERSION`:
   ```bash
   make build
   ```
   ```
   [version] regenerando mk/version.mk desde VERSION
   [build] Compilando mi-app-1.4.0
   ```
   Ejecuta `make build` otra vez: ya no regenera. Ahora cambia la versión:
   ```bash
   echo 1.5.0 > VERSION
   make build     # regenera y compila mi-app-1.5.0
   ```
   Make vio que `mk/version.mk` era más viejo que `VERSION`, lo rehízo y releyó
   todo el Makefile con el valor nuevo. No hizo falta `$(shell cat VERSION)`
   en cada ejecución.

8. Deja `VERSION` en `1.4.0` y borra el archivo generado: `rm mk/version.mk`.

## Criterios de éxito

- [ ] `make help` lista `all`, `info`, `help`, `build`, `clean`, `test` y `deploy` sin nombres de archivo delante
- [ ] `make build` imprime `[build] Compilando mi-app-1.4.0`
- [ ] `make test` imprime `[test] Ejecutando tests de mi-app`
- [ ] `make deploy ENV=staging` imprime `[deploy] Desplegando mi-app 1.4.0 en staging`
- [ ] Sin `mk/local.mk`, `make info` funciona y muestra `LOCAL_OVERRIDE = false`; con él, `true`
- [ ] Tras `echo 1.5.0 > VERSION`, `make build` imprime `[version] regenerando ...` y `Compilando mi-app-1.5.0`; una segunda ejecución no regenera
- [ ] El comentario del paso 5 explica por qué `build` pierde `APP_NAME` y `test` no

## Reto extra

Crea `mk/docker.mk` con `docker-build` (imprime la imagen
`$(APP_NAME):$(VERSION)`) e inclúyelo con
`include $(wildcard mk/*.mk)` en lugar de nombrar cada módulo. ¿Qué pasa con
`mk/version.mk` y `mk/local.mk` si usas ese comodín? ¿Te sigue sirviendo el
`-include`?
