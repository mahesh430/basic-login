FROM openjdk:11.0.4-jre-slim

ENV APP_HOME /opt/app

COPY target/*.jar ${APP_HOME}/app.jar

EXPOSE 8080
#EXPOSE 9100

WORKDIR ${APP_HOME}

CMD exec java -jar app.jar
#CMD exec java -javaagent:/opt/jmx/jmx_prometheus_javaagent-0.16.1.jar=9100:/opt/jmx/config.yml -jar app.jar

# java -javaagent:/opt/jmx/jmx_prometheus_javaagent-0.16.1.jar=9100:/opt/jmx/config.yml -jar app.jar
