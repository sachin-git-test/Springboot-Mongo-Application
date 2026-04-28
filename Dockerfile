# -------- Stage 1: Build --------
FROM maven:3.8.8 as Build
# Copy source code
COPY . .

# Build WAR
RUN mvn clean package


# -------- Stage 1: Build --------
FROM eclipse-temurin:8-jdk-alpine

MAINTAINER Sachin

RUN apk update && apk add /bin/sh

RUN mkdir -p /opt/application

ENV PROJECT_HOME /opt/application

COPY --from=Build target/spring-boot-mongo-1.0.jar $PROJECT_HOME/spring-boot-mongo.jar

WORKDIR $PROJECT_HOME

EXPOSE 8080

CMD ["java", "-jar", "./spring-boot-mongo.jar"]
