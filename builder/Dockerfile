ARG PHP_VERSION=8.3

# Build image: the production PHP image (Composer, WP-CLI, full extension set)
# with Node.js + package managers layered on top. Used to run application build
# steps — composer install, npm/yarn/pnpm install, and asset builds (Vite, etc.)
# — in a single ephemeral container during deployment. Runtime containers
# (php-fpm, nginx) stay lean; this image is build-time only.
#
# Because it is FROM meghsh/php:${PHP_VERSION}, the PHP version and the full set
# of PHP extensions match runtime exactly, so `composer install` platform checks
# pass without --ignore-platform-reqs.
# Set PHP_IMAGE to build on a test tag of the PHP image.
ARG PHP_IMAGE=meghsh/php:${PHP_VERSION}
FROM ${PHP_IMAGE}

LABEL maintainer="Tareq Hasan <tareq@wedevs.com>"

# Switch to root to install system + global packages.
USER root

# Node.js, npm, and the common package managers (yarn, pnpm).
# Installed globally under /usr/local so they are runnable by any UID — deploys
# run this image as the site's uid:gid (--user) so build artifacts (vendor/,
# node_modules/, public/build) are written into the bind-mounted release with
# correct ownership.
RUN apk add --no-cache nodejs npm \
    && npm install -g --force yarn pnpm \
    && npm cache clean --force \
    && rm -rf /var/cache/apk/* /root/.npm

# Plain tool image: drop the inherited php-fpm entrypoint so the image just runs
# the command it is given (composer / npm / bash -c '...').
ENTRYPOINT []
USER www-data
WORKDIR /var/www/html
CMD ["bash"]
