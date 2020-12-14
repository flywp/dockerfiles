# Dockerfiles

### PHP-FPM

Docker images for PHP-FPM.

#### Supported Versions

- PHP 7.2
- PHP 7.3
- PHP 7.4

### Getting the images

```bash
# PHP 7.2
docker image pull meghsh/php:7.2

# PHP 7.3
docker image pull meghsh/php:7.3

# PHP 7.4
docker image pull meghsh/php:7.4
```

### Using the images

One-off commands

```bash
# PHP 7.2
docker run --rm meghsh/php:7.2 bash -c "php -v"

# PHP 7.3
docker run --rm meghsh/php:7.3 bash -c "php -v"

# PHP 7.4
docker run --rm meghsh/php:7.4 bash -c "php -v"
```

With docker-compose:

```
version: "3"
services:
  php:
    image: "meghsh/php:7.3"
    volumes:
      - "./app:/var/www/html"
```
