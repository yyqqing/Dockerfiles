FROM composer

RUN composer config -g repo.packagist composer https://packagist.phpcomposer.com

ENV TZ=Asia/Shanghai
RUN [ -f /etc/localtime ] && mv /etc/localtime /etc/localtime_old
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

RUN apk upgrade --update && apk add --no-cache --update openssl freetype libpng libjpeg-turbo \
    && apk add --no-cache --virtual .build-deps freetype-dev libpng-dev libjpeg-turbo-dev \
    && docker-php-ext-install iconv zip pdo_mysql opcache \
    && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
    && docker-php-ext-install gd \
    && apk del .build-deps && rm -rf /var/cache/apk/*