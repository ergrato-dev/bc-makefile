# Politica de Seguridad

## Versiones Soportadas

| Version | Soportada |
| ------- | --------- |
| main    | Si        |

## Reportar una Vulnerabilidad

Si descubres una vulnerabilidad de seguridad en este material o en los scripts del repositorio, te pedimos que la reportes de manera responsable.

### NO hacer publico el reporte

Por favor, **NO** abras un issue publico para reportar vulnerabilidades de seguridad.

### Como Reportar

1. **Abre un Security Advisory privado** en GitHub:
   - Ve a la pestana "Security" del repositorio
   - Haz clic en "Report a vulnerability"
   - Completa el formulario con los detalles

2. **Incluye en tu reporte**:
   - Descripcion detallada de la vulnerabilidad
   - Pasos para reproducir el problema
   - Impacto potencial
   - Sugerencias de solucion (si las tienes)

### Tiempo de Respuesta

- **Confirmacion inicial**: 48 horas
- **Evaluacion**: 7 dias
- **Resolucion**: Dependiendo de la severidad

---

## Que se considera vulnerabilidad en este repositorio

Este es material educativo, no un servicio en produccion. Cuentan como vulnerabilidad:

- **Un secreto real comiteado** en cualquier archivo del repositorio.
- **Un ejemplo que ensena un antipatron sin marcarlo como tal** y que un alumno copiaria a produccion: un bucle recursivo que se traga los fallos, `export` de todas las variables, un `.env` sin ignorar.
- **Un Makefile o script de `scripts/` con inyeccion de comandos**, escalada de privilegios o borrado fuera de su directorio.
- **Una imagen Docker sin version fijada** o que corre como root sin justificacion.

## Practicas de seguridad que ensena este bootcamp

### Una receta que falla tiene que detener el build

```makefile
SHELL       := bash
.SHELLFLAGS := -eu -o pipefail -c
.DELETE_ON_ERROR:
```

Sin `pipefail`, `cmd | tee log` sale con 0 aunque `cmd` falle. Sin `.DELETE_ON_ERROR`, un target a medio escribir queda en disco y Make lo da por bueno en la siguiente ejecucion.

### La recursion no se hace con bucles `for`

```makefile
# ANTIPATRON: el codigo de salida es el del ultimo servicio; un fallo previo se pierde
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
# ANTIPATRON: todas las variables, secretos incluidos, llegan a cada subproceso
export

# CORRECTO: solo lo que la receta necesita
export DATABASE_URL
```

Un `.env` incluido con `include` se parsea como Makefile: `$` se expande y `$(shell ...)` se ejecuta. Nunca incluyas un `.env` que no controles. Todos los `.env*` (salvo `.env.example`) van en `.gitignore`.

### `rm -rf` siempre con guarda

```makefile
clean:
	$(if $(BUILD_DIR),,$(error BUILD_DIR esta vacio))
	rm -rf -- '$(BUILD_DIR)'
```

### Los git hooks son una ayuda, no un control

`git commit --no-verify` los salta. La verificacion que importa corre tambien en CI.

## Dependencias

Este bootcamp referencia:

- GNU Make >= 4.3 (ver [`docs/stack-versions.md`](docs/stack-versions.md))
- bash, jq y shellcheck para los scripts de verificacion
- Docker, Python y Node.js a partir de la semana 11, con versiones fijadas

---

Gracias por ayudar a mantener este proyecto seguro.
