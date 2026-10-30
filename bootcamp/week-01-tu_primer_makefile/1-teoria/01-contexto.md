# Contexto — Tu primer Makefile

## ¿Por qué importa esto?

Make existe para no repetir comandos a mano. Si cada vez que cambias un archivo tienes que recordar qué compilar, qué copiar y en qué orden, estás acumulando deuda cognitiva. Un Makefile documenta y automatiza ese proceso. Cuando sepas leer y escribir Makefiles, entenderás el 80% de los sistemas de build que vas a encontrar en proyectos reales.

## Anatomía de una regla

```makefile
target: dependencia1 dependencia2
	receta
```

- **target**: nombre del artefacto a producir, o nombre de la acción
- **dependencias**: qué debe existir (o ejecutarse) antes de la receta
- **receta**: comandos de shell — **obligatoriamente con TAB, nunca espacios**

```makefile
# Ejemplo funcional — copia y pega esto en un Makefile y ejecuta `make`
.PHONY: all saludar limpiar

.DEFAULT_GOAL := saludar

saludar:
	@echo "Hola desde Make"
	@echo "Fecha: $(shell date +%F)"

limpiar: saludar
	@echo "Dependencia ejecutada primero, luego esto"
```

## Referencia rápida

| Concepto | Sintaxis | Qué hace |
|----------|----------|----------|
| Target simple | `nombre:` | Define una acción |
| Con dependencia | `nombre: otro` | Ejecuta `otro` antes de `nombre` |
| Receta | `<TAB>comando` | Comando de shell a ejecutar |
| Silenciar output | `@comando` | No imprime el comando, solo su output |
| Target PHONY | `.PHONY: nombre` | Declara que `nombre` no produce un archivo |
| Goal por defecto | `.DEFAULT_GOAL := nombre` | Target que se ejecuta con `make` sin args |
| Variable de shell | `$(shell cmd)` | Captura output de un comando |

## El error #1: espacios en lugar de TABs

```
Makefile:3: *** missing separator.  Stop.
```

Este error significa que usaste espacios donde Make exige un TAB. Configura tu editor para mostrar whitespace.

## Qué observar cuando ejecutes el ejemplo

- `make` sin argumentos ejecuta `saludar` (el `.DEFAULT_GOAL`)
- `make limpiar` ejecuta `saludar` primero (dependencia), luego `limpiar`
- `make limpiar` de nuevo: ejecuta todo otra vez (es PHONY, siempre corre)
- El `@` delante de `echo` suprime la línea `echo "..."` del output

---

Sigue con [02-instalacion-y-version.md](02-instalacion-y-version.md) y después ve al [lab-01](../2-practicas/lab-01-primer-target/README.md).
