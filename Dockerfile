FROM adoptopenjdk/openjdk11:alpine-jre
ARG JAR_FILE=target/spring-boot-web.jar
WORKDIR /opt/app
COPY ${JAR_FILE} spring-boot-web.jar
ENTRYPOINT ["java","-jar","spring-boot-web.jar"]

