#!/bin/bash
set -e

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
