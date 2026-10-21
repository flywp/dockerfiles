#!/bin/sh
# Run a command up to 5 times, 30 seconds apart.
# pecl.php.net sometimes returns 504 or "No releases available".
for attempt in 1 2 3 4 5; do
    "$@" && exit 0
    echo "Attempt $attempt of 5 failed: $*" >&2
    [ "$attempt" -lt 5 ] && sleep 30
done
exit 1
