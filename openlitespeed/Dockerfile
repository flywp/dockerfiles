# Stage 1: Build stage
FROM debian:bullseye-slim as builder

ARG PHP_VERSION=lsphp82
ARG OLS_VERSION=1.8.1
ARG TARGETPLATFORM

# Install required packages for building
RUN apt-get update && apt-get install -y --no-install-recommends wget curl tzdata zip unzip ghostscript git gnupg2 ca-certificates lsb-release apt-transport-https libatomic1 procps

# Install openlitespeed for the target platform
RUN if [ "$TARGETPLATFORM" = "linux/amd64" ]; then \
        wget "https://openlitespeed.org/packages/openlitespeed-$OLS_VERSION-x86_64-linux.tgz" && \
        tar xzf openlitespeed-$OLS_VERSION-x86_64-linux.tgz && cd openlitespeed && ./install.sh && \
        echo 'cloud-docker' > /usr/local/lsws/PLAT && rm -rf /openlitespeed && rm /openlitespeed-$OLS_VERSION-x86_64-linux.tgz; \
    elif [ "$TARGETPLATFORM" = "linux/arm64" ]; then \
        wget "https://openlitespeed.org/packages/openlitespeed-$OLS_VERSION-aarch64-linux.tgz" && \
        tar xzf openlitespeed-$OLS_VERSION-aarch64-linux.tgz && cd openlitespeed && ./install.sh && \
        echo 'cloud-docker' > /usr/local/lsws/PLAT && rm -rf /openlitespeed && rm /openlitespeed-$OLS_VERSION-aarch64-linux.tgz; \
    fi

RUN wget -O - https://repo.litespeed.sh | sh && \
    apt-get update && \
    apt-get install -y --no-install-recommends $PHP_VERSION $PHP_VERSION-common $PHP_VERSION-mysql $PHP_VERSION-opcache \
    $PHP_VERSION-curl $PHP_VERSION-imagick $PHP_VERSION-redis $PHP_VERSION-intl && \
    if [[ $PHP_VERSION == lsphp7* ]]; then apt-get install -y --no-install-recommends $PHP_VERSION-json; fi && \
    ln -s /usr/local/lsws/$PHP_VERSION/bin/php /usr/bin/php

# Install Composer
RUN wget -O composer-setup.php https://getcomposer.org/installer && \
    php composer-setup.php --install-dir=/usr/local/bin --filename=composer && \
    rm composer-setup.php

# Install WP-CLI
RUN wget -O /usr/local/bin/wp https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && \
    chmod +x /usr/local/bin/wp

# Stage 2: Runtime stage
FROM debian:bullseye-slim

# Arguments for PHP version and OLS version
ARG PHP_VERSION
ARG TARGET_PLATFORM

# Update www-data user with UID 1000
RUN usermod -u 1000 www-data

# Folder for logs
RUN mkdir -p /var/www/html/public /var/www/html/logs && chown -R www-data:www-data /var/www/html

# Install required runtime packages
RUN apt-get update && apt-get install -y tzdata grep msmtp unzip zip sed ghostscript libatomic1 procps

# Copy the built OpenLiteSpeed and PHP from the build stage
COPY --from=builder /usr/local/lsws /usr/local/lsws
COPY --from=builder /usr/local/bin/composer /usr/local/bin/composer
COPY --from=builder /usr/local/bin/wp /usr/local/bin/wp

# Set work directory
WORKDIR /var/www/html

RUN ln -s /usr/local/lsws/$PHP_VERSION/bin/php /usr/bin/php

# Copy configuration files
COPY httpd_config.conf /usr/local/lsws/conf/httpd_config.conf
COPY vhconf.conf /usr/local/lsws/conf/vhosts/flywp/vhconf.conf

# Copy entrypoint script
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Expose port 80
EXPOSE 80

# Change ownership
RUN chown -R www-data:www-data /usr/local/lsws /var/www/html

# Set entrypoint and CMD
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]