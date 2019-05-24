#!/bin/sh

GREP=/usr/bin/grep

# get free/unprivileged ports (20000-65000)
get_port () {
  (netstat -4 --all --numeric --tcp --udp \
    | awk '{printf "%s\n%s\n", $4, $4}' \
    | $GREP -oE '[0-9]+$'; \
   seq ${2:-20000} ${3:-65000}) \
      | sort -n \
      | uniq -u \
      | shuf \
      | head -n ${1:-1}
}

# run nvidia-docker
run () {
  local PORTS=($(get_port 3))
  local IMAGE=${1}

  # echo port binding info
  cat << EOF
Binding ports [host:container]
- ${PORTS[0]}:8888
- ${PORTS[1]}:8889
- ${PORTS[2]}:8890
EOF

  nvidia-docker run \
    -it --rm \
    --ipc="host" \
    -p 127.0.0.1:${PORTS[0]}:8888 \
    -p 127.0.0.1:${PORTS[1]}:8889 \
    -p 127.0.0.1:${PORTS[2]}:8890 \
    -v $(pwd):/workspace \
    -v $HOME/.torch:/root/.torch \
    -v $HOME/.pytorch_pretrained_bert:/root/.pytorch_pretrained_bert \
    $IMAGE \
    bash

  ## shared memory segment size
  # https://docs.nvidia.com/deeplearning/frameworks/user-guide/index.html#setincshmem
  # https://docs.nvidia.com/deeplearning/frameworks/pytorch-release-notes/running.html
      # --ipc="host" \
      # --shm-size=2g \
}

# select docker image via fzf
# only show images with tag=latest for selection
IFS=$'\n' MATCH=$(docker images | $GREP "^$(whoami)" | awk '$2=="latest" {print $1}' | fzf)

# run target image
[ -n "$MATCH" ] && run $MATCH || echo "No docker image selected."
