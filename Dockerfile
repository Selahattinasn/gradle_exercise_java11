FROM openjdk:17-alpine
WORKDIR /temporary
COPY build/libs/containertest-0.0.1-SNAPSHOT.jar .
EXPOSE 8080
CMD  ["java","-jar", "./containertest-0.0.1-SNAPSHOT.jar"]