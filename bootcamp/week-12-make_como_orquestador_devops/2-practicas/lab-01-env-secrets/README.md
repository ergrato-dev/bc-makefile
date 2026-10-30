# Lab 01 — Variables de Entorno y Secretos

**Duración estimada:** 50 min

## Objetivo

Implementar un sistema de gestión de variables de entorno en Make que cargue `.env`, valide variables requeridas y soporte múltiples entornos (dev/staging/prod).

## Contexto

Todo proyecto real necesita separar configuración de código. Las credenciales, URLs de base de datos y API keys no van en el Makefile ni en el repositorio. El patrón estándar es:

- `.env.example` — plantilla commiteada con nombres de variables (sin valores)
- `.env` — valores reales, ignorado por git
- Make carga `.env` con `-include` y lo propaga con `export`

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

5. Implementa el target `guard-%` donde indica el TODO en el Makefile.

6. Implementa el target `env-check` para validar todas las variables requeridas.

7. Implementa el target `env-show` que muestra las variables (enmascarando secretos).

8. Implementa el target `env-dev`, `env-staging` y `env-prod` que cargan el `.env` correspondiente.

9. Verifica que todo funciona:
   ```bash
   make env-check
   make env-show
   make env-dev
   ```

## Criterios de éxito

- [ ] `make env-check` sin `.env` → imprime `ERROR: APP_NAME no definida. Ver .env.example` y retorna exit code 1
- [ ] `make env-check` con `.env` completo → imprime `Variables de entorno OK` y retorna exit code 0
- [ ] `make env-show` → muestra todas las variables; `API_KEY` aparece como `api_ke***` (enmascarada)
- [ ] `make env-dev` → carga `.env.dev` e imprime `Entorno: development`
- [ ] `make help` → lista todos los targets con descripción

## Reto extra

Agrega un target `env-diff` que compare `.env` con `.env.example` y liste las variables que están en el ejemplo pero no en `.env` local.
