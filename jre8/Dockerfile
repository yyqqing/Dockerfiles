FROM anapsix/alpine-java

MAINTAINER SuoLong <suolong@singbada.cn>

# Java Version and other ENV
ENV LANG=zh_CN.UTF-8 \
    TIMEZONE=Asia/Shanghai

# do all in one step
RUN apk upgrade --update && \
    apk add --update tzdata && \
    ## 设置时区
    cp /usr/share/zoneinfo/${TIMEZONE} /etc/localtime && \
    echo "${TIMEZONE}" > /etc/timezone && \
    echo "export LANG=${LANG}" > /etc/profile.d/locale.sh && \
    apk del tzdata && rm -v /var/cache/apk/* && \
    ntpd -d -q -n -p uk.pool.ntp.org

# EOF