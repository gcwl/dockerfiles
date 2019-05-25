ARG BASE_IMAGE=pytorch/pytorch:1.1.0-cuda10.0-cudnn7.5-devel

FROM $BASE_IMAGE
ARG BASE_IMAGE


# Install nvidia/apex
# ===================
# https://github.com/NVIDIA/apex/tree/master/examples/docker

# Base image must at least have pytorch and CUDA installed.
RUN echo "Installing Apex on top of ${BASE_IMAGE}"
# make sure we don't overwrite some existing directory called "apex"
WORKDIR /tmp/unique_for_apex
# uninstall Apex if present, twice to make absolutely sure :)
RUN pip uninstall -y apex || :
RUN pip uninstall -y apex || :
# SHA is something the user can touch to force recreation of this Docker layer,
# and therefore force cloning of the latest version of Apex
RUN SHA=ToUcHMe git clone https://github.com/NVIDIA/apex.git
WORKDIR /tmp/unique_for_apex/apex
RUN pip install -v --no-cache-dir --global-option="--cpp_ext" --global-option="--cuda_ext" .


# Install other python packages
# =============================
# install from conda
RUN /opt/conda/bin/conda install -y \
  -c conda-forge \
  ipython \
  jupyter \
  jupyter_contrib_nbextensions

RUN /opt/conda/bin/conda install -y \
  -c defaults -c nvidia -c rapidsai -c pytorch -c numba -c conda-forge \
  cudf=0.7 \
  cuml=0.7

# install from pip
RUN pip install -U \
  cython \
  pytorch-ignite \
  scipy \
  feather-format \
  pandas \
  scikit-learn \
  scikit-image \
  matplotlib \
  bokeh \
  seaborn \
  opencv-contrib-python \
  imageio \
  spacy \
  nltk \
  pytorch-pretrained-bert \
  ujson \
  easydict \
  tabulate \
  joblib \
  request

# build cmake (required by xgboost/lightgbm)
WORKDIR /tmp
RUN git clone https://github.com/Kitware/CMake.git
WORKDIR /tmp/CMake
RUN ./bootstrap && make && make install

# build xgboost (with gpu support)
# https://xgboost.readthedocs.io/en/latest/build.html#building-with-gpu-support
WORKDIR /opt
RUN git clone --recursive https://github.com/dmlc/xgboost
RUN mkdir -p /opt/xgboost/build
WORKDIR /opt/xgboost/build
## pick one of the following build method
# 1/ no gpu support
# RUN cmake .. && make -j4
# 2/ with single gpu support
RUN cmake .. -DUSE_CUDA=ON && make -j4
# 3/ with multi-gpu support (need to install nccl2 from https://developer.nvidia.com/nccl)
# RUN cmake .. -DUSE_CUDA=ON -DUSE_NCCL=ON -DNCCL_ROOT=/path/to/nccl2 && make -j4
# install xgboost for python
WORKDIR /opt/xgboost/python-package
RUN python setup.py install

# TODO build lightgbm
# https://github.com/Microsoft/LightGBM/blob/master/docs/Installation-Guide.rst#build-gpu-version
# https://pypi.org/project/lightgbm/
# WORKDIR /opt
# pip install lightgbm --install-option=--gpu


# clean up
# ========
RUN rm -rf /tmp/*
RUN /opt/conda/bin/conda clean -ya


# set default directory
# =====================
WORKDIR /workspace
