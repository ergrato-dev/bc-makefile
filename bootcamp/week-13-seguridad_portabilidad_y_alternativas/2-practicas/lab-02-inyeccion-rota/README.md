# Lab 02 — Inyección de comandos (lab roto)

⏱ Duración estimada: ~60 min

## Objetivo

Explotar y corregir cinco inyecciones en un Makefile de release usando validación con lista blanca, paso por entorno y citado seguro.

## Contexto

- Un valor que llega por la línea de comandos o por el entorno (`VERSION=$TAG`, `BRANCH=$RAMA`) atraviesa **dos intérpretes**: primero Make expande cualquier `$(...)` que traiga, y después bash interpreta comillas, `;`, `` ` `` y `$( )` en el texto de la receta.
- Git admite `'`, `;`, `` ` `` y `$` en nombres de rama y de tag. Quien crea una rama decide qué ejecuta tu CI si la pegas en una receta.
- En este lab **todos los payloads son `touch pwned-X.txt`**. Nunca pruebes una inyección con `rm`, ni siquiera "en una carpeta de prueba".

## Instrucciones

Trabaja en `starter/`. Cada bug tiene un comentario `# BUG` en el Makefile.

1. **Bug A — comillas simples.** El valor cierra la comilla y añade su propio comando:
   ```bash
   make version "VERSION=x'; touch pwned-a.txt; echo '"
   ls pwned-a.txt
   ```
   La receta `echo 'Versión: $(VERSION)'` se convierte en `echo 'Versión: x'; touch pwned-a.txt; echo ''`.

2. **Bugs B y C — comillas dobles y sin comillas.**
   ```bash
   make notes 'BRANCH=main`touch pwned-b.txt`'
   make archive 'VERSION=1;touch pwned-c.txt #'
   ls pwned-*.txt
   ```
   Dentro de comillas dobles `` ` `` y `$( )` siguen ejecutando. Sin comillas, `;` termina el comando y `#` comenta el resto (`.txt`) para que nada falle.

3. **Bug D — Make expande antes que el shell.**
   ```bash
   make notes 'NOTE=$(shell touch pwned-d.txt)'
   make notes NOTE='Arregla $HOME'
   cat dist/NOTES.txt
   ```
   El primero ejecuta código sin que bash intervenga: lo hace Make al expandir `$(NOTE)`. El segundo no ataca a nadie y aun así sale roto: `Arregla OME`, porque Make leyó `$H` como una variable vacía. Ninguna comilla en la receta arregla esto.

4. **Arregla A y C validando VERSION.** VERSION tiene formato, así que se valida con lista blanca, en Make y sin shell. Copia estas utilidades al principio del Makefile:
   ```makefile
   strip-chars = $(if $2,$(call strip-chars,$(subst $(firstword $2),,$1),$(wordlist 2,$(words $2),$2)),$1)
   safe-word = $(and $(filter 1,$(words $1)),$(if $(call strip-chars,$1,$2),,ok))
   DIGITS := 0 1 2 3 4 5 6 7 8 9
   ```
   `strip-chars` borra uno a uno los caracteres permitidos; si queda algo, había un carácter prohibido. Ahora valida:
   ```makefile
   ifneq ($(call safe-word,$(value VERSION),$(DIGITS) .),ok)
     $(error VERSION inválida: usa solo dígitos y puntos, por ejemplo 1.4.2)
   endif
   ```
   `$(value VERSION)` devuelve el texto sin expandirlo, así que un `$(shell ...)` en VERSION tampoco se ejecuta. Repite los comandos de los pasos 1 y 2: los dos deben fallar con `VERSION inválida` antes de ejecutar nada.

5. **Arregla B y D pasando el texto libre por entorno.** BRANCH y NOTE no tienen formato que validar. Después de sus valores por defecto:
   ```makefile
   override BRANCH := $(value BRANCH)
   override NOTE   := $(value NOTE)
   export BRANCH NOTE
   ```
   y en la receta de `notes`:
   ```makefile
   printf 'Rama %s: %s\n' "$$BRANCH" "$$NOTE" > '$(BUILD_DIR)/NOTES.txt'
   ```
   `override ... := $(value X)` congela el texto tal cual llegó: Make no volverá a expandirlo. `"$$BRANCH"` hace que bash lea la variable de su entorno: una expansión de variable entre comillas dobles es un dato, nunca código. Repite el paso 3: `dist/NOTES.txt` debe contener literalmente `$(shell touch pwned-d.txt)` y `Arregla $HOME`.

6. **Defensa 3: citar con `q`.** A veces el valor tiene que ir dentro del texto del comando. Añade:
   ```makefile
   q = '$(subst ','\'',$1)'
   ```
   y un target `notes-echo` con la receta `@echo Nota: $(call q,$(NOTE))` (decláralo en `.PHONY` y documéntalo con `##`). `q` envuelve el valor en comillas simples y convierte cada `'` interna en `'\''`. Pruébalo:
   ```bash
   make notes-echo NOTE="it's \$(shell x) \`y\`"
   ```
   Debe imprimir `Nota: it's $(shell x) `y``.

7. **Bug E — `rm -rf` sin guarda.** Prueba **solo con `-n`**:
   ```bash
   make -n clean BUILD_DIR=
   make -n clean BUILD_DIR=/home
   make -n clean BUILD_DIR=dist/..
   ```
   El starter imprime `rm -rf /`, `rm -rf /home/` y `rm -rf dist/../`. La guarda de la Semana 03 (vacía) no basta: añade también rutas absolutas, `..` y caracteres fuera de una lista blanca:
   ```makefile
   LETTERS    := a b c d e f g h i j k l m n o p q r s t u v w x y z \
                 A B C D E F G H I J K L M N O P Q R S T U V W X Y Z
   PATH_CHARS := $(DIGITS) $(LETTERS) - _ . /
   ```
   ```makefile
   clean: ## Borra dist/ (con guardas)
   	$(if $(BUILD_DIR),,$(error BUILD_DIR vacía: rm -rf no se ejecuta))
   	$(if $(filter /% ~%,$(BUILD_DIR))$(findstring ..,$(BUILD_DIR)),$(error BUILD_DIR debe ser relativa y sin '..': rm -rf no se ejecuta))
   	$(if $(call safe-word,$(BUILD_DIR),$(PATH_CHARS)),,$(error BUILD_DIR con caracteres no permitidos: rm -rf no se ejecuta))
   	rm -rf -- '$(BUILD_DIR)'
   ```
   Los tres comandos `-n` deben fallar con un mensaje que empiece por `BUILD_DIR`.

8. **Verificación final.**
   ```bash
   rm -f pwned-*.txt
   make release VERSION=1.4.2 BRANCH="feat/o'brien" NOTE='Arregla $HOME y `ls`'
   cat dist/app-1.4.2.txt
   make clean; ls
   ```
   Debes ver `Rama feat/o'brien: Arregla $HOME y `ls`` (el texto intacto) y, tras `make clean`, solo `Makefile`.

## Criterios de éxito

- [ ] Los payloads de los pasos 1, 2 y 3 ya no crean ningún `pwned-*.txt`
- [ ] `make version VERSION=1.4.2` imprime `Versión: 1.4.2`; cualquier VERSION con algo que no sean dígitos y puntos falla con `VERSION inválida`
- [ ] `dist/NOTES.txt` guarda BRANCH y NOTE literalmente, incluidos `'`, `$HOME` y `` ` ``
- [ ] `make notes-echo` imprime una nota con `'` sin romper el comando
- [ ] `make -n clean` con `BUILD_DIR=`, `/home` o `dist/..` falla antes de imprimir ningún `rm`
- [ ] Cada bug tiene un comentario `# FIX:` que explica la corrección

## Reto extra

Las variables de entorno también son entrada no confiable. Prueba
`VERSION='1;touch pwned-e.txt #' make archive` con tu solución y explica en un
comentario por qué la validación del paso 4 también la cubre, y qué pasaría si
hubieras escrito `VERSION := 0.1.0` en lugar de `?=`.
