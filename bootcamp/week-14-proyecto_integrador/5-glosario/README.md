# Glosario — Semana 14

Semana integradora: estos términos nombran cómo encajan las piezas de semanas
anteriores. Para cada técnica concreta, consulta el glosario de su semana.

| Término | Definición en una línea | Ejemplo en Makefile |
|---------|------------------------|---------------------|
| Build system | Conjunto de reglas que transforma fuentes en artefactos desplegables desde un único punto de entrada | El Makefile raíz que orquesta backend, frontend e infra |
| Orquestador | Makefile que coordina sub-makes sin conocer cómo construye cada servicio | `$(SERVICE_TARGETS):` con `$(MAKE) -C $(@D) $(@F)` |
| Meta por servicio | Target phony `servicio/meta` que convierte cada sub-make en un nodo del grafo | `make infra/test`, `make backend/ci` |
| Módulo compartido | Archivo `.mk` sin efectos al importarse, con valores por defecto en `?=`, reutilizado por varios servicios | `include ../shared-mk/python.mk` |
| Módulo de lenguaje | Módulo que aporta las dependencias y los comandos de un stack concreto a metas genéricas | `python.mk` define `LINT_CMD` y `TEST_CMD`; `ci.mk` los ejecuta |
| Pipeline | Secuencia de etapas donde el fallo de una detiene las siguientes | `ci: lint test build` |
| Fallo rápido (fail fast) | Abortar en cuanto aparece el primer error, y que el código de salida llegue hasta la raíz | `make ci FAIL=backend` sale con 2 sin tocar frontend |
| Inyección de fallo | Variable que fuerza un fallo controlado para comprobar que el pipeline lo propaga | `FAIL ?=` en `test.mk`; `make ci FAIL=backend` |
| Stub de herramienta | Sustituir un comando externo por `:` para ejecutar el pipeline sin red | `make ci UV=: PNPM=:` |
| Condición de carrera | Dos recetas en paralelo que leen o escriben lo mismo sin una dependencia declarada | `frontend.out` lee `backend.out` y solo funciona sin `-j` |
| Guardia | Comprobación que aborta antes de una acción peligrosa o irreversible | `ENV=production` sin `CONFIRM=yes` llama a `$(error)` |
| Idempotente | Target que deja el mismo estado tanto si se ejecuta una vez como diez | `make deps` dos veces: la segunda no hace nada |
| Paridad local/CI | El mismo comando produce el mismo resultado en el portátil y en el runner | Hook, workflow y desarrollador ejecutan `make ci` |
