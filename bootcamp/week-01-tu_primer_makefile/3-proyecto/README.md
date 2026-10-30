# Proyecto Semana 01 — Makefile para sitio estático

⏱ Duración estimada: ~2h 30min

## Contexto

Trabajas en una agencia web pequeña. El equipo mantiene 10 sitios HTML/CSS estáticos. Actualmente el proceso de desarrollo es manual: copian archivos a mano, abren un servidor con un comando que nadie recuerda, y el deploy es un rsync que cada quien ejecuta diferente.

Tu tarea: escribir un `Makefile` que estandarice el flujo completo de desarrollo y despliegue del sitio.

## Estructura del proyecto

```
starter/
├── Makefile          ← aquí trabajas
└── src/
    ├── index.html
    ├── about.html
    └── css/
        └── styles.css
```

Al ejecutar `make build`, debes producir:

```
dist/
├── index.html
├── about.html
└── css/
    └── styles.css
```

## Lo que debes construir

1. **`build`** — crea `dist/` y copia dentro el contenido de `src/` (`cp -r src/. dist/`); ejecutarlo dos veces no debe crear `dist/src/`
2. **`serve`** — inicia un servidor local desde `dist/` con `python3 -m http.server 8080`; imprime la URL antes de arrancar
3. **`clean`** — elimina `dist/` completamente
4. **`check`** — verifica que `dist/index.html` y `dist/about.html` existen y no están vacíos; falla con mensaje claro si algo falta
5. **`deploy`** — simula un deploy: imprime los archivos que se enviarían (usa `find dist/ -type f`) y termina con "Deploy simulado OK"
6. **`help`** — lista todos los targets con descripción usando el patrón `##`

Todos los targets deben declararse en `.PHONY` (excepto los que producen archivos reales, si los hay).

## Verificación

Al terminar, estos comandos deben funcionar sin errores:

```bash
# Desde la carpeta del proyecto (starter/ o tu propia copia)
make help
make build
make check
make deploy
make clean
make build && make serve   # abre http://localhost:8080 en el navegador
```

Output esperado de `make check` cuando todo está bien:
```
Verificando dist/...
  ✓ dist/index.html existe y tiene contenido
  ✓ dist/about.html existe y tiene contenido
Check OK.
```

Output esperado de `make check` cuando `dist/` no existe:
```
Error: dist/index.html no encontrado. Ejecuta 'make build' primero.
make: *** [Makefile:XX: check] Error 1
```

## ✅ Requisitos verificables

Los comprueba `./scripts/verificar-semana.sh 01` desde la raíz del repositorio
(60 de los 100 puntos del Producto). Los otros 40 son de calidad: ver la
[rúbrica](../rubrica-evaluacion.md#-producto-30).

- [ ] make sin argumentos lista los seis targets con su descripción
- [ ] make build copia index.html, about.html y css/styles.css a dist/
- [ ] Ejecutar make build dos veces no anida src/ dentro de dist/
- [ ] Tras make build, make check termina con Check OK.
- [ ] make check sale con error si dist/ no existe
- [ ] make deploy lista los archivos de dist/, incluido dist/css/styles.css
- [ ] make clean elimina dist/ por completo
- [ ] make clean se ejecuta aunque exista un archivo llamado clean

## Entrega

Commit con el mensaje:
```
feat(week-01): proyecto - makefile para sitio estático
```

Archivos a entregar:
- `Makefile` (el tuyo, no el de `starter/`)
- No modifiques los archivos de `src/`
