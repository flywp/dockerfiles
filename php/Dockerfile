# Original from official WordPress Docker file
# https://github.com/docker-library/wordpress/blob/master/php7.3/fpm-alpine/Dockerfile

ARG PHP_VERSION=7.4

FROM php:${PHP_VERSION}-fpm-alpine

LABEL maintainer="Tareq Hasan <tareq@hey.com>"

RUN if [ "$PHP_VERSION" == '7.4' ]; then GD_OPTIONS="--with-freetype --with-jpeg"; else GD_OPTIONS="--with-freetype-dir=/usr --with-jpeg-dir=/usr --with-png-dir=/usr"; fi

# persistent dependencies
RUN apk add --no-cache \
    # in theory, docker-entrypoint.sh is POSIX-compliant, but priority is a working, consistent image
    bash \
    # BusyBox sed is not sufficient for some of our sed expressions
    sed \
    # Ghostscript is required for rendering PDF previews
    ghostscript \
    # install mysql
    mysql-client \
    # Alpine package for "imagemagick" contains ~120 .so files, see: https://github.com/docker-library/wordpress/pull/497
    imagemagick

# install the PHP extensions we need (https://make.wordpress.org/hosting/handbook/handbook/server-environment/#php-extensions)
RUN set -ex; \
    \
    apk add --no-cache --virtual .build-deps \
    $PHPIZE_DEPS \
    freetype-dev \
    imagemagick-dev \
    libjpeg-turbo-dev \
    libpng-dev \
    libzip-dev \
    ; \
    \
    docker-php-ext-configure gd $GD_OPTIONS; \
    docker-php-ext-install -j "$(nproc)" \
    bcmath \
    exif \
    gd \
    mysqli \
    zip \
    ; \
    pecl install imagick-3.4.4; \
    pecl install redis; \
    docker-php-ext-enable imagick redis; \
    \
    runDeps="$( \
    scanelf --needed --nobanner --format '%n#p' --recursive /usr/local/lib/php/extensions \
    | tr ',' '\n' \
    | sort -u \
    | awk 'system("[ -e /usr/local/lib/" $1 " ]") == 0 { next } { print "so:" $1 }' \
    )"; \
    apk add --virtual .wordpress-phpexts-rundeps $runDeps; \
    apk del .build-deps


# set recommended PHP.ini settings
# see https://secure.php.net/manual/en/opcache.installation.php
RUN set -eux; \
    docker-php-ext-enable opcache;
COPY opcache-recommended.ini /usr/local/etc/php/conf.d/opcache-recommended.ini

# Configure Error Logging
# https://wordpress.org/support/article/editing-wp-config-php/#configure-error-logging
COPY error-logging.ini /usr/local/etc/php/conf.d/error-logging.ini

# Increase upload limit
COPY uploads.ini /usr/local/etc/php/conf.d/uploads.ini

# Don't expose PHP
COPY expose.ini /usr/local/etc/php/conf.d/expose.ini

# Donwload and install composer
RUN curl -sSL "https://getcomposer.org/installer" | php \
    && mv composer.phar /usr/local/bin/composer

# Install wp-cli
RUN curl -O "https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar" \
    && chmod +x wp-cli.phar \
    && mv wp-cli.phar /usr/local/bin/wp

# Set pager for WP-CLI
ENV PAGER=less

VOLUME /var/www/html

USER www-data
# COPY docker-entrypoint.sh /usr/local/bin/

# ENTRYPOINT ["docker-entrypoint.sh"]
CMD ["php-fpm"]