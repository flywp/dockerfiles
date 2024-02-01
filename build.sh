#!/bin/bash

docker build --platform linux/amd64 --build-arg PHP_VERSION=7.4 -t meghsh/php:7.4 -f php/Dockerfile php
docker build --platform linux/amd64 --build-arg PHP_VERSION=8.0 -t meghsh/php:8.0 -f php/Dockerfile php
docker build --platform linux/amd64 --build-arg PHP_VERSION=8.1 -t meghsh/php:8.1 -f php/Dockerfile php
docker build --platform linux/amd64 --build-arg PHP_VERSION=8.2 -t meghsh/php:8.2 -f php/Dockerfile php
docker build --platform linux/amd64 --build-arg PHP_VERSION=8.3 -t meghsh/php:8.3 -f php/Dockerfile php
