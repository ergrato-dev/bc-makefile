# Anatomía de una regla de patrón

```mermaid
graph TD
    P["Regla de patrón<br/>%.o: %.c<br/>────────────<br/>$(CC) -c $&lt; -o $@"]
    
    T1["Target solicitado:<br/>main.o"]
    T2["Target solicitado:<br/>calc.o"]
    T3["Target solicitado:<br/>greet.o"]

    S1["stem = main<br/>$&lt; = main.c<br/>$@ = main.o"]
    S2["stem = calc<br/>$&lt; = calc.c<br/>$@ = calc.o"]
    S3["stem = greet<br/>$&lt; = greet.c<br/>$@ = greet.o"]

    P --> T1 --> S1
    P --> T2 --> S2
    P --> T3 --> S3
```

Una sola regla de patrón se instancia una vez por target. El `%` captura el stem (la parte variable) y lo propaga a prerrequisitos y variables automáticas. Sin reglas de patrón, cada `%.o` requeriría su propia regla explícita.
