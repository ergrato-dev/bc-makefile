# Make como interfaz universal

```mermaid
graph TD
    DEV[Desarrollador] -->|make &lt;target&gt;| MAKE[GNU Make]

    MAKE --> PY[Python / uv / pytest]
    MAKE --> DOC[Docker / docker build]
    MAKE --> PNPM[Node.js / pnpm]
    MAKE --> CMP[docker compose]

    PY --> R1[".venv/ creado<br/>tests ejecutados<br/>linting verificado"]
    DOC --> R2["Imagen construida<br/>Contenedor corriendo<br/>Push al registry"]
    NPM --> R3["node_modules/<br/>Bundle generado<br/>Tests pasados"]
    CMP --> R4["Stack local<br/>Servicios orquestados<br/>Logs centralizados"]

    style MAKE fill:#f5a623,stroke:#d68910,color:#000
```

Make actúa como una capa de abstracción: el desarrollador ejecuta siempre el mismo comando (`make test`, `make build`, `make deploy`) sin necesidad de recordar los flags y subcomandos específicos de cada herramienta. Esta consistencia es especialmente valiosa en equipos y en entornos CI donde cualquier colaborador debe poder ejecutar las mismas operaciones sin documentación adicional.
