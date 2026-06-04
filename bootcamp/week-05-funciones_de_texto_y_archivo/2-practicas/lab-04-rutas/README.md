# Lab 04 — rutas

**Duración estimada:** 50 minutos

## Objetivo

Extraer y manipular partes de rutas de archivo usando `$(dir)`, `$(notdir)`, `$(basename)`, `$(suffix)`, `$(addprefix)` y `$(addsuffix)`.

## Contexto

Make tiene seis funciones para diseccionar rutas:

| Función | Extrae | Ejemplo |
|---------|--------|---------|
| `$(dir f)` | Directorio (con `/` final) | `src/` |
| `$(notdir f)` | Nombre sin directorio | `main.c` |
| `$(basename f)` | Ruta sin extensión | `src/main` |
| `$(suffix f)` | Solo la extensión | `.c` |
| `$(addprefix p,list)` | Agrega `p` a cada palabra | `-Isrc -Iinclude` |
| `$(addsuffix s,list)` | Agrega `s` a cada palabra | `src/ include/` |

Todas operan sobre listas: si pasas múltiples palabras, cada una se transforma de forma independiente.

## Instrucciones

1. Entra al directorio starter:
   ```bash
   cd lab-04-rutas/starter
   ```

2. Ejecuta `make demo`. Varios valores estarán vacíos.

3. Completa `DIRECTORIOS` usando `$(dir)` sobre `ARCHIVOS`:
   ```makefile
   DIRECTORIOS := $(dir $(ARCHIVOS))
   ```

4. Completa `NOMBRES` usando `$(notdir)`:
   ```makefile
   NOMBRES := $(notdir $(ARCHIVOS))
   ```

5. Completa `BASES` usando `$(basename)`:
   ```makefile
   BASES := $(basename $(ARCHIVOS))
   ```

6. Completa `EXTENSIONES` usando `$(suffix)`:
   ```makefile
   EXTENSIONES := $(suffix $(ARCHIVOS))
   ```

7. Completa `INCLUDE_FLAGS` usando `$(sort)` + `$(dir)` + `$(addprefix -I,...)`:
   ```makefile
   INCLUDE_FLAGS := $(addprefix -I,$(sort $(dir $(ARCHIVOS))))
   ```

8. Completa `BACKUPS` usando `$(addsuffix .bak,$(NOMBRES))`:
   ```makefile
   BACKUPS := $(addsuffix .bak,$(NOMBRES))
   ```

9. Ejecuta `make demo` y verifica la salida esperada.

## Criterios de éxito

```
$ make demo
Archivos:     src/main.c src/utils/io.c include/utils.h build/obj/main.o
Directorios:  src/ src/utils/ include/ build/obj/
Nombres:      main.c io.c utils.h main.o
Bases:        src/main src/utils/io include/utils build/obj/main
Extensiones:  .c .c .h .o
-I flags:     -Ibuild/obj/ -Iinclude/ -Isrc/ -Isrc/utils/
Backups:      main.c.bak io.c.bak utils.h.bak main.o.bak
```

> Nota: `$(sort)` ordena alfabéticamente, por eso `-I flags:` aparece en orden distinto a `Directorios:`.

## Reto extra

Combina `$(notdir)` y `$(basename)` para obtener solo los nombres de archivo sin directorio NI extensión. Por ejemplo, `src/main.c` → `main`. Agrega la variable `STEMS` a `make demo`.
