ARG PHP_VERSION=7.4

# Stage for Composer
FROM php:${PHP_VERSION}-cli-alpine AS composer_builder
RUN apk add --no-cache curl \
    && curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer \
    && rm -rf /var/cache/apk/*

# Stage for WP-CLI
FROM php:${PHP_VERSION}-cli-alpine AS wpcli_builder
RUN apk add --no-cache curl \
    && curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar \
    && chmod +x wp-cli.phar \
    && mv wp-cli.phar /usr/local/bin/wp \
    && wp package install wp-cli/doctor-command:@stable --allow-root \
    && mkdir -p /home/www-data/.wp-cli \
    && mv ~/.wp-cli/packages /home/www-data/.wp-cli/ \
    && chown -R www-data:www-data /home/www-data/.wp-cli \
    && rm -rf /var/cache/apk/*

# Main build stage
FROM php:${PHP_VERSION}-fpm-alpine AS builder

LABEL maintainer="Tareq Hasan <tareq@wedevs.com>"

# Install build dependencies
RUN set -e && \
    apk add --no-cache --virtual .build-deps \
    autoconf g++ make bash sed ghostscript mysql-client imagemagick shadow msmtp unzip linux-headers ca-certificates \
    freetype-dev icu-dev openssl-dev imagemagick-dev libjpeg-turbo-dev libwebp-dev libpng-dev libzip-dev libssh2-dev git lz4-dev libxpm-dev

# Install the Microsoft ODBC driver for SQL Server (Linux)
RUN apk add --no-cache ca-certificates curl gnupg && \
    ARCH=$(uname -m) && \
    case $ARCH in x86_64) ARCH="amd64";; aarch64|arm64) ARCH="arm64";; *) echo "Unsupported architecture: $ARCH" && exit 1;; esac && \
    curl -sSL https://packages.microsoft.com/keys/microsoft.asc | gpg --import - && \
    curl -O -k "https://download.microsoft.com/download/9dcab408-e0d4-4571-a81a-5a0951e3445f/msodbcsql18_18.6.1.1-1_${ARCH}.apk" && \
    curl -O -k "https://download.microsoft.com/download/9dcab408-e0d4-4571-a81a-5a0951e3445f/msodbcsql18_18.6.1.1-1_${ARCH}.sig" && \
    curl -O -k "https://download.microsoft.com/download/b60bb8b6-d398-4819-9950-2e30cf725fb0/mssql-tools18_18.6.1.1-1_${ARCH}.apk" && \
    curl -O -k "https://download.microsoft.com/download/b60bb8b6-d398-4819-9950-2e30cf725fb0/mssql-tools18_18.6.1.1-1_${ARCH}.sig" && \
    gpg --verify msodbcsql18_18.6.1.1-1_${ARCH}.sig msodbcsql18_18.6.1.1-1_${ARCH}.apk && \
    gpg --verify mssql-tools18_18.6.1.1-1_${ARCH}.sig mssql-tools18_18.6.1.1-1_${ARCH}.apk && \
    apk add --allow-untrusted msodbcsql18_18.6.1.1-1_${ARCH}.apk mssql-tools18_18.6.1.1-1_${ARCH}.apk && \
    rm -f msodbcsql18_18.6.1.1-1_${ARCH}.apk msodbcsql18_18.6.1.1-1_${ARCH}.sig mssql-tools18_18.6.1.1-1_${ARCH}.apk mssql-tools18_18.6.1.1-1_${ARCH}.sig

# Install PHP extensions using php-extension-installer
RUN apk add --no-cache --virtual .phpize-deps $PHPIZE_DEPS \
    && curl -L -o /usr/local/bin/install-php-extensions https://github.com/mlocati/docker-php-extension-installer/releases/latest/download/install-php-extensions \
    && chmod +x /usr/local/bin/install-php-extensions \
    && install-php-extensions bcmath curl dom exif fileinfo gd hash igbinary intl json mbstring mysqli opcache openssl pcre pdo_mysql pdo_sqlite redis shmop simplexml sodium soap sockets ssh2 tokenizer xml xmlreader xmlwriter zip zlib apcu ftp relay pspell pcntl mongodb ldap imap grpc gmp gettext excimer ev calendar xsl sqlsrv pdo_sqlsrv pdo_pgsql

# Install imagick manually for PHP 8.3
RUN if [[ "$PHP_VERSION" == "8.3"* ]]; then \
        git clone https://github.com/Imagick/imagick.git /usr/src/php/ext/imagick && \
        cd /usr/src/php/ext/imagick && \
        phpize && \
        ./configure && \
        make && \
        make install && \
        docker-php-ext-enable imagick; \
    else \
        install-php-extensions imagick; \
    fi

# Clean up build dependencies
RUN apk del .build-deps .phpize-deps \
    && rm -rf /tmp/* /var/cache/apk/*

# Set recommended PHP.ini settings and configure error logging
COPY error-logging.ini expose.ini /usr/local/etc/php/conf.d/

# Configure sendmail path for MSMTP
RUN echo "sendmail_path = '/usr/bin/msmtp -t'" > /usr/local/etc/php/conf.d/mail.ini

# Copy Composer and WP-CLI from their respective stages
COPY --from=composer_builder /usr/local/bin/composer /usr/local/bin/composer
COPY --from=wpcli_builder /usr/local/bin/wp /usr/local/bin/wp
COPY --from=wpcli_builder /home/www-data/.wp-cli /home/www-data/.wp-cli

# Final stage
FROM php:${PHP_VERSION}-fpm-alpine

# Install runtime dependencies
RUN apk add --no-cache \
    bash sed ghostscript mysql-client imagemagick shadow msmtp unzip linux-headers \
    freetype icu openssl imagemagick libjpeg-turbo libwebp libpng libzip libssh2 git libgomp \
    libssh2-dev lz4 libavif libxpm lz4-libs && \
    rm -rf /var/cache/apk/*

# Copy built extensions and configs from the builder stage
COPY --from=builder /usr/local/etc/php /usr/local/etc/php
COPY --from=builder /usr/local/lib/php/extensions /usr/local/lib/php/extensions
COPY --from=builder /usr/local/bin /usr/local/bin
COPY --from=builder /home/www-data/.wp-cli /home/www-data/.wp-cli

# Ensure the entrypoint script is copied and has executable permissions
COPY docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh
RUN chmod +x /usr/local/bin/docker-entrypoint.sh

# Set pager for WP-CLI
ENV PAGER=less

# Volume and User settings
VOLUME /var/www/html

USER www-data

ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]
CMD ["php-fpm"]