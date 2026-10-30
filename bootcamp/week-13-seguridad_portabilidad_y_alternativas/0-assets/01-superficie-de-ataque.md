# Superficie de ataque de un Makefile

```mermaid
flowchart LR
    CLI["Línea de comandos<br/>VERSION=$TAG BRANCH=$RAMA"] --> MAKE
    ENV["Entorno del CI<br/>TOKEN, GITHUB_REF_NAME"] --> MAKE
    DOTENV[".env<br/>(include)"] -->|"se parsea como Makefile"| MAKE
    NET["URL remota<br/>(curl | sh)"] -->|"código sin revisar"| SH

    MAKE["Make<br/>expande $(...)"] -->|"bash -c 'línea expandida'"| SH["bash<br/>interpreta ' ; ` $( )"]

    SH --> PS["ps / argv<br/>(otros usuarios)"]
    SH --> LOG["make -n y log del CI"]
    SH --> FS["Disco<br/>umask, rm -rf"]
    MAKE -->|"export a secas"| TOOLS["Subprocesos<br/>pnpm, docker, linters"]

    style DOTENV fill:#f8d7da,stroke:#721c24
    style NET fill:#f8d7da,stroke:#721c24
    style PS fill:#fff3cd,stroke:#856404
    style LOG fill:#fff3cd,stroke:#856404
```

Todo lo que entra por la izquierda lo controla otra persona: quien crea el tag, la rama, el `.env` o el servidor de descargas. Atraviesa dos intérpretes (Make y bash) antes de ejecutarse, y cada salida de la derecha es un sitio donde un secreto puede quedar a la vista. Las defensas de la semana cortan una flecha cada una.
