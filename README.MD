# Dockerfiles

### WordPress PHP-FPM

WordPress specific docker images for PHP-FPM.

It _doesn't contain_ WordPress, like the [official image](https://hub.docker.com/_/wordpress), but the images are built to run WordPress having the optimized PHP-FPM packages.

#### Supported Versions

- PHP 7.3
- PHP 7.4

### Getting the images

```bash
# PHP 7.3
docker image pull tareq1988/php-wp:7.3

# PHP 7.4
docker image pull tareq1988/php-wp:7.4
```

### Using the images

One-off commands

```bash
# PHP 7.4
docker run --rm tareq1988/php-wp:7.4 bash -c "php -v"

# PHP 7.3
docker run --rm tareq1988/php-wp:7.3 bash -c "php -v"
```

With docker-compose:

```
version: "3"
services:
  php:
    image: "tareq1988/php-wp:7.3"
    volumes:
      - "./app:/var/www/html"
```
