FROM registry.docker.singbada.cn:5000/xbdhub/jre8:latest

MAINTAINER Suolong <Suolong@singbada.cn>

ENV KAFKA_VERSION="0.8.2.1" SCALA_VERSION="2.10"

RUN apk add --update wget && \
	wget -q http://www.eu.apache.org/dist/kafka/${KAFKA_VERSION}/kafka_${SCALA_VERSION}-${KAFKA_VERSION}.tgz -O "/tmp/kafka_${SCALA_VERSION}-${KAFKA_VERSION}.tgz" && \
	tar xf /tmp/kafka_${SCALA_VERSION}-${KAFKA_VERSION}.tgz -C /opt

ENV KAFKA_HOME /opt/kafka_${SCALA_VERSION}-${KAFKA_VERSION}

COPY ./kafka-marathon-bootstrap.sh /usr/local/bin/

RUN chmod +x /usr/local/bin/kafka-marathon-bootstrap.sh

RUN mkdir -p /var/log/kafka

VOLUME ["/var/log/kafka"]

ENTRYPOINT ["/usr/local/bin/kafka-marathon-bootstrap.sh"]