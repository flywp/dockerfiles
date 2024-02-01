ARG PHP_VERSION=7.4

FROM php:${PHP_VERSION}-fpm-alpine

LABEL maintainer="Tareq Hasan <tareq@wedevs.com>"

# Install and build dependencies
RUN set -e; \
    apk add --no-cache bash sed ghostscript mysql-client imagemagick shadow msmtp unzip linux-headers \
    freetype-dev icu-dev openssl-dev imagemagick-dev libjpeg-turbo-dev libwebp-dev libpng-dev libzip-dev libssh2-dev; \
    apk add --no-cache --virtual .build-deps $PHPIZE_DEPS; \
    docker-php-ext-configure gd --with-freetype --with-jpeg --with-webp; \
    docker-php-ext-install -j "$(nproc)" bcmath exif gd intl mysqli zip pcntl pdo_mysql ftp sockets; \
    pecl install imagick-3.6.0 redis apcu timezonedb igbinary ssh2 \
    && docker-php-ext-enable imagick redis igbinary apcu ssh2; \
    apk del .build-deps; \
    rm -r /tmp/pear;

# Set recommended PHP.ini settings and configure error logging
COPY error-logging.ini expose.ini /usr/local/etc/php/conf.d/

# Install Composer and WP-CLI
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer \
    && curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar \
    && chmod +x wp-cli.phar \
    && mv wp-cli.phar /usr/local/bin/wp

# Set pager for WP-CLI
ENV PAGER=less

# Volume and User settings
VOLUME /var/www/html
USER www-data

# Entry point and command
COPY docker-entrypoint.sh /usr/local/bin/
ENTRYPOINT ["docker-entrypoint.sh"]
CMD ["php-fpm"]
