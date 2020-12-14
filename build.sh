#!/bin/bash

docker build --build-arg PHP_VERSION=7.2 -t meghsh/php:7.2 -f  php/Dockerfile php
docker build --build-arg PHP_VERSION=7.3 -t meghsh/php:7.3 -f  php/Dockerfile php
docker build --build-arg PHP_VERSION=7.4 -t meghsh/php:7.4 -f  php/Dockerfile php