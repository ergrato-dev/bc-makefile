# Labs — Semana 06: Dependencias automáticas y targets especiales

| # | Lab | Objetivo | Duración |
|---|-----|----------|----------|
| 01 | [lab-01-anatomia-del-d](lab-01-anatomia-del-d/README.md) | Recompilar exactamente cuando cambian headers, flags o Makefile con `-MMD -MP`, un stamp y `.EXTRA_PREREQS` | ~60 min |
| 02 | [lab-02-order-only](lab-02-order-only/README.md) | Crear directorios de salida sin recompilaciones en cascada con `\|` y `.SECONDEXPANSION` | ~60 min |
| 03 | [lab-03-vpath](lab-03-vpath/README.md) | Compilar fuentes repartidos con `vpath` y reconocer sus dos trampas | ~60 min |
| 04 | [lab-04-grouped-targets](lab-04-grouped-targets/README.md) | Ejecutar un generador de `.c` + `.h` una sola vez con `make -j` usando `&:` | ~60 min |
| 05 | [lab-05-intermedios-y-precious](lab-05-intermedios-y-precious/README.md) | Decidir qué generados se conservan con `.SECONDARY`, `.PRECIOUS`, `.INTERMEDIATE` y `.NOTINTERMEDIATE` | ~60 min |
| 06 | [lab-06-dependencias-rotas](lab-06-dependencias-rotas/README.md) | Depurar cinco bugs de dependencias reproduciendo cada síntoma | ~60 min |

Cada lab tiene `starter/` (donde trabajas) y `solucion/` (referencia). Todos
necesitan solo GNU Make ≥ 4.3, bash y gcc. Al terminar cada uno, `make clean`.
