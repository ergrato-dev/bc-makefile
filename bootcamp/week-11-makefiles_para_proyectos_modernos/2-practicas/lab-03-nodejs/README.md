# Lab 03 — Node.js con Make

**Duración estimada:** 60 minutos

**Requisitos:** Node.js 26 LTS y pnpm

## Objetivo

Envolver el ciclo de vida de un proyecto Node.js (install, build, test, lint) en un Makefile, con un sentinel en `node_modules/` y un build incremental que solo recompila cuando cambia el fuente.

## Contexto

El sentinel file para Node.js es `node_modules/.installed`, igual que en Python. Depende de `package.json` y de `pnpm-lock.yaml`: si cualquiera cambia, Make reinstala.

```makefile
node_modules/.installed: package.json pnpm-lock.yaml
	pnpm install --frozen-lockfile
	@mkdir -p $(@D)
	@touch $@
```

Usa `pnpm install --frozen-lockfile`: instala exactamente lo que dice el lockfile y falla si no coincide con `package.json`. Sin el flag, pnpm puede reescribir el lockfile y cada máquina acabar con versiones distintas. En este bootcamp Node.js se usa siempre con **pnpm**, nunca con npm.

El sentinel es nuestro, no un archivo interno de pnpm: así no dependemos de qué toque o deje de tocar el gestor de paquetes en `node_modules/`. Lo mismo aplica al build: `pnpm run build` produce `dist/index.js`, un archivo real que Make puede comparar con `src/index.js`.

## Instrucciones

1. Entra al directorio starter:
   ```bash
   cd lab-03-nodejs/starter
   ```

2. Revisa los archivos del proyecto:
   ```bash
   cat package.json
   cat src/index.js
   cat tests/test.js
   ```

3. Ejecuta `make help`:
   ```bash
   make help
   ```

4. Implementa el **TODO 0** (preámbulo estricto) y los TODOs 1–6 del `Makefile`:
   - **TODO 1:** target `node_modules/.installed` con dependencias `package.json` y `pnpm-lock.yaml`; receta: `pnpm install --frozen-lockfile`, `mkdir -p $(@D)` y `touch $@`
   - **TODO 2:** target `install` como alias del sentinel
   - **TODO 3:** target `build` que dependa de `install` y ejecute `pnpm run build`
   - **TODO 4:** target `test` que dependa de `install` y ejecute `pnpm test`
   - **TODO 5:** target `lint` que dependa de `install` y ejecute `pnpm run lint`
   - **TODO 6:** target `clean` que elimine `node_modules/` y `dist/`, con guarda de variable vacía

5. Verifica:
   ```bash
   make install
   make install   # segunda vez: no debe reinstalar
   make test
   make build
   make build     # vuelve a ejecutar pnpm run build: ¿hacía falta?
   ```

6. Simula que un compañero actualizó el lockfile y comprueba que el sentinel lo detecta:
   ```bash
   touch pnpm-lock.yaml
   make -n install    # muestra pnpm install --frozen-lockfile
   ```
   Ahora edita `package.json` para añadir una dependencia sin actualizar el lock (por ejemplo `"dependencies": {"left-pad": "1.3.0"}`) y ejecuta `make install`: `--frozen-lockfile` falla con `ERR_PNPM_OUTDATED_LOCKFILE` y el sentinel **no** se crea. Deshaz el cambio en `package.json`.

7. Implementa el **TODO 7** (build incremental con `dist/index.js` como target de archivo) y comprueba:
   ```bash
   make build         # compila
   make build         # make: Nothing to be done for 'build'.
   touch src/index.js
   make build         # compila otra vez
   make clean
   ```

## Criterios de éxito

```
$ make install
pnpm install --frozen-lockfile
...

$ make install   # segunda ejecución
make: Nothing to be done for 'install'.
```

```
$ make test
node tests/test.js
PASS: saludar retorna saludo correcto
Todos los tests pasaron.
```

```
$ make build
pnpm run build
Compilando...
$ make build
make: Nothing to be done for 'build'.
$ ls dist/
index.js
```

```
$ make clean
Limpiado.
$ ls node_modules
ls: no se puede acceder a 'node_modules': No existe el archivo o el directorio
```

## Reto extra

Agrega un target `dev` que ejecute `pnpm run dev` (modo watch). Asegúrate de que esté en `.PHONY` y que el proceso pueda interrumpirse con Ctrl+C sin dejar la terminal en mal estado.
