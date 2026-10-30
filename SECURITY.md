# Política de Seguridad

## Versiónes Soportadas

| Versión | Soportada |
| ------- | --------- |
| main    | Sí        |

## Reportar una vulnerabilidad

Si descubres una vulnerabilidad de seguridad en este material o en los scripts del repositorio, te pedimos que la reportes de manera responsable.

### NO hacer público el reporte

Por favor, **NO** abras un issue público para reportar vulnerabilidades de seguridad.

### Cómo reportar

1. **Abre un Security Advisory privado** en GitHub:
   - Ve a la pestaña "Security" del repositorio
   - Haz clic en "Report a vulnerability"
   - Completa el formulario con los detalles

2. **Incluye en tu reporte**:
   - Descripción detallada de la vulnerabilidad
   - Pasos para reproducir el problema
   - Impacto potencial
   - Sugerencias de solución (si las tienes)

### Tiempo de respuesta

- **Confirmación inicial**: 48 horas
- **Evaluación**: 7 días
- **Resolución**: Dependiendo de la severidad

---

## Qué se considera vulnerabilidad en este repositorio

Este es material educativo, no un servicio en producción. Cuentan como vulnerabilidad:

- **Un secreto real comiteado** en cualquier archivo del repositorio.
- **Un ejemplo que enseña un antipatrón sin marcarlo como tal** y que un alumno copiaría a producción: un bucle recursivo que se traga los fallos, `export` de todas las variables, un `.env` sin ignorar.
- **Un Makefile o script de `scripts/` con inyección de comandos**, escalada de privilegios o borrado fuera de su directorio.
- **Una imagen Docker sin versión fijada** o que corre como root sin justificación.

## Prácticas de seguridad que enseña este bootcamp

### Una receta que falla tiene que detener el build

```makefile
SHELL       := bash
.SHELLFLAGS := -eu -o pipefail -c
.DELETE_ON_ERROR:
```

Sin `pipefail`, `cmd | tee log` sale con 0 aunque `cmd` falle. Sin `.DELETE_ON_ERROR`, un target a medio escribir queda en disco y Make lo da por bueno en la siguiente ejecución.

### La recursión no se hace con bucles `for`

```makefile
# ANTIPATRÓN: el código de salida es el del último servicio; un fallo previo se pierde
ci:
	for s in $(SERVICES); do $(MAKE) -C $$s ci; done

# CORRECTO: cada subdirectorio es un target; un fallo detiene el build y -j funciona
ci: $(SERVICES)
$(SERVICES):
	$(MAKE) -C $@ ci
.PHONY: ci $(SERVICES)
```

### Los secretos no se exportan en bloque ni se imprimen

```makefile
# ANTIPATRÓN: todas las variables, secretos incluidos, llegan a cada subproceso
export

# CORRECTO: solo lo que la receta necesita
export DATABASE_URL
```

Un `.env` incluido con `include` se parsea como Makefile: `$` se expande y `$(shell ...)` se ejecuta. Nunca incluyas un `.env` que no controles. Todos los `.env*` (salvo `.env.example`) van en `.gitignore`.

### `rm -rf` siempre con guarda

```makefile
clean:
	$(if $(BUILD_DIR),,$(error BUILD_DIR vacía: rm -rf no se ejecuta))
	rm -rf -- '$(BUILD_DIR)'
```

### Los git hooks son una ayuda, no un control

`git commit --no-verify` los salta. La verificación que importa corre también en CI.

## Dependencias

Este bootcamp referencia:

- GNU Make >= 4.3 (ver [`docs/stack-versions.md`](docs/stack-versions.md))
- bash, jq y shellcheck para los scripts de verificación
- Docker, Python y Node.js a partir de la semana 11, con versiones fijadas; Python siempre con uv y Node.js siempre con pnpm

---

Gracias por ayudar a mantener este proyecto seguro.
