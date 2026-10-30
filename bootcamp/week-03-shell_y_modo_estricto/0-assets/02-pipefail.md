# Código de salida de una tubería, con y sin pipefail

```mermaid
flowchart LR
    A["awk (valida)<br/>exit 1: línea corrupta"] --> B["sort<br/>exit 0"] --> C["uniq -c<br/>exit 0"] --> D["> build/status.txt<br/>archivo a medias"]
    C -.->|"sin pipefail: exit 0<br/>(el de la última etapa)"| E["Make: OK ✅<br/>reporte incompleto"]
    C -.->|"con -o pipefail: exit 1<br/>(la última etapa que falló)"| F["Make: Error 1 ❌<br/>.DELETE_ON_ERROR borra el archivo"]
```

Sin `pipefail`, el código de una tubería es el de su última etapa: el fallo de `awk` desaparece detrás de `sort` y `uniq`. Con `-o pipefail`, cualquier etapa que falle hace fallar la línea. Dos excepciones que hay que tratar a propósito: `grep` sin coincidencias (exit 1) y el productor que muere con SIGPIPE (141) cuando `head` cierra la tubería.
