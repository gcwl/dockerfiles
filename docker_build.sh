#!/bin/sh

PREFIX=$(whoami)
NAME=$(basename $(pwd))

docker build -t $PREFIX/$NAME $@ .
