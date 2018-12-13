FROM php:alpine

WORKDIR /var/www/html

COPY ./php.ini /usr/local/etc/php/

ENV TZ=Asia/Shanghai
RUN mv /etc/localtime /etc/localtime_old && ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone && ln -sf /dev/stderr /var/log/php_errors.log

RUN apk upgrade --update && apk add --no-cache --update openssl freetype libpng libjpeg-turbo \
    && apk add --no-cache --virtual .build-deps freetype-dev libpng-dev libjpeg-turbo-dev \
    && docker-php-ext-install iconv zip pdo_mysql opcache \
    && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
    && docker-php-ext-install gd \
    && apk del .build-deps && rm -rf /var/cache/apk/*


ENV PHPREDIS_VERSION 4.2.0
RUN docker-php-source extract && touch /usr/src/php/.docker-delete-me \
    && curl -L -o /tmp/redis.tar.gz https://github.com/phpredis/phpredis/archive/$PHPREDIS_VERSION.tar.gz \
    && tar xfz /tmp/redis.tar.gz \
    && rm -r /tmp/redis.tar.gz \
    && mv phpredis-$PHPREDIS_VERSION /usr/src/php/ext/redis \
    && docker-php-ext-install redis \
    && docker-php-source delete

# Setup the Composer installer
RUN curl -o /tmp/composer-setup.php https://getcomposer.org/installer \
  && curl -o /tmp/composer-setup.sig https://composer.github.io/installer.sig \
  && php -r "if (hash_file('SHA384', '/tmp/composer-setup.php') === trim(file_get_contents('/tmp/composer-setup.sig'))) { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;" \ 
  && php /tmp/composer-setup.php --install-dir=/usr/local/bin/ --filename=composer \
  && php -r "unlink('/tmp/composer-setup.php');"
