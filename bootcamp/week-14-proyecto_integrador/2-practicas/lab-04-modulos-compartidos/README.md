# Lab 04 — Librería de Módulos Make Compartidos

**Duración estimada:** 50 min

## Objetivo

Crear una librería de módulos `.mk` reutilizables que dos servicios independientes importan con `include`, eliminando duplicación de lógica de build y test.

## Contexto

Cuando dos proyectos tienen el mismo patrón de build (`lint → test → build`), mantener esa lógica duplicada garantiza que divergirá. La solución es extraerla a módulos compartidos:

```
shared-mk/
├── build.mk   # targets: build, clean, package
├── test.mk    # targets: test, coverage
└── docker.mk  # targets: build-image, push
```

Cada servicio define solo sus variables (`APP_NAME`, `IMAGE_NAME`) e importa los módulos. La restricción clave: los módulos no deben producir efectos secundarios al importarse — solo definen targets y variables con `?=`.

## Instrucciones

1. Copia el starter:
   ```bash
   cp -r starter/ mi-lab-04 && cd mi-lab-04
   ```

2. Explora la estructura:
   ```bash
   find . -type f | sort
   ```

3. Implementa `shared-mk/build.mk` con target `build` que use `APP_NAME` y `VERSION`:
   ```bash
   make -C service-a build
   # Debe imprimir: [service-a] Build 1.0.0
   make -C service-b build
   # Debe imprimir: [service-b] Build 1.0.0
   ```

4. Implementa `shared-mk/test.mk` con target `test`:
   ```bash
   make -C service-a test
   make -C service-b test
   ```

5. Implementa `shared-mk/docker.mk` con target `build-image`:
   ```bash
   make -C service-a build-image
   # Debe ejecutar: docker build --tag service-a:dev .
   ```

6. Verifica que cambiar un módulo afecta ambos servicios:
   ```bash
   # Modifica el mensaje en shared-mk/build.mk
   make -C service-a build  # refleja el cambio
   make -C service-b build  # también refleja el cambio
   ```

## Criterios de éxito

- [ ] `make -C service-a build` → `[service-a] Build 1.0.0`
- [ ] `make -C service-b build` → `[service-b] Build 1.0.0`
- [ ] `make -C service-a test` y `make -C service-b test` funcionan
- [ ] Los módulos no producen output al ser importados (sin `$(info)` en el nivel raíz de los `.mk`)
- [ ] Las variables en los módulos usan `?=` para permitir override desde el Makefile importador
- [ ] `make -C service-a help` lista todos los targets de los módulos importados

## Reto extra

Agrega un Makefile raíz que orqueste ambos servicios con `$(MAKE) -C service-a` y `$(MAKE) -C service-b`, exponiendo targets `all`, `test`, `clean` que corren en ambos servicios.
