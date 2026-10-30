# Instalación y versión de GNU Make

## ¿Por qué importa esto?

"Make" no es un único programa. Existen GNU Make, BSD make y versiones de GNU
Make con casi veinte años de diferencia. Este bootcamp usa **GNU Make ≥ 4.3**:
con una versión más vieja, ejemplos que aquí funcionan fallan con errores que
parecen tuyos y no lo son. Comprobarlo cuesta un comando; no hacerlo cuesta una
tarde de depuración.

## Comprueba qué tienes

```bash
make --version | head -1
```

| Salida | Qué significa | Qué hacer |
|--------|---------------|-----------|
| `GNU Make 4.3` o `4.4.x` | Listo | Nada |
| `GNU Make 3.81` | El de macOS, de 2006 | Instalar uno actual (abajo) |
| `make: command not found` | No está instalado | Instalarlo (abajo) |
| Sin la palabra `GNU` | BSD make u otro | Instalar GNU Make |

## Instalación por sistema

- **Linux (Ubuntu/Debian):** `sudo apt install -y make build-essential`. Ubuntu
  22.04 y 24.04 traen 4.3; Debian 13 trae 4.4.1.
- **macOS:** `brew install make`. Homebrew lo instala como **`gmake`** para no
  pisar el `make` 3.81 del sistema. O escribes `gmake` en todos los labs, o
  pones su carpeta `gnubin` primero en el `PATH` para que `make` sea el nuevo.
- **Windows:** trabaja dentro de **WSL2** con Ubuntu y sigue los pasos de Linux.
  El `make` de MSYS o Chocolatey cambia la shell y las rutas.

Los comandos exactos, incluida la línea del `PATH` para `gnubin`, están en
[docs/setup-entorno.md](../../../docs/setup-entorno.md).

## Que el Makefile lo compruebe por ti

Make expone su propia versión en la variable `MAKE_VERSION`. Pega esto en un
`Makefile` y ejecuta `make`:

```makefile
.PHONY: check-make
.DEFAULT_GOAL := check-make

## check-make: falla si GNU Make es anterior a 4.3
check-make:
	@echo "Usando GNU Make $(MAKE_VERSION)"
	@printf '%s\n' 4.3 $(MAKE_VERSION) | sort -V -C \
		|| (echo "Error: necesitas GNU Make >= 4.3" && exit 1)
	@echo "Versión OK."
```

Salida con Make 4.3:

```
Usando GNU Make 4.3
Versión OK.
```

`sort -V -C` comprueba que `4.3` y tu versión ya están en orden de versión; si
la tuya es menor, sale con error y Make se detiene. La semana 09 enseña a hacer
esta misma guarda sin salir a la shell.

## `make` y `gmake` dentro de un Makefile

Si una receta necesita llamar a Make otra vez, nunca escribas `make` a mano:
usa `$(MAKE)`, que contiene el binario con el que se lanzó la ejecución actual
(`gmake` en macOS). Lo verás en serio en la semana 10.

## Comandos de diagnóstico que usarás toda la semana

| Comando | Para qué |
|---------|----------|
| `make -n target` | Muestra qué ejecutaría, sin ejecutar nada |
| `make -B target` | Rehace el target aunque esté al día |
| `make -f otro.mk` | Usa otro archivo en lugar de `Makefile` |
| `cat -A Makefile` | Muestra los TAB como `^I`: delata los espacios |

---

Siguiente paso: el [lab-01](../2-practicas/lab-01-primer-target/README.md)
empieza comprobando tu versión.
