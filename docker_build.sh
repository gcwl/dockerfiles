#!/bin/sh

PREFIX=$USER
NAME=$(basename $(pwd))
VERSION=${1:-latest}

docker build --build-arg WHOAMI=$(whoami) -t $PREFIX/$NAME:$VERSION .
