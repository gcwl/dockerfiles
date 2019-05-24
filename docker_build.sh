#!/bin/sh

PREFIX=$USER
NAME=$(basename $(pwd))
NOW=$(date $@ "+%Y.%m.%d-%H%M")
VERSION=${1:-$NOW}

docker build --build-arg WHOAMI=$(whoami) -t $PREFIX/$NAME:$VERSION .
