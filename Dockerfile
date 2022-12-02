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