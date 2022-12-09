

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
Etter å ha byttet til ```mvn test``` fungerer det som det skal, og workflowen feiler fordi testen ikke er riktig. Etter å ha endret testen til å anta at antallet carts er 0 etter checkout, passerer testen.

For å få workflowen til å kjøre på push til alle branches, kan vi bruke samme filter som i oppgave 1
```yaml
on:
  push:
    branches:
      - '**'
```
### Oppgave 3
For å konfigurere branch protection går man til
- Settings
- Branches
- Add branch protection rule

I feltet som heter Branch name pattern må man definere hvilke branches disse reglene gjelder for. Det defineres med fnmatch syntax
I dette tilfelle holder det å bruke ```main```
For at man ikke skal kunne pushe kode direkete til main, kan man huke av valget som heter ```Require pull request reviews before merging```. Rett under dette valget kan man også bestemme hvor mange godkjenninger man trenger før pull requesten kan merges.
For at kode kun skal kunne merges når Github actions har blitt kjørt, kan man huke av valget ```Require status checks to pass before merging``` og legge til de jobbene man krever at skal være gjennomført

## Del 3 - Docker
### Oppgave 1
Feilen er at workflowen trenger brukernavn og passordtoken lagret som github secrets for å kunne pushe til dockerhub. For å generere en token må du gå til Account Settings -> Security -> New access token. Etter å ha lagt til disse secretsene kjører workflowen, og jeg kan se at imaget er lastet opp i Dockerhub

### Oppgave 2
Jeg har endret slik at workflowen ikke har noe med java å gjøre, men bare bygger docker imaget, og pusher det til Dockerhub.
Dockerfilen er endret slik at den først kompilerer prosjektet, og deretter bygger imaget. Jeg valgte også å manuelt eksponere port 8080

Dockerfilen ser nå slik ut:
```dockerfile
# Stage 1: Bygg applikasjonen
FROM maven:3.6.3-jdk-11-slim AS build
WORKDIR /app
COPY pom.xml .
COPY src ./src
RUN mvn package -DskipTests

# Stage 2: Kjør applikasjonen
FROM openjdk:11-jre-slim
WORKDIR /app
COPY --from=build /app/target/onlinestore-0.0.1-SNAPSHOT.jar application.jar
EXPOSE 8080
ENTRYPOINT ["java","-jar","application.jar"]
```

## Oppgave 3
For at sensor skal kunne kjøre dette i sin fork, er hen først nødt til å generere access key og secret access key.
For å gjøre det må man først finne brukeren sin i IAM interfacet i AWS. Deretter må man inn i "Security credentials" fanen og trykke "Create Access Key"
Så må man sette inn nøklene man får inn i Github Secrets, under navnene AWS_ACCESS_KEY_ID og AWS_SECRET_ACCESS_KEY. AWS_ECR_REPO må også settes til navnet på repoet man vil pushe til
Jeg satt opp slik at taggen til imaget blir hashen til commiten, og også at imaget blir tagget som latest


## Del 4 - Metrics, overvåkning og alarmer


## Del 5 - Terraform og CloudWatch Dashboards
### Oppgave 1
Feilen som konsulentene i Gaffel har gjort er at de ikke lagrer/bruker statefilen som terraform oppretter. 

Om man legger til denne kodesnutten i provider.tf filen, så vil terraform lagre/bruke en statefil som lagres i en S3 bucket(som jeg manuelt laget i AWS)
```terraform
terraform {
  backend "s3" {
    bucket = "1014-statefile"
    key    = "shopifly.state"
    region = "eu-west-1"
  }
}
```

Om man ikke definerer dette, så vil statefilen opprettes i VMet som GitHub actions spinner opp, og vil dermed bli slettet når VMet ikke trengs lenger.
Neste gang Terraform kjøres, vet den ikke hva som har blitt gjort fra før, og vil dermed prøve å opprette alt på nytt. 
Det er derfor Gaffel får feilmeldingen at bucketen finnes fra før.

### Oppgave 2
Jeg gjorde to endringer i workflow filen:

Jeg definerte at jobben kun skal kjøres på push og pullrequest til main branchen. Jeg beholdt også den manuelle kjøringen
```yaml
on:
  pull_request:
    branches: [ main ]
  push:
    branches: [ main ]
  workflow_dispatch:
    branches: [ main ]
```

For å bestemme om man skal kjøre plan eller apply har jeg brukt en if-setning som sjekker om det er en pull request eller ikke.
```yaml
      - name: Terraform Plan
        id: plan
        if: github.event_name == 'pull_request'
        run: terraform plan  -var="candidate_id=$CANDIDATE_ID" -var="candidate_email=$CANDIDATE_EMAIL" -no-color
        continue-on-error: false
```
Det er også en tilsvarende for apply, som kun kjøres på push

### Oppgave 3

