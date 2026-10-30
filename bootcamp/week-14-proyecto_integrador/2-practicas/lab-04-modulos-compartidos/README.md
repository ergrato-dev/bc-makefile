# Lab 04 — Librería de Módulos Make Compartidos

⏱ Duración estimada: ~60 min

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

Cada servicio define solo sus variables (`APP_NAME`, `IMAGE_NAME`) e importa los módulos (semana 09). La restricción clave: los módulos no deben producir efectos secundarios al importarse — solo definen targets y variables con `?=`.

Encima de los servicios va un Makefile raíz que los orquesta como en la semana 10: un target phony por servicio y meta (`service-a/test`) cuya receta es `$(MAKE) -C`. Así un fallo detiene el build, `-k` sigue con el resto y `-j` reparte el trabajo con un único jobserver.

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
   # Debe imprimir: [service-b] Build 2.3.1
   ```

4. Implementa `shared-mk/test.mk` con target `test`:
   ```bash
   make -C service-a test
   make -C service-b test
   ```

5. Implementa `shared-mk/docker.mk` con target `build-image` (con `-n` no necesitas Docker):
   ```bash
   make -C service-a -n build-image
   # Debe mostrar: docker build --tag service-a:1.0.0 .
   ```

6. Verifica que cambiar un módulo afecta ambos servicios:
   ```bash
   # Modifica el mensaje en shared-mk/build.mk
   make -C service-a build  # refleja el cambio
   make -C service-b build  # también refleja el cambio
   ```

7. Completa el `Makefile` raíz (TODO 1 a 3) y ejecútalo:
   ```bash
   make all
   make test
   ```
   Debes ver los dos `Build` y los dos `✓ Todos los tests pasaron`.

8. Añade a `test.mk` la inyección de fallos `FAIL=<servicio>` (pista en el
   módulo) y comprueba que el fallo se propaga:
   ```bash
   make test FAIL=service-a; echo "exit=$?"
   ```
   Debe terminar con `make: *** [Makefile:NN: service-a/test] Error 2`,
   `exit=2`, y `service-b` no se ejecuta. Con `make -k test FAIL=service-a`
   sí se ejecuta `service-b`, pero la salida sigue siendo `exit=2` y termina
   con `make: Target 'test' not remade because of errors.`

9. Compara con el antipatrón. Añade temporalmente este target y ejecútalo:
   ```makefile
   test-for:
   	for s in $(SERVICES); do $(MAKE) -C $$s test; done
   ```
   ```bash
   make test-for FAIL=service-a; echo "exit=$?"
   ```
   Con el modo estricto el bucle se detiene en `service-a` y sale con
   `exit=2`. Cambia un momento `.SHELLFLAGS := -c` y repite: `service-b` se
   ejecuta, el bucle devuelve el código del último servicio y verás `exit=0`
   con un test roto. Aun con `-e`, el bucle es una sola receta: `-j` no
   puede repartir los servicios y `-k` no puede seguir con el siguiente.
   Restaura `.SHELLFLAGS` y borra `test-for`.

10. Construye en paralelo y confirma que no hay avisos de jobserver:
    ```bash
    make -j2 all 2>&1 | grep -c jobserver   # 0
    ```

## Criterios de éxito

- [ ] `make -C service-a build` → `[service-a] Build 1.0.0`
- [ ] `make -C service-b build` → `[service-b] Build 2.3.1` (cada servicio conserva su `VERSION` aunque el módulo declare `VERSION ?= 1.0.0`)
- [ ] `make -C service-a test` y `make -C service-b test` funcionan
- [ ] Los módulos no producen output al ser importados (sin `$(info)` en el nivel raíz de los `.mk`)
- [ ] Las variables en los módulos usan `?=` para permitir override desde el Makefile importador
- [ ] `make -C service-a help` lista todos los targets de los módulos importados
- [ ] `make test FAIL=service-a` sale con código 2 sin ejecutar `service-b`; con `-k` ejecuta `service-b` y sigue saliendo con 2
- [ ] El Makefile raíz no contiene ningún bucle `for` con `$(MAKE)`
- [ ] `make -j2 all` no imprime avisos de jobserver

## Reto extra

Haz los `include` independientes del directorio desde el que se invoca Make: calcula la ruta del módulo a partir de `$(lastword $(MAKEFILE_LIST))` y comprueba que `make -f service-a/Makefile build` funciona desde la raíz del lab.
