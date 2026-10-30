# Webgrafía — Semana 10

| Recurso | Descripción |
|---------|-------------|
| [GNU Make Manual: Parallel Execution](https://www.gnu.org/software/make/manual/html_node/Parallel.html) | Documentación oficial de `-j`, `-l`, `.NOTPARALLEL` y `.WAIT`, con sus subsecciones |
| [GNU Make Manual: Output During Parallel Execution](https://www.gnu.org/software/make/manual/html_node/Parallel-Output.html) | Los modos de `--output-sync` (`line`, `target`, `recurse`) y su efecto sobre herramientas que detectan la terminal |
| [GNU Make Manual: Recursive Use of make](https://www.gnu.org/software/make/manual/html_node/Recursion.html) | `$(MAKE)`, `-C`, qué variables y opciones pasan a un sub-make (`MAKEFLAGS`, `export`, `MAKELEVEL`) |
| [GNU Make Manual: Sharing Job Slots](https://www.gnu.org/software/make/manual/html_node/Job-Slots.html) | Cómo funciona el jobserver por dentro (tubería o FIFO con nombre) y cómo otras herramientas pueden participar |
| [New make --shuffle mode](https://trofi.github.io/posts/238-new-make-shuffle-mode.html) | Artículo del autor de `--shuffle` (Make 4.4): por qué existe, cómo reproducir una semilla y los bugs que destapó en paquetes reales |
| [For A Parallel World. Case Study n.4: jobserver unavailable](https://flameeyes.blog/2008/11/16/for-a-parallel-world-case-study-n-4-jobserver-unavailable/) | Caso real del aviso `jobserver unavailable` y por qué aparece cuando el sub-make se esconde en una variable |
