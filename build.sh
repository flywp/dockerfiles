#!/bin/bash

docker build --build-arg PHP_VERSION=7.4 -t meghsh/php:7.4 -f php/Dockerfile php
docker build --build-arg PHP_VERSION=8.0 -t meghsh/php:8.0 -f php/Dockerfile php
docker build --build-arg PHP_VERSION=8.1 -t meghsh/php:8.1 -f php/Dockerfile php
