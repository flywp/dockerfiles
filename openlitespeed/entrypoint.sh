#!/bin/bash
set -e

echo "www-data UID is: $(id -u www-data) and GID $(id -g www-data)"

# Check and set PGID and PUID separately
if [ -z "$PGID" ]; then
    echo "PGID not set, using default."
    PGID=1000
fi

if [ -z "$PUID" ]; then
    echo "PUID not set, using default."
    PUID=1000
fi

echo "setting GID to $PGID and UID to $PUID"

groupmod -g $PGID www-data
usermod -u $PUID www-data

# Ensure correct permissions
chown -R www-data:www-data /var/www/html
chown -R lsadm:lsadm /usr/local/lsws

# Start OpenLiteSpeed
echo "Starting OpenLiteSpeed..."
if ! /usr/local/lsws/bin/lswsctrl start; then
    echo "Failed to start OpenLiteSpeed. Checking error log:"
    tail -n 50 /usr/local/lsws/logs/error.log
    exit 1
fi

# Execute custom command if provided
if [ $# -gt 0 ]; then
    exec "$@"
else
    # If no command is provided, tail the error log
    echo "No command provided, tailing error log..."
    tail -f /usr/local/lsws/logs/error.log
fi
