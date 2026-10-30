# Lab 03 — Node.js con Make

**Duración estimada:** 50 minutos

**Requisitos:** Node.js 26 LTS y pnpm

## Objetivo

Envolver el ciclo de vida de un proyecto Node.js (install, build, test, lint) en un Makefile, usando `node_modules/` como sentinel file para evitar reinstalaciones innecesarias.

## Contexto

El sentinel file para Node.js es `node_modules/.installed`, igual que en Python. Depende de `package.json` y de `pnpm-lock.yaml`: si cualquiera cambia, Make reinstala.

```makefile
node_modules/.installed: package.json pnpm-lock.yaml
	pnpm install --frozen-lockfile
	@mkdir -p $(@D)
	@touch $@
```

Usa `pnpm install --frozen-lockfile`: instala exactamente lo que dice el lockfile y falla si no coincide con `package.json`. Sin el flag, pnpm puede reescribir el lockfile y cada máquina acabar con versiones distintas. En este bootcamp Node.js se usa siempre con **pnpm**, nunca con npm.

La ventaja: Make usa la fecha de modificación del archivo ya existente — no hay que crear nada extra.

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

4. Implementa los 6 TODOs del `Makefile`:
   - **TODO 1:** target `node_modules/.installed` con dependencias `package.json` y `pnpm-lock.yaml`; receta: `pnpm install --frozen-lockfile`, `mkdir -p $(@D)` y `touch $@`
   - **TODO 2:** target `install` como alias del sentinel
   - **TODO 3:** target `build` que dependa de `install` y ejecute `pnpm run build`
   - **TODO 4:** target `test` que dependa de `install` y ejecute `pnpm test`
   - **TODO 5:** target `lint` que dependa de `install` y ejecute `pnpm run lint`
   - **TODO 6:** target `clean` que elimine `node_modules/` y `dist/`

5. Verifica:
   ```bash
   make install
   make test
   make build
   make clean
   make install   # segunda vez: no debe reinstalar
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
