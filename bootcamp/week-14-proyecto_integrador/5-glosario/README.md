# Glosario — Semana 14

| Término | Definición en una línea | Ejemplo en Makefile |
|---------|------------------------|---------------------|
| Build system | Conjunto de reglas y herramientas que automatizan la transformación de fuentes en artefactos desplegables | El Makefile raíz que orquesta backend, frontend e infra |
| Stamp file | Archivo vacío usado como marcador de tiempo para que Make rastree tareas sin artefacto natural | `.stamps/deps: pyproject.toml uv.lock` → `touch $@` |
| Pipeline | Secuencia de etapas ordenadas donde el fallo en una detiene las siguientes | `ci: lint test build-image` |
| Fallo rápido (fail fast) | Principio de abortar el pipeline en cuanto detecta el primer error | Make detiene la ejecución si cualquier receta devuelve código ≠ 0 |
| Orquestador | Target o Makefile que coordina la ejecución de submakes sin conocer su implementación interna | Makefile raíz con `$(MAKE) -C backend ci` |
| Condición de carrera | Error que ocurre cuando dos targets paralelos acceden al mismo recurso sin dependencia declarada | `make -j2 all` cuando `test` lee archivos que `build` aún no creó |
| Módulo Make | Archivo `.mk` con targets reutilizables, sin efectos secundarios al ser importado | `include shared-mk/deploy.mk` en múltiples proyectos |
| Guard (guardia) | Condicional que aborta la ejecución si una variable no tiene el valor requerido | `ifneq ($(CI), true)` → `$(error push solo en CI)` |
| `-include` | Versión tolerante de `include` que no falla si el archivo no existe | `-include .env` para variables de entorno opcionales |
| Paralelismo Make | Ejecución simultánea de targets independientes con la flag `-j N` | `make -j4 all` |
| `.env` | Archivo de variables de entorno que Make puede cargar con `-include .env` | Variables secretas o de configuración local |
| Git hook | Script que git ejecuta en eventos del repositorio (commit, push) | `.git/hooks/pre-commit` invoca `make check` |
| Dependencia automática | Archivo `.d` generado por `gcc -MMD` que describe qué headers incluye cada `.c` | `-include $(DEPS)` carga todos los `.d` del proyecto |
| `$(MAKE)` | Variable especial que referencia el ejecutable Make actual, preservando flags del padre | `$(MAKE) -C backend build` en lugar de `make -C backend build` |
| Idempotente | Propiedad de un target que produce el mismo resultado si se ejecuta una o diez veces | `make deploy` en el mismo estado debe tener el mismo efecto |
