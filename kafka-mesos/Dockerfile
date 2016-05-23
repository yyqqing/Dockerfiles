FROM yyqqing/jre8:latest

# Add kafka-mesos & kafka
COPY ./kafka* /opt/kafka-mesos/

WORKDIR /opt/kafka-mesos
EXPOSE 7000

ENTRYPOINT ["java", "-jar", "/opt/kafka-mesos/kafka-mesos-0.9.5.1.jar", "scheduler"]
