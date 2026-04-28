# -------- Stage 1: Build --------
FROM ubuntu:latest AS Build

RUN apt update && apt install -y wget tar unzip git

ENV JAVA_HOME=/opt/java-17/jdk-17.0.8+7
ENV MAVEN_HOME=/opt/maven/apache-maven-3.9.15
ENV PATH=$JAVA_HOME/bin:$MAVEN_HOME/bin:$PATH

WORKDIR /opt/installed_apps

# Install Java
RUN wget https://github.com/adoptium/temurin17-binaries/releases/download/jdk-17.0.8+7/OpenJDK17U-jdk_x64_linux_hotspot_17.0.8_7.tar.gz \
 && mkdir -p /opt/java-17 \
 && tar -xvf OpenJDK17U-jdk_x64_linux_hotspot_17.0.8_7.tar.gz -C /opt/java-17

# Install Maven
RUN wget https://dlcdn.apache.org/maven/maven-3/3.9.15/binaries/apache-maven-3.9.15-bin.tar.gz \
 && mkdir -p /opt/maven \
 && tar -xvf apache-maven-3.9.15-bin.tar.gz -C /opt/maven

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
