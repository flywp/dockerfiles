#!/bin/bash

docker build --platform linux/amd64,linux/arm64 --build-arg OLS_VERSION=1.8.1 --build-arg PHP_VERSION=lsphp82 -t meghsh/openlitespeed:1.8.1-lsphp82 . --push
