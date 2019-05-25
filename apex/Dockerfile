ARG PREFIX
FROM ${PREFIX}/pytorch

# install nvidia/apex
# https://github.com/NVIDIA/apex/tree/master/examples/docker
# Base image must at least have pytorch and CUDA installed.
# ==========================================================
# make sure we don't overwrite some existing directory called "apex"
WORKDIR /tmp/unique_for_apex
# uninstall Apex if present, twice to make absolutely sure :)
RUN pip uninstall -y apex || : && pip uninstall -y apex || :
# SHA is something the user can touch to force recreation of this Docker layer,
# and therefore force cloning of the latest version of Apex
RUN SHA=ToUcHMe git clone https://github.com/NVIDIA/apex.git \
  && cd apex \
  && pip install -v --no-cache-dir --global-option="--cpp_ext" --global-option="--cuda_ext" . \
  && rm -rf /tmp/*

# set default directory
WORKDIR /workspace
