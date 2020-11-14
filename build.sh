#!/bin/bash

docker build --build-arg PHP_VERSION=7.3 -t tareq1988/php-wp:7.3 -f  wordpress/Dockerfile wordpress
docker build --build-arg PHP_VERSION=7.4 -t tareq1988/php-wp:7.4 -f  wordpress/Dockerfile wordpress