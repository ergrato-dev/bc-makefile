# Lab 05 — combinadas

⏱ Duración estimada: ~60 min

## Objetivo

Construir un build system de plugins que use `$(shell)` para auto-descubrir módulos, `$(call)` para plantillas de compilación, `$(eval)` + `$(foreach)` para generar las reglas.

## Contexto

Tienes un sistema extensible via plugins. Cada plugin vive en `plugins/<nombre>/plugin.c`. El build system debe compilar todos los plugins presentes sin que el Makefile tenga que listarlos explícitamente.

El flujo completo combina las cuatro funciones:

```
$(shell find plugins -mindepth 1 -maxdepth 1 -type d)
         ↓ auto-descubre directorios
$(notdir ...)
         ↓ extrae nombres
$(foreach p,$(PLUGINS),$(eval $(call PLUGIN_RULE,$(p))))
         ↓ genera una regla de compilación por plugin
```

El starter ya incluye tres plugins (`compress`, `encrypt`, `format`) con su código C.

## Instrucciones

1. Entra al directorio starter:
   ```bash
   cd lab-05-combinadas/starter
   ```

2. Verifica la estructura:
   ```bash
   find plugins -type f
   ```

3. Implementa los TODOs 1 a 5:
   - **TODO 1:** `PLUGIN_DIRS` con `$(shell find plugins -mindepth 1 -maxdepth 1 -type d 2>/dev/null | sort)`
   - **TODO 2:** `PLUGINS` extrayendo solo los nombres con `$(notdir ...)`
   - **TODO 3:** `ALL_OBJS` generando rutas `build/<nombre>.o` con `$(foreach)`
   - **TODO 4:** Define `PLUGIN_RULE` que genera la regla de compilación para `build/$(1).o` desde `plugins/$(1)/plugin.c` — usa `$$<` y `$$@`
   - **TODO 5:** Instancia `PLUGIN_RULE` para cada plugin con `$(foreach) + $(eval) + $(call)`

4. Verifica:
   ```bash
   make info
   make all
   ls build/
   ```

5. Prueba la resistencia al cambio — crea un nuevo plugin:
   ```bash
   mkdir -p plugins/log
   cat > plugins/log/plugin.c << 'EOF'
   #include <stdio.h>
   void plugin_init(void) { printf("[log] inicializado\n"); }
   EOF
   make clean && make info && make all
   ```
   El nuevo plugin debe compilarse sin editar el Makefile. Al terminar, bórralo: `rm -rf plugins/log`.

6. Un target por plugin (TODO 6). Añade a `PLUGIN_RULE` un target phony `plugin-$(1)` que dependa del objeto, y compila solo uno:
   ```bash
   make clean
   make plugin-encrypt
   ls build/
   ```
   Debes ver:
   ```
   gcc -Wall -Wextra -std=c11 -c plugins/encrypt/plugin.c -o build/encrypt.o
   encrypt.o
   ```
   El `.PHONY` va dentro de la plantilla: cada instancia declara el suyo.

7. Comprueba que las reglas generadas son incrementales, igual que las escritas a mano:
   ```bash
   make all
   make all | grep -c gcc
   touch plugins/format/plugin.c
   make all
   ```
   El segundo comando imprime `0` (no recompila nada). Tras el `touch`, solo se recompila `format`:
   ```
   gcc -Wall -Wextra -std=c11 -c plugins/format/plugin.c -o build/format.o
   Todos los plugins compilados: compress encrypt format
   ```

## Criterios de éxito

```
$ make info
Directorios: plugins/compress plugins/encrypt plugins/format
Plugins:     compress encrypt format
Objetos:     build/compress.o build/encrypt.o build/format.o
Total:       3 plugins
```

```
$ make all
gcc -Wall -Wextra -std=c11 -c plugins/compress/plugin.c -o build/compress.o
gcc -Wall -Wextra -std=c11 -c plugins/encrypt/plugin.c -o build/encrypt.o
gcc -Wall -Wextra -std=c11 -c plugins/format/plugin.c -o build/format.o
Todos los plugins compilados: compress encrypt format
```

- [ ] `make plugin-encrypt` desde cero compila solo `build/encrypt.o`
- [ ] Una segunda ejecución de `make all` no lanza `gcc`; tras `touch plugins/format/plugin.c` solo se recompila `format`
- [ ] Un plugin nuevo en `plugins/` se compila sin editar el Makefile

## Reto extra

Agrega un target `list-symbols` que use `$(shell nm build/*.o 2>/dev/null | grep ' T ')` para listar los símbolos exportados por todos los plugins compilados.
