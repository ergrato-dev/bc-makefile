# Lab 01 — Variables de Entorno y Secretos

⏱ Duración estimada: ~60 min

## Objetivo

Implementar un sistema de gestión de variables de entorno en Make que cargue `.env`, valide variables requeridas y soporte múltiples entornos (dev/staging/prod).

## Contexto

Todo proyecto real necesita separar configuración de código. Las credenciales, URLs de base de datos y API keys no van en el Makefile ni en el repositorio. El patrón estándar es:

- `.env.example` — plantilla commiteada con nombres de variables (sin valores reales)
- `.env`, `.env.dev`, `.env.prod`... — valores reales, **todos** ignorados por git (`.env*` + `!.env.example` en `.gitignore`)
- Make carga `.env` con `-include` y exporta **solo** las variables que las recetas necesitan (`export DB_URL API_KEY`)

Tres trampas que este lab evita:
- `include .env` parsea el archivo como Makefile: un `$` en un valor se expande, las comillas quedan literales, `#` corta el valor y `$(shell ...)` se ejecuta.
- `export` sin argumentos manda todas las variables, secretos incluidos, a cada proceso que lance una receta.
- `$(shell echo '$(API_KEY)')` pega el secreto en el texto del comando: una `'` en el valor lo convierte en inyección de comandos. El shell debe leerlo como variable de entorno (`$$API_KEY`).

El target `guard-%` es el mecanismo más limpio para validar que una variable existe antes de ejecutar un target que la necesita: si falta, el pipeline falla con un mensaje de error claro.

## Instrucciones

1. Copia el starter:
   ```bash
   cp -r starter/ mi-lab-01 && cd mi-lab-01
   ```

2. Revisa los archivos disponibles:
   ```bash
   ls -la
   cat .env.example
   ```

3. Ejecuta sin `.env` y observa el comportamiento:
   ```bash
   make env-check
   # Debe mostrar error por variable faltante
   ```

4. Crea tu `.env` a partir del ejemplo:
   ```bash
   cp .env.example .env
   # Edita .env y asigna valores a todas las variables
   ```

5. Implementa el **TODO 1** (`export DB_URL API_KEY`) y el **TODO 2** (`guard-%` con `$(if)` y `$(error)`).

6. Implementa `env-check` (**TODO 3**).

7. Implementa `env-show` (**TODO 4**) y compruébalo con un valor hostil:
   ```bash
   printf "DB_URL=postgres://u:p@h/db\nAPI_KEY=ab'cd;touch PWNED\n" > .env.prod
   make env-show ENV_FILE=.env.prod
   ls PWNED   # no debe existir
   ```

8. Implementa `env-dev`, `env-staging` y `env-prod` (**TODO 5**).

9. Verifica que todo funciona:
   ```bash
   make env-check
   make env-show
   make env-dev
   git status --short   # ningún .env* debe aparecer
   ```

## Criterios de éxito

- [ ] `make env-check` sin `.env` → imprime `DB_URL no definida. Copia .env.example a .env y asigna un valor` y sale distinto de 0
- [ ] `make env-check` con `.env` completo → imprime `Variables de entorno OK` y retorna exit code 0
- [ ] `make env-show` → `API_KEY` aparece como `tu-a***` y `DB_URL` como `postgresql://***@localhost:5432/miapp_dev`
- [ ] Con `API_KEY=ab'cd;touch PWNED`, `make env-show` no crea el archivo `PWNED`
- [ ] El Makefile no contiene `export` sin argumentos
- [ ] `git status` no muestra ningún `.env*` salvo `.env.example`
- [ ] `make env-dev` → carga `.env.dev` e imprime `Entorno: development`
- [ ] `make help` → lista todos los targets con descripción

## Reto extra

Agrega un target `env-diff` que compare `.env` con `.env.example` y liste las variables que están en el ejemplo pero no en `.env` local.
