FROM php:7-apache

# Apache setup
RUN a2enmod rewrite && \
    sed -ri -e 's!Listen 80!Listen 8080!g' ${APACHE_CONFDIR}/ports.conf

# PHP setup
RUN apt-get update && \
    apt-get install -y git libpq-dev && \
    rm -r /var/lib/apt/lists/* && \
    docker-php-ext-install pgsql

COPY . /usr/src/todo

# App setup
RUN curl -o /tmp/composer-installer https://getcomposer.org/installer && \
    php /tmp/composer-installer --install-dir=/tmp && \
    (cd /usr/src/todo && php /tmp/composer.phar install --no-interaction --no-ansi --optimize-autoloader) && \
    cp -R /usr/src/todo/* /var/www/html/ && \
    rm -rf /usr/src/todo

EXPOSE 8080

