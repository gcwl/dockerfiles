#!/bin/sh

# get free ports from host
function get_port () {
  (netstat -4 --all --numeric --tcp --udp | awk '{printf "%s\n%s\n", $4, $4}' | grep -oE '[0-9]+$'; seq ${2:-20000} ${3:-65000}) \
    | sort -n \
    | uniq -u \
    | shuf \
    | head -n ${1:-1}
}
PORTS=($(get_port 3))

# echo port binding info
cat << EOF
Binding ports [host:container]
- ${PORTS[0]}:8888
- ${PORTS[1]}:8899
- ${PORTS[2]}:8989
EOF


# run nvidia-docker
nvidia-docker run \
    -it --rm \
    --ipc="host" \
    -p 127.0.0.1:${PORTS[0]}:8888 \
    -p 127.0.0.1:${PORTS[1]}:8899 \
    -p 127.0.0.1:${PORTS[2]}:8989 \
    -v $(pwd):/workspace \
    -v $HOME/.torch:/root/.torch \
    -v $HOME/.pytorch_pretrained_bert:/root/.pytorch_pretrained_bert \
    transformer \
    bash

## shared memory segment size
# https://docs.nvidia.com/deeplearning/frameworks/user-guide/index.html#setincshmem
# https://docs.nvidia.com/deeplearning/frameworks/pytorch-release-notes/running.html
    # --ipc="host" \
    # --shm-size=2g \

