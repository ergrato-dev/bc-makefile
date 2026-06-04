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

1. **`build`** — copia `src/` a `dist/` con `cp -r`
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

## Rúbrica del proyecto (30 pts)

| Criterio | Pts |
|----------|-----|
| `make build` copia `src/` a `dist/` correctamente | 8 |
| `make clean` elimina `dist/` sin errores | 5 |
| `make check` verifica archivos y falla con mensaje claro | 8 |
| `make help` lista todos los targets con descripción | 5 |
| `make deploy` lista archivos y confirma el deploy simulado | 4 |

## Entrega

Commit con el mensaje:
```
feat(week-01): proyecto - makefile para sitio estático
```

Archivos a entregar:
- `Makefile` (el tuyo, no el de `starter/`)
- No modifiques los archivos de `src/`
