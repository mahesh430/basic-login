FROM maven:3.8-jdk-11 as builder

RUN mkdir /opt/app

COPY . /opt/app/

#CMD ["/bin/bash"]

RUN cd /opt/app \
    && mvn clean package

FROM openjdk:11.0.4-jre-slim

ENV APP_HOME /opt/app

COPY --from=builder /opt/app/target/*.jar ${APP_HOME}/app.jar

EXPOSE 8080

WORKDIR ${APP_HOME}

CMD exec java -jar app.jar
