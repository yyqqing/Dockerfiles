FROM yyqqing/jre8:latest

ENV KAFKA_VERSION=0.9.0.1 \
	KAFKA_SCALA_VERSION=2.11 \
	KAFKA_MESOS_VERSION=0.9.5.1 \
	MESOS_VERSION=0.28.1

# Add kafka-mesos & kafka
COPY ./kafka* /opt/kafka-mesos/

RUN apk --update add --virtual build-dependencies \
   curl \
   make \
   patch \
   g++ \
   subversion-dev \
   zlib-dev \
   curl-dev \
   apr-dev \
   cyrus-sasl-dev \
   cyrus-sasl-crammd5 \
 && mkdir -p /tmp/target \
 && ln -s /opt/kafka-mesos/kafka-mesos-$KAFKA_MESOS_VERSION.jar /opt/kafka-mesos/kafka-mesos.jar \
 && curl -L http://www.apache.org/dist/mesos/$MESOS_VERSION/mesos-$MESOS_VERSION.tar.gz \
  | gunzip \
  | tar x -C /tmp/ \
 && cd /tmp/mesos-$MESOS_VERSION \
 && ./configure --disable-java --disable-python --disable-shared --prefix /tmp/target \
 && rm -rf /tmp/* \
 && rm -rf /var/cache/apk/* \
 && apk del build-dependencies

WORKDIR /opt/kafka-mesos
EXPOSE 7000

ENTRYPOINT ["java", "-jar", "/opt/kafka-mesos/kafka-mesos.jar", "scheduler"]
