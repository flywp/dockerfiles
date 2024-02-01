#!/bin/bash

set -e

# Check if /etc/msmtprc exists and set permissions
if [ -f /etc/msmtprc ]; then
    echo "Configuring /etc/msmtprc permissions..."
    chown www-data:www-data /etc/msmtprc
    chmod 600 /etc/msmtprc
fi

# first arg is `-f` or `--some-option`
if [ "${1#-}" != "$1" ]; then
    set -- php-fpm "$@"
fi

exec "$@"
