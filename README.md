

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