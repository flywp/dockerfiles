# Use Ubuntu 22.04 as the base image
FROM ubuntu:22.04

# Set ARGs for customization
ARG PHP_VERSION=8.2
ARG LSPHP=lsphp82
ARG OLS_VERSION=1.8.5
ARG DEBIAN_FRONTEND=noninteractive
ARG TARGETPLATFORM

# Install necessary packages
RUN apt-get update && apt-get install -y --no-install-recommends \
    wget curl cron less tzdata gnupg2 ca-certificates procps libatomic1 \
    msmtp git mysql-client \
    && rm -rf /var/lib/apt/lists/*

# Download and install OpenLiteSpeed
RUN if [ "$TARGETPLATFORM" = "linux/amd64" ]; then \
        ARCH="x86_64"; \
    elif [ "$TARGETPLATFORM" = "linux/arm64" ]; then \
        ARCH="aarch64"; \
    else \
        echo "Unsupported architecture"; \
        exit 1; \
    fi \
    && wget "https://openlitespeed.org/packages/openlitespeed-$OLS_VERSION-$ARCH-linux.tgz" \
    && tar xzf openlitespeed-$OLS_VERSION-$ARCH-linux.tgz \
    && cd openlitespeed && ./install.sh \
    && echo "cloud-docker-$ARCH" > /usr/local/lsws/PLAT \
    && rm -rf /openlitespeed*

# Install LiteSpeed repository and PHP
RUN wget -O - https://repo.litespeed.sh | bash \
    && apt-get update && apt-get install -y --no-install-recommends \
    ${LSPHP} ${LSPHP}-common ${LSPHP}-mysql \
    ${LSPHP}-opcache ${LSPHP}-curl ${LSPHP}-intl \
    ${LSPHP}-imagick ${LSPHP}-redis ${LSPHP}-igbinary \
    ${LSPHP}-imap ${LSPHP}-ldap && \
    ln -s /usr/local/lsws/$LSPHP/bin/php /usr/bin/php && \
    ln -s /usr/local/lsws/$LSPHP/etc/php/$PHP_VERSION/mods-available/ /usr/local/lsws/php-mods-available && \
    rm -rf /var/lib/apt/lists/* && \
    apt-get clean && apt-get autoremove -y

# Install Composer and WP-CLI
RUN wget -qO /usr/local/bin/composer https://getcomposer.org/download/latest-stable/composer.phar \
    && chmod +x /usr/local/bin/composer \
    && wget -qO /usr/local/bin/wp https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar \
    && chmod +x /usr/local/bin/wp \
    && echo "alias wp='wp --allow-root'" >> /root/.bashrc

# Clearing Group ID 1000 for later use
RUN groupmod -g 999 lsadm

# Create necessary directories
RUN mkdir -p /var/www/html/public /var/www/html/logs \
    && chown -R www-data:www-data /var/www/html /usr/local/lsws

RUN echo "# Custom configurations" >> /usr/local/lsws/${LSPHP}/etc/php/${PHP_VERSION}/litespeed/php.ini && \
    echo "include_dir /usr/local/etc/php/custom-conf.d" >> /usr/local/lsws/${LSPHP}/etc/php/${PHP_VERSION}/litespeed/php.ini

# Configure PHP to use msmtp
RUN echo "sendmail_path = /usr/bin/msmtp -t" >> /usr/local/lsws/${LSPHP}/etc/php/${PHP_VERSION}/litespeed/php.ini

WORKDIR /var/www/html

# Copy configuration files
COPY httpd_config.conf /usr/local/lsws/conf/httpd_config.conf
COPY vhconf.conf /usr/local/lsws/conf/vhosts/flywp/vhconf.conf

# Update PHP path in httpd_config.conf
RUN sed -i "s/lsphp[0-9]\+\/bin\/lsphp/${LSPHP}\/bin\/lsphp/" /usr/local/lsws/conf/httpd_config.conf

# Set correct permissions for OpenLiteSpeed
RUN chown -R lsadm:lsadm /usr/local/lsws \
    && chmod 755 /usr/local/lsws/bin/*

# Copy and set permissions for entrypoint script
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

EXPOSE 80

ENTRYPOINT ["/entrypoint.sh"]