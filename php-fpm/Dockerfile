FROM php:fpm-alpine

COPY ./php.ini /usr/local/etc/php/

ENV TZ=Asia/Shanghai
RUN mv /etc/localtime /etc/localtime_old && ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone && ln -sf /dev/stderr /var/log/php_errors.log

ENV PHPREDIS_VERSION 4.0.0

RUN apk update && apk upgrade --update \
    && apk add --no-cache --update openssl freetype libpng libjpeg-turbo \
    && apk add --no-cache --virtual .build-deps freetype-dev libpng-dev libjpeg-turbo-dev \
    && docker-php-source extract && touch /usr/src/php/.docker-delete-me \
    && curl -L -o /tmp/redis.tar.gz https://github.com/phpredis/phpredis/archive/$PHPREDIS_VERSION.tar.gz \
    && tar xfz /tmp/redis.tar.gz \
    && rm -r /tmp/redis.tar.gz \
    && mv phpredis-$PHPREDIS_VERSION /usr/src/php/ext/redis \
    && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ --with-png-dir=/usr/include/ \
    && docker-php-ext-install iconv zip pdo_mysql gd opcache redis\
    && apk del .build-deps && rm -rf /var/cache/apk/* \
    && docker-php-source delete