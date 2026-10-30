# Glosario — Semana 08: Funciones Avanzadas

| Término | Definición en una línea | Ejemplo en Makefile |
|---------|------------------------|---------------------|
| `$(foreach var,list,text)` | Expande `text` una vez por cada palabra de `list`, sustituyendo `$(var)` | `$(foreach m,auth logger,build/$(m).o)` → `build/auth.o build/logger.o` |
| `$(call name,arg1,...)` | Invoca una función definida con `define...endef`; los args son `$1`, `$2`... | `$(call compile_msg,api,2)` |
| `define...endef` | Bloque que define una variable multi-línea o plantilla de función | `define RULE` ... `endef` |
| `$(eval text)` | Parsea `text` como sintaxis Makefile real, creando reglas y variables en memoria | `$(eval $(call BUILD_RULE,main))` |
| `$(shell cmd)` | Ejecuta `cmd` en el shell y captura su stdout como string Make | `$(shell git rev-parse --short HEAD)` |
| Plantilla | Bloque `define` parametrizado con `$1`, `$2`, etc., para instanciar reglas similares | `define MODULE_RULE` con `$(1)` como nombre |
| Instanciación dinámica | Proceso de generar reglas Make en tiempo de carga con `$(eval)` + `$(call)` | `$(foreach m,$(MODULES),$(eval $(call RULE,$(m))))` |
| Doble dólar (`$$`) | Escapa un `$` dentro de un bloque `define` para que sobreviva la expansión de `$(call)` | `$$<` dentro del define → `$<` en la regla real |
| Fallback de shell | Valor alternativo si el comando de `$(shell)` falla o devuelve vacío | `$(shell git ... 2>/dev/null \|\| echo sin-git)` |
| Meta-Makefile | Makefile que genera sus propias reglas dinámicamente, sin listas hardcodeadas | `$(foreach svc,$(SERVICES),$(eval $(call SERVICE_RULE,$(svc))))` |
| `$(file >ruta,texto)` | Escribe (`>`) o añade (`>>`) texto a un archivo sin lanzar un shell; `$(file <ruta)` lo lee | `$(file >$@,OS_NAME := $(OS_NAME))` |
| `$(value VAR)` | Devuelve el texto de una variable sin expandirlo, útil para ver una plantilla cruda | `$(info $(value SERVICE_RULE))` |
| `$(let vars,lista,texto)` | (Make 4.4+) Asigna palabras de una lista a variables locales dentro de `texto` | `$(let first rest,$(SERVICES),$(first))` |
| `$(intcmp a,b,menor,igual,mayor)` | (Make 4.4+) Compara dos enteros y devuelve la rama correspondiente | `$(intcmp $(JOBS),8,ok,ok,demasiados)` |
| Fase de lectura | Momento en que Make lee el Makefile: ejecuta los `:=` con `$(shell)` y los `$(eval)`, incluso con `make -n` | `GIT_HASH := $(shell git rev-parse --short HEAD)` |
