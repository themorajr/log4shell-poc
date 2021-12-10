FROM maven:3.6.3 AS maven

WORKDIR /usr/src/app
COPY . /usr/src/app

RUN mvn package 
 
FROM openjdk:8u181-jdk-alpine

ARG JAR_FILE=demo-0.0.1-SNAPSHOT.jar

WORKDIR /opt/app

COPY --from=maven /usr/src/app/target/${JAR_FILE} /opt/app/

ENTRYPOINT ["java","-jar","demo-0.0.1-SNAPSHOT.jar"]