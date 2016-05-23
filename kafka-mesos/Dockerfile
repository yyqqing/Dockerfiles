FROM yyqqing/jre8:latest

ENV KAFKA_VERSION=0.9.0.1 KAFKA_SCALA_VERSION=2.11 KAFKA_MESOS_VERSION=0.9.5.1

# Add kafka-mesos & kafka
COPY ./kafka* /opt/kafka-mesos/

WORKDIR /opt/kafka-mesos
EXPOSE 7000

ENTRYPOINT ["java", "-jar", "/opt/kafka-mesos/kafka-mesos-${KAFKA_MESOS_VERSION}.jar", "scheduler"]
