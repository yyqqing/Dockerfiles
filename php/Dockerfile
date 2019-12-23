FROM php:alpine

WORKDIR /var/www/html

COPY ./php.ini /usr/local/etc/php/

ENV TZ=Asia/Shanghai
RUN if [ -f /etc/localtime ] ; then mv /etc/localtime /etc/localtime_old ; fi
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone && ln -sf /dev/stderr /var/log/php_errors.log

RUN apk upgrade --update && apk add --no-cache --update libzip openssl freetype libpng libjpeg-turbo icu icu-libs \
    && apk add --no-cache --virtual .build-deps libzip-dev freetype-dev libpng-dev libjpeg-turbo-dev icu-dev \
    && docker-php-ext-install iconv zip pdo_mysql mysqli opcache \
    && docker-php-ext-configure intl \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install gd intl \
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

RUN curl -o /tmp/phpcs.phar https://squizlabs.github.io/PHP_CodeSniffer/phpcs.phar && \
    mv /tmp/phpcs.phar /usr/local/bin/phpcs && \
    chmod +x /usr/local/bin/phpcs
RUN /usr/local/bin/phpcs --config-set show_progress 1 && \
    /usr/local/bin/phpcs --config-set colors 1 && \
    /usr/local/bin/phpcs --config-set report_width 140 && \
    /usr/local/bin/phpcs --config-set encoding utf-8
RUN curl -o /tmp/phpcbf.phar https://squizlabs.github.io/PHP_CodeSniffer/phpcbf.phar && \
    mv /tmp/phpcbf.phar /usr/local/bin/phpcbf && \
    chmod +x /usr/local/bin/phpcbf
CMD ["phpcbf"]
CMD ["phpcs"]
