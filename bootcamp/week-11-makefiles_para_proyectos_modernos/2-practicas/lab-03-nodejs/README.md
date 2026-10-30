# Lab 03 — Node.js con Make

**Duración estimada:** 50 minutos

**Requisitos:** Node.js 18+ y npm

## Objetivo

Envolver el ciclo de vida de un proyecto Node.js (install, build, test, lint) en un Makefile, usando `node_modules/` como sentinel file para evitar reinstalaciones innecesarias.

## Contexto

El patrón de sentinel file para Node.js es diferente al de Python: en lugar de crear un archivo `.installed`, usamos `node_modules/.package-lock.json` (generado automáticamente por `npm install`) como el testigo. Si `package.json` cambia, este archivo es más antiguo y Make reinstala.

```makefile
node_modules/.package-lock.json: package.json
	npm install
	@touch $@
```

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
   - **TODO 1:** target `node_modules/.package-lock.json` con dependencia `package.json`; receta: `npm install && touch $@`
   - **TODO 2:** target `install` como alias del sentinel
   - **TODO 3:** target `build` que dependa de `install` y ejecute `npm run build`
   - **TODO 4:** target `test` que dependa de `install` y ejecute `npm test`
   - **TODO 5:** target `lint` que dependa de `install` y ejecute `npm run lint`
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
npm install
...added XX packages in Xs

$ make install   # segunda ejecución
make: 'node_modules/.package-lock.json' is up to date.
```

```
$ make test
node tests/test.js
PASS: saludar retorna saludo correcto
Todos los tests pasaron.
```

```
$ make build
npm run build
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

Agrega un target `dev` que ejecute `npm run dev` (modo watch). Asegúrate de que esté en `.PHONY` y que el proceso pueda interrumpirse con Ctrl+C sin dejar la terminal en mal estado.
