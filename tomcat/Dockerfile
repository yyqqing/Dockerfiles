FROM registry.docker.singbada.cn:5000/xbdhub/jre8:latest

# Tomcat Version
ENV TOMCAT_VERSION_MAJOR=8 \
	TOMCAT_VERSION_FULL=8.0.33 \
	CATALINA_HOME=/opt/tomcat

# Download && install
# COPY ./apache-tomcat-${TOMCAT_VERSION_FULL}.tar.gz ./apache-tomcat-${TOMCAT_VERSION_FULL}.tar.gz.md5 ./

RUN apk add --update curl openssl && \
  curl -LO https://archive.apache.org/dist/tomcat/tomcat-${TOMCAT_VERSION_MAJOR}/v${TOMCAT_VERSION_FULL}/bin/apache-tomcat-${TOMCAT_VERSION_FULL}.tar.gz && curl -LO https://archive.apache.org/dist/tomcat/tomcat-${TOMCAT_VERSION_MAJOR}/v${TOMCAT_VERSION_FULL}/bin/apache-tomcat-${TOMCAT_VERSION_FULL}.tar.gz.md5 && \
  md5sum -c ./apache-tomcat-${TOMCAT_VERSION_FULL}.tar.gz.md5 &&\
  gunzip -c ./apache-tomcat-${TOMCAT_VERSION_FULL}.tar.gz | tar -xf - -C /opt &&\
  rm -f ./apache-tomcat-${TOMCAT_VERSION_FULL}.tar.gz ./apache-tomcat-${TOMCAT_VERSION_FULL}.tar.gz.md5 &&\
  ln -s /opt/apache-tomcat-${TOMCAT_VERSION_FULL} /opt/tomcat &&\
  rm -rf webapps/** /opt/tomcat/webapps/** &&\
  apk del curl && rm -rf /var/cache/apk/*

# Expose web port
EXPOSE 8080

# Launch Tomcat on startup
CMD ${CATALINA_HOME}/bin/catalina.sh run