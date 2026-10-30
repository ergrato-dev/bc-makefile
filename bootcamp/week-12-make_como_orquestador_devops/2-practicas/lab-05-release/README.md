# Lab 05 — Releases con Versionado Semántico

**Duración estimada:** 60 min

## Objetivo

Automatizar el proceso de release de un proyecto usando versionado semántico desde Make: leer versión actual, incrementar patch/minor/major, crear tag git y generar un changelog básico.

## Contexto

El versionado semántico (SemVer) sigue el formato `MAJOR.MINOR.PATCH`:
- `PATCH` (+0.0.1): corrección de bug, sin cambios de API
- `MINOR` (+0.1.0): nueva funcionalidad, sin romper compatibilidad
- `MAJOR` (+1.0.0): cambios incompatibles con versiones anteriores

En Make, el flujo de release se modela así:
1. Leer versión actual de un archivo `VERSION`
2. Calcular la próxima versión
3. Escribir la nueva versión al archivo
4. Crear un tag git
5. Generar/actualizar `CHANGELOG.md`

## Instrucciones

1. Copia el starter:
   ```bash
   cp -r starter/ mi-lab-05 && cd mi-lab-05
   git init && git add . && git commit -m "init"
   ```

2. Verifica la versión inicial:
   ```bash
   cat VERSION
   make version
   ```

3. Implementa `bump-patch`, `bump-minor` y `bump-major` que incrementen la versión correspondiente.

4. Implementa `tag` que crea un tag git con la versión actual (`v$(VERSION)`).

5. Implementa `changelog` que genera una entrada en `CHANGELOG.md` con los commits desde el último tag.

6. Implementa `release-patch` que orquesta: `bump-patch → tag → changelog`.

7. Prueba el flujo completo:
   ```bash
   make version        # muestra 0.1.0
   make bump-patch     # VERSION pasa a 0.1.1
   make version        # muestra 0.1.1
   make release-patch  # bump + tag + changelog
   git log --oneline   # ver el tag creado
   ```

## Criterios de éxito

- [ ] `make version` → imprime `Versión actual: 0.1.0` (o la versión en VERSION)
- [ ] `make bump-patch` → actualiza VERSION de `X.Y.Z` a `X.Y.(Z+1)` e imprime la nueva versión
- [ ] `make bump-minor` → actualiza VERSION de `X.Y.Z` a `X.(Y+1).0`
- [ ] `make bump-major` → actualiza VERSION de `X.Y.Z` a `(X+1).0.0`
- [ ] `make tag` → crea tag git `vX.Y.Z` con el mensaje "Release vX.Y.Z"
- [ ] `make changelog` → agrega entrada en `CHANGELOG.md` con fecha y commits desde el último tag
- [ ] `make release-patch` con VERSION `0.1.0` → crea el tag `v0.1.1` (no `v0.1.0`)
- [ ] Con `VERSION` = `1.0.0;touch PWNED`, cualquier `make` falla con `VERSION inválida` y no crea `PWNED`

## Reto extra

Agrega validación en `tag` para que falle si hay cambios sin commitear (`git status --porcelain`), evitando crear un tag con estado sucio.
