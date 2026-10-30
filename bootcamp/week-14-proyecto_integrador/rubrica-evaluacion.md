# Rúbrica de Evaluación — Semana 14

**Total: 100 puntos**

---

## Labs completados (50 pts)

| Lab | Criterio de evaluación | Pts |
|-----|----------------------|-----|
| lab-01-build-c-completo | `make all` compila todos los `.c` a `.o` y enlaza el binario; `make clean` elimina artefactos; solo recompila los `.c` modificados | 10 |
| lab-02-pipeline-python-docker | `make ci` ejecuta lint → test → build-image en orden; cada etapa falla rápido si encuentra errores | 10 |
| lab-03-ci-local | `make hooks-install` instala hooks en `.git/hooks`; el hook pre-commit ejecuta lint y tests automáticamente | 10 |
| lab-04-modulos-compartidos | `make build` funciona en ambos servicios usando los mismos módulos `.mk`; cambiar un módulo afecta a todos los importadores | 10 |
| lab-05-optimizacion-paralela | `make -j4 all` ejecuta en paralelo y reduce el tiempo; `make all` solo recompila los targets desactualizados | 10 |

## Proyecto semanal (30 pts)

| Criterio | Pts |
|----------|-----|
| `make all` desde raíz construye backend, frontend e infra correctamente | 10 |
| `make ci` ejecuta lint + test + build-image de todos los servicios en secuencia | 8 |
| `make ENV=staging deploy` adapta comportamiento para cada entorno; `ENV=production` requiere confirmación | 7 |
| Los módulos `shared-mk/*.mk` son importables en cualquier proyecto nuevo sin modificación | 5 |

## Calidad del Makefile (20 pts)

| Criterio | Pts |
|----------|-----|
| Todos los targets phony declarados en `.PHONY`; ningún target phony produce archivos reales | 5 |
| Target `help` en todos los Makefiles (raíz y submódulos) con documentación `##` | 5 |
| Variables en `UPPER_SNAKE_CASE`; targets en `lower-kebab-case`; TABs correctos (sin espacios) | 5 |
| Módulos `.mk` sin efectos secundarios al importarse; variables con `?=` para permitir override | 5 |
