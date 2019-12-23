FROM php:fpm-alpine

COPY ./php.ini /usr/local/etc/php/

ENV TZ=Asia/Shanghai
RUN if [ -f /etc/localtime ] ; then mv /etc/localtime /etc/localtime_old ; fi
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone && ln -sf /dev/stderr /var/log/php_errors.log

ENV PHPREDIS_VERSION 5.1.1

RUN apk --no-cache update && apk --no-cache upgrade --update \
    && apk add --no-cache --update libzip openssl freetype libpng libjpeg-turbo icu icu-libs \
    && apk add --no-cache --virtual .build-deps libzip-dev openssl-dev freetype-dev libpng-dev libjpeg-turbo-dev icu-dev \
    && docker-php-source extract && touch /usr/src/php/.docker-delete-me \
    && curl -L -o /tmp/redis.tar.gz https://github.com/phpredis/phpredis/archive/$PHPREDIS_VERSION.tar.gz \
    && tar xfz /tmp/redis.tar.gz \
    && rm -r /tmp/redis.tar.gz \
    && mv phpredis-$PHPREDIS_VERSION /usr/src/php/ext/redis \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-configure pdo_mysql --with-pdo-mysql=mysqlnd \
    && docker-php-ext-configure intl \
    && docker-php-ext-install iconv zip pdo pdo_mysql mysqli gd opcache redis intl\
    && apk del .build-deps && rm -rf /var/cache/apk/* \
    && docker-php-source delete
