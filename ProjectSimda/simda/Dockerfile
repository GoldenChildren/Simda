FROM openjdk:8
ARG JAR_FILE=build/libs/*.jar
RUN useradd -ms /bin/bash myuser
COPY ${JAR_FILE} app.jar
ENTRYPOINT ["java", "-jar", "/app.jar"]