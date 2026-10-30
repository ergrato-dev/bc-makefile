# Webgrafía — Semana 06: Dependencias automáticas y targets especiales

| Recurso | Descripción |
|---------|-------------|
| [GNU Make — Types of Prerequisites](https://www.gnu.org/software/make/manual/html_node/Prerequisite-Types.html) | Prerrequisitos normales frente a order-only, con el ejemplo del directorio de salida |
| [GNU Make — Multiple Targets in a Rule](https://www.gnu.org/software/make/manual/html_node/Multiple-Targets.html) | Targets independientes frente a grouped targets (`&:`), y por qué la diferencia importa con `-j` |
| [GNU Make — Special Built-in Target Names](https://www.gnu.org/software/make/manual/html_node/Special-Targets.html) | `.SECONDARY`, `.PRECIOUS`, `.INTERMEDIATE`, `.NOTINTERMEDIATE`, `.SECONDEXPANSION` y el resto |
| [Advanced Auto-Dependency Generation (Paul D. Smith)](https://make.mad-scientist.net/papers/advanced-auto-dependency-generation/) | El artículo de referencia del mantenedor de GNU Make sobre `.d`, `-MMD -MP` y sus casos límite |
| [How Not to Use VPATH (Paul D. Smith)](https://make.mad-scientist.net/papers/how-not-to-use-vpath/) | Por qué `vpath` es para fuentes y no para targets: la trampa del lab 03 explicada a fondo |
