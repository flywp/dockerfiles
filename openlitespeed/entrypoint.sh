#!/bin/bash
set -e

echo "www-data UID is: $(id -u www-data) and GID $(id -g www-data)"


# Check and set PGID and PUID
if [ -z "$PGID" ] || [ -z "$PUID" ]; then
    echo "PGID or PUID not set, using defaults."
    PGID=1000
    PUID=1000
fi
echo "setting UID to $PGID and GUID $PUID"

groupmod -g $PGID www-data
usermod -u $PUID www-data

# echo "www-data group ID is: $(id -u www-data) and $(id -g www-data)"
# echo "$(whoami) group ID is: $(id -u) and $(id -g)"

# Ensure correct permissions
chown -R www-data:www-data /var/www/html
chown -R lsadm:lsadm /usr/local/lsws
find /var/www/html -type d -exec chmod 755 {} \;
find /var/www/html -type f -exec chmod 644 {} \;


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
