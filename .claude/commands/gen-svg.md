# /gen-svg

Dibuja un diagrama SVG para una semana con la paleta y las reglas del repositorio.

## Uso

```
/gen-svg <semana-carpeta> <NN-nombre.svg> "<qué tiene que mostrar>"
```

**Ejemplo:**
```
/gen-svg week-04-variables_automaticas 01-flujo-compilacion-c.svg "de .c a .o a app: qué regla produce cada archivo"
```

---

## Instrucciones para Claude

Lee `CLAUDE.md` § 0-assets: paleta y reglas duras viven ahí, no se duplican aquí.

### Antes de dibujar: ¿hace falta?

Un diagrama vale la pena cuando muestra algo que el texto no puede: un grafo de dependencias, una secuencia temporal (parse vs. ejecución), un flujo con ramas, dos cosas en la misma escala (serie vs. `-j`).

No lo hagas si es una lista con cajas alrededor, una tabla dibujada o repite el bloque de código de al lado.

### Procedimiento

1. Escribe `bootcamp/<semana>/0-assets/<NN-nombre>.svg` a partir del esqueleto.
2. Colores con significado, siempre el mismo en todo el bootcamp: naranja `#f78166` el target / elemento principal, azul los prerrequisitos y el flujo, verde lo que está al día o sale bien, amarillo lo que se rehace o avisa, rojo el error o el peligro, morado lo secundario.
3. Flechas con un `<marker>` definido en `<defs>`; nada de caracteres `→` como flecha.
4. Código Make en monoespaciada; prosa en sans-serif. Ningún texto < 12 px. Escapa `&`, `<` y `>` (`&amp;`, `&lt;`, `&gt;`).
5. Enlázalo desde el archivo de `1-teoria/` donde aparece el concepto, junto al párrafo que lo explica:
   `![Descripción de lo que muestra el diagrama](../0-assets/NN-nombre.svg)`. Alt corto: cuenta como prosa en el límite de 600 palabras.
6. `./scripts/verificar-enlaces.sh` en verde.

### Esqueleto

```svg
<svg viewBox="0 0 800 400" role="img" xmlns="http://www.w3.org/2000/svg">
  <title>Make compara fechas: app se rehace porque main.o es más nuevo</title>
  <defs>
    <marker id="arrow" viewBox="0 0 10 10" refX="9" refY="5"
            markerWidth="8" markerHeight="8" orient="auto-start-reverse">
      <path d="M0,0 L10,5 L0,10 z" fill="#8b949e"/>
    </marker>
  </defs>
  <rect width="800" height="400" fill="#0d1117"/>

  <g font-family="Inter, system-ui, -apple-system, sans-serif" font-size="14">
    <rect x="40" y="40" width="180" height="60" rx="6"
          fill="#161b22" stroke="#f78166" stroke-width="2"/>
    <text x="130" y="76" fill="#f0f6fc" text-anchor="middle"
          font-family="ui-monospace, SFMono-Regular, Menlo, monospace">app</text>

    <line x1="220" y1="70" x2="330" y2="70" stroke="#8b949e"
          stroke-width="2" marker-end="url(#arrow)"/>
  </g>
</svg>
```
