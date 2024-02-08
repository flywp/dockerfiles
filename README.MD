# Dockerfiles

### PHP-FPM

Docker images for PHP-FPM.

#### Supported Versions

- PHP 7.4
- PHP 8.0
- PHP 8.1
- PHP 8.2
- PHP 8.3

### Getting the images

```bash
# PHP 7.4
docker image pull meghsh/php:7.4

# PHP 8.1
docker image pull meghsh/php:8.1

# PHP 8.2
docker image pull meghsh/php:8.2

# PHP 8.3
docker image pull meghsh/php:8.3
```

### Using the images

One-off commands

```bash
# PHP 7.4
docker run --rm meghsh/php:7.4 bash -c "php -v"

# PHP 8.0
docker run --rm meghsh/php:8.0 bash -c "php -v"

# PHP 8.2
docker run --rm meghsh/php:8.2 bash -c "php -v"

# PHP 8.3
docker run --rm meghsh/php:8.3 bash -c "php -v"
```

With docker-compose:

```
version: "3.5"
services:
  php:
    image: "meghsh/php:7.4"
    volumes:
      - "./app:/var/www/html"
```
