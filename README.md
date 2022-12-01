

## Del 2 - CI
### Oppgave 1
Jeg var litt usikker på ordvalget her, men tolket det som at workflowen skal kjøre på push til main, og på ALLE pull requester i repoet.
Det gjøres ved å legge til følgende i workflowen:
```yaml
on:
  push:
    branches: [ main ]
  pull_request:
    branches:
      - '**'
```

### Oppgave 2
Her var feilen at kommandoen ```mvn compile``` ble brukt. Compile tar kun og kompilerer koden, og kjører ikke tester
Etter å ha byttet til ```mvn test``` fungerer det som det skal, og workflowen feiler fordi tester ikke er riktig. Etter å ha endret testen til å anta at antallet carts er 0 etter checkout, passerer testen
For å få workflowen til å kjøre på push til alle branches, kan vi bruke samme filter som i oppgave 1
```yaml
on:
  push:
    branches:
      - '**'
```
### Oppgave 3

