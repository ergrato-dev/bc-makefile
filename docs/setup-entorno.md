# Preparar el entorno

Diez minutos. Al final tendrás GNU Make ≥ 4.3, un compilador de C, jq y el
verificador del bootcamp funcionando.

---

## 1. Linux (Ubuntu / Debian)

```bash
sudo apt update
sudo apt install -y make build-essential jq shellcheck
make --version | head -1
```

Ubuntu 22.04 y 24.04 traen GNU Make 4.3: suficiente. Debian 13 trae 4.4.1.

## 2. Windows

Trabaja **siempre dentro de WSL2** con Ubuntu y sigue el paso 1. No uses el
`make` de MSYS, Cygwin ni Chocolatey: cambian rutas y shell, y los labs asumen
un entorno POSIX.

```powershell
wsl --install -d Ubuntu-24.04
```

## 3. macOS

macOS trae GNU Make **3.81, de 2006**. No sirve: le faltan `$(file)`,
`.ONESHELL`, `--output-sync`, `--trace` y todo lo posterior. Instala uno actual:

```bash
brew install make jq shellcheck
gmake --version | head -1
```

Homebrew lo instala como `gmake` para no pisar el del sistema. Dos opciones:

- Escribir `gmake` en lugar de `make` en todos los labs.
- Ponerlo primero en el `PATH` con el nombre `make`:

```bash
echo 'export PATH="$(brew --prefix)/opt/make/libexec/gnubin:$PATH"' >> ~/.zshrc
exec zsh
make --version | head -1   # GNU Make 4.4.1
```

El compilador de C viene con las Xcode Command Line Tools:

```bash
xcode-select --install
```

## 4. Desde la semana 11

Docker con Compose v2, Python 3.14 con `uv`, y Node.js 26 LTS. Versiones exactas
en [`stack-versions.md`](stack-versions.md).

```bash
docker compose version
python3 --version
uv --version
node --version
```

## 5. Comprobar todo

```bash
git clone https://github.com/ergrato-dev/bc-makefile.git
cd bc-makefile
./scripts/verificar-semana.sh --doctor
```

Todo en ✅ en el bloque **Obligatorio** y estás listo para la semana 01. Lo de
"Desde la semana 11" puede esperar.
