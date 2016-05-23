FROM yyqqing/jre8:latest

ENV KAFKA_VERSION=0.9.0.1 KAFKA_SCALA_VERSION=2.11 KAFKA_MESOS_VERSION=0.9.5.1

ENV MESOS_VERSION 0.28.1
RUN apk --no-cache add curl
RUN apk --update add --virtual build-dependencies \
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
 && curl -sL http://www.apache.org/dist/mesos/$MESOS_VERSION/mesos-$MESOS_VERSION.tar.gz \
  | gunzip \
  | tar x -C /tmp/ \
 && cd /tmp/mesos-$MESOS_VERSION \
 && ./configure --disable-java --disable-python --disable-shared --prefix /tmp/target
# && rm -rf /tmp/* \
# && rm -rf /var/cache/apk/* \
# && apk del build-dependencies

# Add kafka-mesos & kafka
COPY ./kafka* /opt/kafka-mesos/

RUN apk add --update expat && \
	ln -s /opt/kafka-mesos/kafka-mesos-${KAFKA_MESOS_VERSION}.jar /opt/kafka-mesos/kafka-mesos.jar && \
	ln -s /opt/kafka-mesos/libmesos-0.28.1.so /usr/lib/libmesos.so

WORKDIR /opt/kafka-mesos
EXPOSE 7000

ENTRYPOINT ["java", "-jar", "/opt/kafka-mesos/kafka-mesos.jar", "scheduler"]
