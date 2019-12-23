FROM composer

ENV TZ=Asia/Shanghai
RUN if [ -f /etc/localtime ] ; then mv /etc/localtime /etc/localtime_old ; fi
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

RUN apk upgrade --update && apk add --no-cache --update libzip openssl freetype libpng libjpeg-turbo \
    && apk add --no-cache --virtual .build-deps libzip-dev freetype-dev libpng-dev libjpeg-turbo-dev icu icu-dev icu-libs \
    && docker-php-ext-install iconv zip pdo_mysql opcache \
    && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
    && docker-php-ext-configure intl \
    && docker-php-ext-install gd intl \
    && apk del .build-deps && rm -rf /var/cache/apk/*

RUN composer config -g repo.packagist composer https://packagist.phpcomposer.com
